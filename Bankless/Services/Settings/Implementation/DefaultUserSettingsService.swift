//
//  Created with ♥ by BanklessDAO contributors on 2021-11-24.
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

class DefaultUserSettingsService: UserSettingsService {
    private let settingsStorage: SettingsStorage
    private let ensClient: ENSClient
    
    private let settingsUpdatesStream = PublishSubject<(key: UserSetting, value: Any?)>()
    
    init(
        settingsStorage: SettingsStorage,
        ensClient: ENSClient
    ) {
        self.settingsStorage = settingsStorage
        self.ensClient = ensClient
    }
    
    func streamValue(for userSetting: UserSetting) -> Observable<Any?> {
        return settingsUpdatesStream.asObservable()
            .filter({ $0.key == userSetting })
            .map({ $0.value })
            .startWith(settingsStorage.readValue(for: userSetting))
    }
    
    func setValue(_ value: Any?, for userSetting: UserSetting) -> Completable {
        switch userSetting {
            
        case .publicETHAddress, .ensName:
           return setEthIdentity(value, for: userSetting)
        }
        
        settingsStorage.writeValue(value, for: userSetting)
        settingsUpdatesStream.onNext((key: userSetting, value))
        
        return Completable.empty()
    }
    
    // MARK: - ETH Identity -
    
    private func setEthIdentity(_ value: Any?, for userSetting: UserSetting) -> Completable {
        guard let value = value else {
            settingsStorage.writeValue(nil, for: .ensName)
            settingsUpdatesStream.onNext((key: .ensName, nil))
            
            settingsStorage.writeValue(nil, for: .publicETHAddress)
            settingsUpdatesStream.onNext((key: .publicETHAddress, nil))
            
            return Completable.empty()
        }
        
        let resolvedENS: Observable<ResolveENSResponse>
        
        switch userSetting {
            
        case .publicETHAddress:
            resolvedENS = resolveETHAddress(request: .init(type: .address(value as! String)))
        case .ensName:
            resolvedENS = resolveETHAddress(request: .init(type: .name(value as! String)))
        }
        
        return resolvedENS
            .do { [weak self] response in
                self?.settingsStorage.writeValue(response.name, for: .ensName)
                self?.settingsUpdatesStream.onNext((key: .ensName, response.name))
                
                self?.settingsStorage.writeValue(response.address, for: .publicETHAddress)
                self?.settingsUpdatesStream.onNext((key: .publicETHAddress, response.address))
            }
            .flatMap({ _ in Completable.empty() })
            .asCompletable()
    }
    
    private func resolveETHAddress(request: ResolveENSRequest) -> Observable<ResolveENSResponse> {
        return ensClient
            .resolveENS(request: request)
            .take(1)
    }
}
