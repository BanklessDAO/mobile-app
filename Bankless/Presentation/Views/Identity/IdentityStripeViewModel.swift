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

final class IdentityStripeViewModel: BaseViewModel,
                                     AuthServiceDependency,
                                     IdentityServiceDependency,
                                     UserSettingsServiceDependency
{
    // MARK: - Input/Output -
    
    struct Input {
        let tap: Driver<Void>
    }
    
    struct Output {
        let domainIcon: Driver<UIImage?>
        let title: Driver<String>
    }
    
    // MARK: - Constants -
    
    private static let icons = (
        discord: UIImage(named: "discord_icon")!,
        identity: UIImage(named: "fingerprint")!
    )
    private static let placeholders = (
        user: NSLocalizedString(
            "identity.user.title.placeholder",
            value: "Unknown User",
            comment: ""
        ),
        address: NSLocalizedString(
            "identity.address.title.placeholder",
            value: "Unknown Address",
            comment: ""
        )
    )
    private static let userMenuTitle = NSLocalizedString(
        "user.menu.title",
        value: "User Actions",
        comment: ""
    )
    private static let userMenuItemTitles = (
        setWalletAddress: NSLocalizedString(
            "user.menu.item.set_address.title",
            value: "Set ETH Wallet Address",
            comment: ""
        ),
        openDiscord: NSLocalizedString(
            "user.menu.item.open_discord.title",
            value: "Open Discord",
            comment: ""
        ),
        logIn: NSLocalizedString(
            "user.menu.item.log_in.title",
            value: "Log In",
            comment: ""
        ),
        logOut: NSLocalizedString(
            "user.menu.item.log_out.title",
            value: "Log Out",
            comment: ""
        ),
        cancel: NSLocalizedString(
            "common.action.cancel",
            value: "Cancel",
            comment: ""
        )
    )
    private static let ethereumAddressForm = (
        title: NSLocalizedString(
            "user.setting.set_address.title",
            value: "Set ETH Wallet Address",
            comment: ""
        ),
        placeholder: NSLocalizedString(
            "user.setting.set_address.placeholder",
            value: "E.g. 0x22...3a9d",
            comment: ""
        ),
        save: NSLocalizedString(
            "common.action.save",
            value: "Save",
            comment: ""
        ),
        cancel: NSLocalizedString(
            "common.action.cancel",
            value: "Cancel",
            comment: ""
        )
    )
    
    // MARK: - Properties -
    
    private let userRelay = BehaviorRelay<DiscordUser?>(value: nil)
    private let logInRequest = PublishSubject<Void>()
    private let logOutRequest = PublishSubject<Void>()
    private let settingUpdateRequest = PublishSubject<UserSetting>()
    
    // MARK: - Data -
    
    private let mode: Mode
    
    // MARK: - Components -
    
    var authService: AuthService!
    var identityService: IdentityService!
    var userSettingsService: UserSettingsService!
    
    // MARK: - Initializers -
    
    init(mode: Mode) {
        self.mode = mode
    }
    
    // MARK: - Transformer -
    
    func transform(input: Input) -> Output {
        loadUser().map({ $0 as DiscordUser? }).startWith(nil)
            .bind(to: userRelay).disposed(by: disposer)
        let ethAddress = userSettingsService
            .streamValue(for: .publicETHAddress)
            .map({ $0 as? String })
        
        let domainIcon = domainIcon(user: userRelay.asObservable())
        
        let titleString = titleString(
            user: userRelay.asObservable(),
            ethAddress: ethAddress
        )
        
        bind(tap: input.tap)
        bindSettingsInput()
        bindLogInInput()
        bindLogOutInput()
        
        return Output(
            domainIcon: domainIcon.asDriver(onErrorDriveWith: .empty()),
            title: titleString.asDriver(onErrorDriveWith: .empty())
        )
    }
    
    private func domainIcon(
        user: Observable<DiscordUser?>
    ) -> Observable<UIImage?> {
        switch self.mode {
            
        case .currentUser:
            return .just(IdentityStripeViewModel.icons.identity)
        case .user:
            return .just(IdentityStripeViewModel.icons.discord)
        }
    }
    
    private func titleString(
        user: Observable<DiscordUser?>,
        ethAddress: Observable<String?>
    ) -> Observable<String> {
        return Observable.combineLatest(user, ethAddress) { (user: $0, address: $1) }
            .map({ [weak self] identity in
                guard let self = self else { return "" }
                
                let userString = identity.user?.handle
                    ?? IdentityStripeViewModel.placeholders.user
                
                let addressString = identity.address?.isValidEVMAddress ?? false
                ? String(identity.address![
                    String.Index(utf16Offset: 0, in: identity.address!)
                    ..< String.Index(utf16Offset: 4, in: identity.address!)
                ] + "..." + identity.address![
                    String.Index(utf16Offset: 36, in: identity.address!)
                    ..< String.Index(utf16Offset: 42, in: identity.address!)
                ])
                : IdentityStripeViewModel.placeholders.address
                
                switch self.mode {
                    
                case .currentUser:
                    return userString + " (\(addressString))"
                case .user:
                    return userString
                }
            })
            .startWith(
                IdentityStripeViewModel.placeholders.user
                + " (\(IdentityStripeViewModel.placeholders.address))"
            )
    }
    
    // MARK: - Discord data -
    
    private func loadUser() -> Observable<DiscordUser?> {
        let user: Observable<DiscordUser?>
        
        switch mode {
            
        case .user(let anotherUser):
            user = .just(anotherUser)
        case .currentUser:
            user = NotificationCenter.default.rx
                .notification(
                    NotificationEvent.discordAccessHasChanged.notificationName,
                    object: nil
                )
                .map({ _ in () })
                .startWith(())
                .flatMapLatest({ [weak self] in
                    return self?.identityService.getUserIdentity()
                        .map({ $0.discordUser })
                        .do(onNext: {
                            NotificationCenter.default
                                .post(
                                    name: NotificationEvent.discordUserUpdated.notificationName,
                                    object: $0
                                )
                        })
                        ?? .empty()
                })
        }
        
        return user
    }
    
    // MARK: - Actions -
    
    private func bind(tap: Driver<Void>) {
        tap.asObservable()
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                switch self.mode {
                    
                case .currentUser:
                    self.presentUserMenu()
                case .user:
                    break
                }
            })
            .disposed(by: disposer)
    }
    
    // MARK: - Alerts -
    
    private func presentUserMenu() {
        let menu = UIAlertController(
            title: IdentityStripeViewModel.userMenuTitle,
            message: nil,
            preferredStyle: .actionSheet
        )
        
        menu.addAction(
            .init(
                title: IdentityStripeViewModel.userMenuItemTitles.setWalletAddress,
                style: .default,
                handler: { [weak self] _ in self?.settingUpdateRequest.onNext(.publicETHAddress) }
            )
        )
        
        if userRelay.value == nil {
            menu.addAction(
                .init(
                    title: IdentityStripeViewModel.userMenuItemTitles.logIn,
                    style: .default,
                    handler: { [weak self] _ in self?.logInRequest.onNext(()) }
                )
            )
        } else {
            menu.addAction(
                .init(
                    title: IdentityStripeViewModel.userMenuItemTitles.logOut,
                    style: .destructive,
                    handler: { [weak self] _ in self?.logOutRequest.onNext(()) }
                )
            )
        }
        
        menu.addAction(
            .init(
                title: IdentityStripeViewModel.userMenuItemTitles.cancel,
                style: .cancel,
                handler: { _ in  }
            )
        )
        
        (UIApplication.shared.delegate as! AppDelegate)
            .applicationCoordinator.navigationController?
            .present(menu, animated: true)
    }
    
    private func bindSettingsInput() {
        settingUpdateRequest.asObservable()
            .flatMapLatest({ [weak self] userSetting -> Completable in
                guard let self = self else { return .empty() }
                
                switch userSetting {
                    
                case .publicETHAddress:
                    return self.ethereumPublicAddressInput()
                        .map({ ($0?.isValidEVMAddress ?? false) ? $0 : nil })
                        .flatMap({ [weak self] newAddress in
                            self?.userSettingsService
                                .setValue(newAddress, for: .publicETHAddress)
                                ?? .empty()
                        })
                        .asCompletable()
                }
            })
            .asCompletable()
            .subscribe()
            .disposed(by: disposer)
    }
    
    private func bindLogInInput() {
        logInRequest.asObservable()
            .flatMapLatest({ [weak self] in
                return self?.authService.getDiscordAccess()
                    .asObservable()
                    .do(onCompleted: {
                        NotificationCenter.default
                            .post(
                                name: NotificationEvent.discordAccessHasChanged.notificationName,
                                object: nil
                            )
                    }) ?? .empty()
            })
            .asCompletable()
            .subscribe()
            .disposed(by: disposer)
            
    }
    
    private func bindLogOutInput() {
        logOutRequest.asObservable()
            .flatMapLatest({ [weak self] in
                return self?.authService
                    .terminateDiscordAccess()
                    .do(onCompleted: {
                        NotificationCenter.default
                            .post(
                                name: NotificationEvent.discordAccessHasChanged.notificationName,
                                object: nil
                            )
                    })
                ?? .empty()
            })
            .subscribe()
            .disposed(by: disposer)
    }
    
    private func ethereumPublicAddressInput() -> Observable<String?> {
        return Observable<String?>.create { observer in
            let inputAlert = UIAlertController(
                title: IdentityStripeViewModel.ethereumAddressForm.title,
                message: nil,
                preferredStyle: .alert
            )
            
            inputAlert.addTextField { field in
                field.placeholder = IdentityStripeViewModel.ethereumAddressForm.placeholder
            }
            
            let saveAction = UIAlertAction(
                title: IdentityStripeViewModel.ethereumAddressForm.save,
                style: .default,
                handler: { _ in
                    guard let input = inputAlert.textFields?.first?.text, !input.isEmpty else {
                        observer.onNext(nil)
                        observer.onCompleted()
                        return
                    }
                    
                    observer.onNext(input)
                    observer.onCompleted()
                }
            )
            inputAlert.addAction(saveAction)
            
            let cancelAction = UIAlertAction(
                title: IdentityStripeViewModel.ethereumAddressForm.cancel,
                style: .cancel,
                handler: { _ in observer.onCompleted() }
            )
            inputAlert.addAction(cancelAction)
            
            (UIApplication.shared.delegate as! AppDelegate)
                .applicationCoordinator.navigationController?
                .present(inputAlert, animated: true)
            
            return Disposables.create()
        }
    }
}

extension IdentityStripeViewModel {
    enum Mode {
        case currentUser
        case user(_ user: DiscordUser)
    }
}
