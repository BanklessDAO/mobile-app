//
//  Created with ♥ by BanklessDAO contributors on 2021-11-25.
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

enum BanklessAcademyAPIMethod {
    case claimPoap(poapEventId: Int, address: String)
}

extension BanklessAcademyAPIMethod: TargetType, AccessTokenAuthorizable, Cacheable {
    var baseURL: URL {
        return URL(string: Environment.banklessAcademyAPIBaseURL)!
    }
    
    var path: String {
        let versionPath = ""
        
        switch self {
            
        case .claimPoap:
            return versionPath + "claim-poap"
        }
    }
    
    var method: Moya.Method {
        switch self {
            
        case .claimPoap:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        let params: [String: Any?]
        
        switch self {
            
        case let .claimPoap(poapEventId, address):
            params = [
                "poapEventId": poapEventId,
                "address": address,
            ] as [String: Any?]
        }
        
        guard !params.isEmpty else { return nil }
        
        return params.compactMapValues({ $0 })
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
        var headers: [String: String] = [
            "accept": "application/json",
        ]
        
        switch parameterEncoding {
            
        default:
            headers["content-type"] = "application/json"
        }
        
        return headers
    }
    
    var cachePolicy: URLRequest.CachePolicy {
        switch self {
            
        default:
            return .reloadIgnoringLocalCacheData
        }
    }
}
