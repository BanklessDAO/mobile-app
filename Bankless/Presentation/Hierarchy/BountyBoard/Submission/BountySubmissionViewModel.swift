//
//  Created with ♥ by BanklessDAO contributors on 2021-11-11.
//  Copyright (C) 2021 BanklessDAO.

//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU Affero General Public License as
//  published by the Free Software Foundation, either version 3 of the
//  License, or (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU Affero General Public License for more details.
//
//  You should have received a copy of the GNU Affero General Public License
//  along with this program.  If not, see https://www.gnu.org/licenses/.
//
    

import Foundation
import RxSwift
import RxCocoa

final class BountySubmissionViewModel: BaseViewModel, BountyBoardServiceDependency {
    // MARK: - Input/Output -
    
    struct Input {
        let resultURL: Driver<String>
        let notes: Driver<String>
        let message: Driver<String>
        let submit: Driver<Void>
    }
    
    struct Output {
        let title: Driver<String>
        let validationErrors: Driver<[ValidationError]>
    }
    
    // MARK: - Data -
    
    private let bounty: Bounty
    
    // MARK: - Components -
    
    var bountyBoardService: BountyBoardService!
    
    // MARK: - Events -
    
    struct Events {
        let bountyHasBeenSubmitted = PublishRelay<Bounty>()
    }
    
    let events = Events()
    
    // MARK: - Initializers -
    
    init(bounty: Bounty, container: DependencyContainer? = nil) {
        self.bounty = bounty
        super.init(container: container)
    }
    
    // MARK: - Transformer -
    
    func transform(input: Input) -> Output {
        let validationErrors = validation(resultURL: input.resultURL)
        
        let validationPass = input.submit
            .withLatestFrom(validationErrors)
            .filter({ $0.isEmpty })
        
        bindSubmission(
            resultURL: validationPass.withLatestFrom(input.resultURL),
            notes: validationPass.withLatestFrom(input.notes),
            message: validationPass.withLatestFrom(input.message)
        )
        
        return Output(
            title: .just(bounty.title),
            validationErrors: validationErrors
        )
    }
    
    private func validation(
        resultURL: Driver<String>
    ) -> Driver<[ValidationError]> {
        return resultURL
            .map({ urlString in
                guard !urlString.isEmpty // TODO: Web3-friendly URL validation?
                else {
                    return [.resultURL]
                }
                
                return []
            })
    }
    
    private func bindSubmission(
        resultURL: Driver<String>,
        notes: Driver<String>,
        message: Driver<String>
    ) {
        Driver.combineLatest(resultURL, notes, message) { (resultURL: $0, notes: $1, message: $2) }
            .asObservable()
            .flatMapLatest({ [weak self] input -> Completable in
                guard let self = self else { return .empty() }
                
                return self.bountyBoardService
                    .submitBounty(
                        request: .init(
                            id: self.bounty.id,
                            resultURL: input.resultURL,
                            notes: input.notes,
                            discordMessage: input.message
                        )
                    )
                    .map({ $0.bounty })
                    .do(onNext: { [weak self] bounty in
                        guard let self = self else { return }
                        
                        NotificationCenter.default.post(
                            name: NotificationEvent.bountyHasBeenUpdated.notificationName,
                            object: bounty
                        )
                        
                        self.events.bountyHasBeenSubmitted.accept(bounty)
                    })
                    .handleError()
                    .flatMap({ _ in Completable.empty() })
                    .asCompletable()
            })
            .subscribe()
            .disposed(by: disposer)
    }
}

extension BountySubmissionViewModel {
    enum ValidationError: Error, LocalizedError {
        case resultURL
        
        var errorDescription: String? {
            switch self {
                
            case .resultURL:
                return NSLocalizedString(
                    "bounty.submission.link.validation.error.message",
                    value: "Invalid URL",
                    comment: ""
                )
            }
        }
    }
}
