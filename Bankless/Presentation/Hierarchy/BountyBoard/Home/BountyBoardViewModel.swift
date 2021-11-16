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
import Foundation
import RxSwift
import RxCocoa

class BountyBoardViewModel: BaseViewModel, BountyBoardServiceDependency {
    // MARK: - Input/Output -
    
    struct Input {
        let refresh: Driver<Void>
        let selection: Driver<ViewModelFoundation>
    }
    
    struct Output {
        let title: Driver<String>
        let bountyViewModels: Driver<[BountyViewModel]>
    }
    
    // MARK: - Events -
    
    struct Events {
        let bountyTransitionRequest = PublishRelay<Bounty>()
    }
    
    let events = Events()
    
    // MARK: - Constants -
    
    private static let title = NSLocalizedString(
        "bounty_board.list.title", value: "Bounties", comment: ""
    )
    
    // MARK: - Properties -
    
    private var autoRefresh = PublishRelay<Void>()
    
    // MARK: - Components -
    
    var bountyBoardService: BountyBoardService!
    
    // MARK: - Transformer -
    
    func transform(input: Input) -> Output {
        bindSelection(input: input.selection)
        subscribeToBountyUpdates()
        
        let bountyViewModels = bounties(
            refreshInput: Driver.merge(
                [input.refresh, autoRefresh.asDriver(onErrorDriveWith: .empty())]
            )
        )
            .map({ $0.map(BountyViewModel.init) })
        
        return Output(
            title: .just(BountyBoardViewModel.title),
            bountyViewModels: bountyViewModels.asDriver(onErrorDriveWith: .empty())
        )
    }
    
    // MARK: - List -
    
    private func bounties(
        refreshInput: Driver<Void>
    ) -> Observable<[Bounty]> {
        return refreshInput
            .asObservable()
            .flatMapLatest({ [weak self] _ -> Observable<[Bounty]> in
                guard let self = self else { return .empty() }
                
                return self.bountyBoardService.listBounties()
                    .map({ $0.bounties })
            })
    }
    
    // MARK: - Selection -
    
    private func bindSelection(
        input: Driver<ViewModelFoundation>
    ) {
        input.asObservable()
            .subscribe(onNext: { [weak self] viewModel in
                switch viewModel {
                    
                case let bountyViewModel as BountyViewModel:
                    self?.events.bountyTransitionRequest
                        .accept(bountyViewModel.bounty)
                default:
                    break
                }
            })
            .disposed(by: disposer)
    }
    
    // MARK: - Subscriptions -
    
    private func subscribeToBountyUpdates() {
        NotificationCenter.default.rx
            .notification(NotificationEvent.bountyHasBeenUpdated.notificationName, object: nil)
            .map({ $0.object as? Bounty }).filter({ $0 != nil }).map({ $0! })
            .subscribe(onNext: { [weak self] bounty in
                self?.autoRefresh.accept(())
            })
            .disposed(by: disposer)
    }
}
