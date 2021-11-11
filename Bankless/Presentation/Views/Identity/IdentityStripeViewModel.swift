//
//  Created with ♥ by BanklessDAO contributors on 2021-11-10.
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

final class IdentityStripeViewModel: BaseViewModel {
    // MARK: - Input/Output -
    
    struct Input {
        let tap: Driver<Void>
    }
    
    struct Output {
        let domainIcon: Driver<UIImage>
        let title: Driver<String>
    }
    
    // MARK: - Constants -
    
    private static let discordIcon = UIImage(named: "discord_icon")!
    private static let titlePlaceholder = NSLocalizedString(
        "identity.title.placeholder",
        value: "Unknown User",
        comment: ""
    )
    
    // MARK: - Transformer -
    
    func transform(input: Input) -> Output {
        bind(tap: input.tap)
        
        return Output(
            domainIcon: .just(IdentityStripeViewModel.discordIcon),
            title: titleString().asDriver(onErrorDriveWith: .empty())
        )
    }
    
    private func titleString() -> Observable<String> {
        return subscribeToDiscordUserUpdates()
            .map({ user in
                guard let user = user else {
                    return IdentityStripeViewModel.titlePlaceholder
                }
                
                return user.handle
            })
            .startWith(IdentityStripeViewModel.titlePlaceholder)
    }
    
    // MARK: - Events -
    
    private func subscribeToDiscordUserUpdates() -> Observable<DiscordUser?> {
        NotificationCenter.default.rx
            .notification(NotificationEvent.discordUserUpdated.notificationName, object: nil)
            .map({ $0.object as? DiscordUser })
    }
    
    // MARK: - Actions -
    
    private func bind(tap: Driver<Void>) {
        tap.asObservable()
            .subscribe(onNext: { 
                fatalError("not implemented")
            })
            .disposed(by: disposer)
    }
}
