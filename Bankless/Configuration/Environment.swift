//
//  Created with ♥ by BanklessDAO contributors on 2021-10-14.
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

public enum Environment {
    static let graphQLAPIEndpoint: String = {
        guard let url = Environment.infoDictionary["GRAPHQL_API_ENDPOINT"] as? String else {
            fatalError("Not found")
        }
        
        return url
    }()
    
    static let discordClientId: String = {
        guard let value = Environment.infoDictionary["DISCORD_CLIENT_ID"] as? String else {
            fatalError("Not found")
        }
        
        return value
    }()
    
    static let discordClientSecret: String = {
        guard let value = Environment.infoDictionary["DISCORD_CLIENT_SECRET"] as? String else {
            fatalError("Not found")
        }
        
        return value
    }()
    
    static let discordAuthURL: String = {
        guard let value = Environment.infoDictionary["DISCORD_AUTH_URL"] as? String else {
            fatalError("Not found")
        }
        
        return value
    }()
    
    static let discordAuthRedirectURL: String = {
        guard let value = Environment.infoDictionary["DISCORD_AUTH_REDIRECT_URL"] as? String else {
            fatalError("Not found")
        }
        
        return value
    }()
    
    static let discordAuthRedirectURLScheme: String = {
        guard let value = Environment
                .infoDictionary["DISCORD_AUTH_REDIRECT_URL_SCHEME"] as? String else {
                    fatalError("Not found")
        }
        
        return value
    }()
    
    static let discordAuthRedirectPath: String = {
        guard let value = Environment
                .infoDictionary["DISCORD_AUTH_REDIRECT_PATH"] as? String else {
                    fatalError("Not found")
        }
        
        return value
    }()
    
    static let discordAccessTokenURL: String = {
        guard let value = Environment.infoDictionary["DISCORD_ACCESS_TOKEN_URL"] as? String else {
            fatalError("Not found")
        }
        
        return value
    }()
    
    static let discordAPIBaseURL: String = {
        guard let value = Environment.infoDictionary["DISCORD_API_BASE_URL"] as? String else {
            fatalError("Not found")
        }
        
        return value
    }()
    
    static let discordServerURL: String = {
        guard let value = Environment.infoDictionary["DISCORD_SERVER_URL"] as? String else {
            fatalError("Not found")
        }
        
        return value
    }()
    
    static let banklessAcademyAPIBaseURL: String = {
        guard let value = Environment.infoDictionary["BANKLESS_ACADEMY_API_BASE_URL"] as? String else {
            fatalError("Not found")
        }
        
        return value
    }()
    
    static let banklessAcademyLessonsBaseURL: String = {
        guard let value = Environment.infoDictionary["BANKLESS_ACADEMY_LESSONS_BASE_URL"] as? String else {
            fatalError("Not found")
        }
        
        return value
    }()
    
    static let poapAPIBaseURL: String = {
        guard let value = Environment.infoDictionary["POAP_API_BASE_URL"] as? String else {
            fatalError("Not found")
        }
        
        return value
    }()
    
    static let poapAppBaseURL: String = {
        guard let value = Environment.infoDictionary["POAP_APP_BASE_URL"] as? String else {
            fatalError("Not found")
        }
        
        return value
    }()
    
    static let sentryDSN: String = {
        guard let value = Environment.infoDictionary["SENTRY_DSN"] as? String else {
            fatalError("Not found")
        }
        
        return value
    }()
    
    fileprivate static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Not found")
        }
        
        return dict
    }()
}
