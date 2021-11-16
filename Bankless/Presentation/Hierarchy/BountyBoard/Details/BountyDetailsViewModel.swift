//
//  Created with ♥ by BanklessDAO contributors on 2021-11-12.
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

final class BountyDetailsViewModel: BaseViewModel, BountyBoardServiceDependency {
    // MARK: - Input/Output -
    
    struct Input {
        let lifecycleAction: Driver<Void>
        let tapRequestedBy: Driver<Void>
        let tapClaimedBy: Driver<Void>
    }
    
    struct Output {
        let title: Driver<String>
        let reward: Driver<String>
        let status: Driver<(title: String, color: UIColor)>
        let lifecycleActionTitle: Driver<String?>
        let description: Driver<String>
        let criteria: Driver<String>
        let requestedByViewModel: Driver<IdentityStripeViewModel>
        let claimedByViewModel: Driver<IdentityStripeViewModel?>
    }
    
    // MARK: - Data -
    
    private let bounty: BehaviorRelay<Bounty>
    
    // MARK: - Components -
    
    var bountyBoardService: BountyBoardService!
    
    // MARK: - Events -
    
    struct Events {
        let bountySubmitRequest = PublishRelay<Bounty>()
    }
    
    let events = Events()
    
    // MARK: - Initializers -
    
    init(bounty: Bounty, container: DependencyContainer? = nil) {
        self.bounty = BehaviorRelay<Bounty>(value: bounty)
        super.init(container: container)
    }
    
    // MARK: - Transformer -
    
    func transform(input: Input) -> Output {
        bindLifecycleAction(input: input.lifecycleAction)
        subscribeToBountyUpdates()
        
        return Output(
            title: bounty.map({ $0.title }).asDriver(onErrorDriveWith: .empty()),
            reward: self.rewardString().asDriver(onErrorDriveWith: .empty()),
            status: bounty
                .map({ (title: $0.status.title, color: $0.status.colorCode) })
                .asDriver(onErrorDriveWith: .empty()),
            lifecycleActionTitle: bounty
                .map({ $0.status.availableLifecycleActionTitle?.uppercased() })
                .asDriver(onErrorDriveWith: .empty()),
            description: bounty.map({ $0.descrtiption }).asDriver(onErrorDriveWith: .empty()),
            criteria: bounty.map({ $0.criteria }).asDriver(onErrorDriveWith: .empty()),
            requestedByViewModel: bounty
                .map({ $0.createdBy })
                .map({ IdentityStripeViewModel(mode: .user($0)) })
                .asDriver(onErrorDriveWith: .empty()),
            claimedByViewModel: bounty
                .map({ $0.claimedBy })
                .map({ $0 != nil ? IdentityStripeViewModel(mode: .user($0!)) : nil })
                .asDriver(onErrorDriveWith: .empty())
        )
    }
    
    private func rewardString() -> Observable<String> {
        return bounty
            .map({
                String(Int($0.reward.amount)) + " " + $0.reward.currency
            })
    }
    
    // MARK: - Actions -
    
    private func bindLifecycleAction(input: Driver<Void>) {
        input.asObservable()
            .flatMap({ [weak self] _ -> Completable in
                guard let self = self else { return .empty() }
                
                switch self.bounty.value.status {
                    
                case .open:
                    return self.claimBounty()
                case .inProgress:
                    self.events.bountySubmitRequest.accept(self.bounty.value)
                    return .empty()
                default:
                    fatalError("unexpected action")
                }
            })
            .subscribe()
            .disposed(by: disposer)
    }
    
    // MARK: - Claim bounty -
    
    private func claimBounty() -> Completable {
        return bountyBoardService
            .claimBounty(request: .init(id: bounty.value.id))
            .map({ $0.bounty })
            .do(onNext: { bounty in
                NotificationCenter.default.post(
                    name: NotificationEvent.bountyHasBeenUpdated.notificationName, object: bounty
                )
            })
            .flatMap({ _ in Completable.empty() })
            .asCompletable()
    }
    
    // MARK: - Subscriptions -
    
    private func subscribeToBountyUpdates() {
        NotificationCenter.default.rx
            .notification(NotificationEvent.bountyHasBeenUpdated.notificationName, object: nil)
            .map({ $0.object as? Bounty }).filter({ $0 != nil }).map({ $0! })
            .subscribe(onNext: { [weak self] bounty in
                self?.bounty.accept(bounty)
            })
            .disposed(by: disposer)
    }
}
