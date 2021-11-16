//
//  Created with ♥ by BanklessDAO contributors on 2021-11-11.
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
import UIKit

extension Bounty.Status: ColorBehaviour {
    var colorCode: UIColor {
        switch self {
            
        case .draft:
            return UIColor(hue:0.00, saturation:0.00, brightness:0.71, alpha:1.00)
        case .open:
            return UIColor(hue:0.60, saturation:0.62, brightness:0.97, alpha:1.00)
        case .inProgress:
            return UIColor(hue:0.24, saturation:0.45, brightness:0.99, alpha:1.00)
        case .inReview:
            return UIColor(hue:0.13, saturation:0.52, brightness:0.98, alpha:1.00)
        case .completed:
            return UIColor(hue:0.00, saturation:0.00, brightness:1.00, alpha:1.00)
        case .deleted:
            return UIColor(hue:0.02, saturation:0.66, brightness:0.93, alpha:1.00)
        }
    }
}
