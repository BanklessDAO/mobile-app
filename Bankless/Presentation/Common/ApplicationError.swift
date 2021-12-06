//
//  Created with ♥ by BanklessDAO contributors on 2021-11-27.
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

enum ApplicationError: Error, LocalizedError {
    case unknown
    case raw(error: Error)
    case ethAddressIsNotSet
    
    var errorDescription: String? {
        switch self {
            
        case .unknown:
            return NSLocalizedString(
                "error.app.unknown.message",
                value: "Something went wrong.",
                comment: ""
            )
        case .raw(let error):
            return error.localizedDescription
        case .ethAddressIsNotSet:
            return NSLocalizedString(
                "error.app.eth_address_is_not_set.message",
                value: "We don't have your ETH address. Please set it in the user settings.",
                comment: ""
            )
        }
    }
}
