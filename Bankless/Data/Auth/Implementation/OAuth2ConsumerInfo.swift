//
//  Created with ♥ by BanklessDAO contributors on 2021-11-05.
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

protocol OAuth2ConsumerInfo {
    var clientId: String { get }
    var clientSecret: String { get }
    var redirectURL: String { get }
    var requestedScope: String { get }
    var responseType: String { get }
    var stateHandler: (
        generate: () -> String,
        validate: (String) -> Void
    )? { get }
    var customParameters: [String : Any]? { get }
}

extension AuthProviderServer: OAuth2ConsumerInfo {
    var clientId: String {
        switch self {
            
        case .discord:
            return Environment.discordClientId
        }
    }
    
    var clientSecret: String {
        switch self {
            
        case .discord:
            return Environment.discordClientSecret
        }
    }
    
    var redirectURL: String {
        switch self {
            
        case .discord:
            return Environment.discordAuthRedirectURL
        }
    }
    
    var requestedScope: String {
        switch self {
            
        case .discord:
            return "identify guilds guilds.members.read"
        }
    }
    
    var responseType: String {
        switch self {
            
        case .discord:
            return "code"
        }
    }
    
    var stateHandler: (generate: () -> String, validate: (String) -> Void)? {
        return nil
    }
    
    var customParameters: [String : Any]? {
        return [
            "prompt": "none"
        ]
    }
}
