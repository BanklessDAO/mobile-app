//
//  Created with ♥ by BanklessDAO contributors on 2021-11-29.
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
import Moya

enum PoapAPIMethod {
    case scanAddress(address: String)
}

extension PoapAPIMethod: TargetType, AccessTokenAuthorizable, Cacheable {
    var baseURL: URL {
        return URL(string: Environment.poapAPIBaseURL)!
    }
    
    var path: String {
        let versionPath = ""
        
        switch self {
            
        case .scanAddress(let address):
            return versionPath + "/actions/scan/\(address)"
        }
    }
    
    var method: Moya.Method {
        switch self {
            
        case .scanAddress:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        return nil
    }
    
    var parameterEncoding: ParameterEncoding {
        switch method {
            
        case .get:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
    
    var task: Task {
        switch self {
            
        default:
            return .requestParameters(
                parameters: parameters ?? [:],
                encoding: parameterEncoding
            )
        }
    }
    
    var sampleData: Data {
        switch self {
            
        default:
            do { return try JSONEncoder().encode("Sample data TBD") } catch { return Data() }
        }
    }
    
    var authorizationType: AuthorizationType? {
        switch self {
            
        default:
            return .none
        }
    }
    
    var headers: [String: String]? {
        let headers: [String: String] = [
            "Accept": "application/json",
            "Accept-Encoding": "gzip, deflate, br",
            "Accept-Language": "en-us",
        ]
        
        return headers
    }
    
    var cachePolicy: URLRequest.CachePolicy {
        switch self {
            
        default:
            return .useProtocolCachePolicy
        }
    }
}
