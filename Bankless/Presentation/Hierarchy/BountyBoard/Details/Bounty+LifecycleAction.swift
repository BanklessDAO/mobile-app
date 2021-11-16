//
//  Created with ♥ by BanklessDAO contributors on 2021-11-12.
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

extension Bounty.Status {
    var availableLifecycleActionTitle: String? {
        switch self {
            
        case .draft:
            return nil
        case .open:
            return NSLocalizedString(
                "bounty_board.bounty.status.open.action.claim.title",
                value: "Claim Bounty",
                comment: ""
            )
        case .inProgress:
            return NSLocalizedString(
                "bounty_board.bounty.status.open.action.submit.title",
                value: "Submit Bounty",
                comment: ""
            )
        case .inReview:
            return nil
        case .completed:
            return nil
        case .deleted:
            return nil
        }
    }
}
