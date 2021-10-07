//
//  Created with ♥ by BanklessDAO contributors on 2021-10-06.
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
import Cartography

class CardView: UIView {
    // MARK: - Constants -
    
    private static let cornerRadius: CGFloat = 10.0
    
    static let contentInsets: UIEdgeInsets = .init(
        top: Appearance.contentInsets.top * 2,
        left: Appearance.contentInsets.left * 2,
        bottom: Appearance.contentInsets.bottom * 2,
        right: Appearance.contentInsets.right * 2
    )
    static let contentPaddings = Appearance.contentPaddings
    
    // MARK: - Initializers -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup -
    
    private func setUp() {
        setUpSubviews()
    }
    
    private func setUpSubviews() {
        layer.cornerRadius = CardView.cornerRadius
    }
}
