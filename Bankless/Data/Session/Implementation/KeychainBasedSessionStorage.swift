//
//  Created with ♥ by BanklessDAO contributors on 2021-11-06.
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
import KeychainAccess

final class KeychainBasedSessionStorage: SessionStorage {
    // MARK: - Types -
    
    private enum StorageKey: String {
        case token
        case refreshToken
        case tokenExpirationTimestamp
    }
    
    // MARK: - Properties -
    
    private let keychain: Keychain
    
    var token: String? {
        return keychain[StorageKey.token.rawValue]
    }
    
    var refreshToken: String? {
        return keychain[StorageKey.refreshToken.rawValue]
    }
    
    var tokenExpirationTimestamp: Int? {
        guard let stringValue = keychain[StorageKey.tokenExpirationTimestamp.rawValue] else {
            return nil
        }
        
        return Int(stringValue)
    }
    
    // MARK: - Initializers -
    
    init(keychainGroupId: String? = nil, containerGroupId: String? = nil) {
        guard let keychainGroupId = keychainGroupId, let containerGroupId = containerGroupId else {
            self.keychain = Keychain(
                service: Bundle.main.bundleIdentifier!
            )
            
            return
        }
        
        self.keychain = Keychain(
            service: keychainGroupId,
            accessGroup: containerGroupId
        )
    }
    
    // MARK: - Storage -
    
    func register(
        token: String,
        refreshToken: String,
        tokenExpirationTimestamp: Int
    ) {
        keychain[StorageKey.token.rawValue] = token
        keychain[StorageKey.refreshToken.rawValue] = refreshToken
        keychain[StorageKey.tokenExpirationTimestamp.rawValue] = String(tokenExpirationTimestamp)
    }
    
    func clear() {
        try! keychain.removeAll()
    }
}
