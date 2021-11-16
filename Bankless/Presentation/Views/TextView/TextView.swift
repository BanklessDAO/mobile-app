//
//  Created with ♥ by BanklessDAO contributors on 2021-11-15.
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
import RxSwift
import RxCocoa
import Cartography

final class TextView: UITextView {
    // MARK: - Constants -
    
    private static let borderWidth: CGFloat = 3
    private static let requiredMarkInsets: UIEdgeInsets = .init(
        top: 20, left: 0, bottom: 0, right: 20
    )
    
    // MARK: - Subviews -
    
    private var requiredMarkLabel: AutoWidthLabel!
    
    // MARK: - Initializers -
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup -
    
    private func setUp() {
        backgroundColor = .clear
        
        textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        setUpSubviews()
        setUpConstraints()
    }
    
    private func setUpSubviews() {
        layer.cornerRadius = Appearance.cornerRadius
        layer.borderColor = UIColor.primaryRed.withAlphaComponent(0.2).cgColor
        layer.borderWidth = TextView.borderWidth
        
        font = Appearance.Text.Font.Label2.font(bold: false)
        
        requiredMarkLabel = AutoWidthLabel()
        requiredMarkLabel.isHidden = true
        requiredMarkLabel.horizontalPadding = 20.0
        requiredMarkLabel.text = "∗"
        requiredMarkLabel.textAlignment = .right
        requiredMarkLabel.textColor = .primaryRed.withAlphaComponent(0.15)
        requiredMarkLabel.font = Appearance.Text.Font.Header1.font(bold: true)
        addSubview(requiredMarkLabel)
    }
    
    private func setUpConstraints() {
        constrain(requiredMarkLabel, self) { req, view in
            req.right == view.right - Appearance.contentInsets.right
            req.top == view.top + Appearance.contentInsets.top
            req.height == Appearance.Text.Font.Header1.lineHeight
        }
    }
}
