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

extension DataError: ErrorHandling, DisplayableError, LocalizedError {
    var errorDescription: String? {
        switch self {
            
        case .unknown:
            return NSLocalizedString(
                "error.data.unknown.message",
                value: "Unknown data error",
                comment: ""
            )
        case .raw(let error):
            return error.localizedDescription
        case .rawCollection(let errors):
            return errors
                .map({ $0.localizedDescription })
                .joined(separator: ";")
        case .connectionIsOffline:
            return NSLocalizedString(
                "error.data.connection_is_offline.message",
                value: "Connection is offline.",
                comment: ""
            )
        case .authRequest(let error):
            return NSLocalizedString(
                "error.data.auth_request.message",
                value: "Couldn't complete login: \(error.localizedDescription).",
                comment: ""
            )
        case .sessionInvalid:
            return NSLocalizedString(
                "error.data.session_invalid.message",
                value: "User session is invalid.",
                comment: ""
            )
        case .sessionExpired:
            return NSLocalizedString(
                "error.data.session_expired.message",
                value: "User session has expired, please log in again.",
                comment: ""
            )
        case .mappingError(let error):
            return NSLocalizedString(
                "error.data.mapping.message",
                value: "Unexpected data: \(error.localizedDescription).",
                comment: ""
            )
        }
    }
    
    func handle() {
        display()
    }
}
