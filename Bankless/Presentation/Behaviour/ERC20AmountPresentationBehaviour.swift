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
import BigInt

protocol ERC20AmountPresentationBehaviour {
    static var decimalPlaces: Int { get }
    var amount: BigInt { get }
}

extension ERC20AmountPresentationBehaviour {
    func amountString() -> String {
        let amountString = String(amount)
        
        let scaledAmountString = String(
            amountString[
                amountString.startIndex
                ..< .init(utf16Offset: amountString.count - Self.decimalPlaces, in: amountString)
            ]
        )
        
        guard let intAmount = Int(scaledAmountString) else {
            return scaledAmountString
        }
        
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.usesGroupingSeparator = true
        formatter.groupingSize = 3
        
        return formatter.string(from: NSNumber(value: intAmount)) ?? scaledAmountString
    }
}
