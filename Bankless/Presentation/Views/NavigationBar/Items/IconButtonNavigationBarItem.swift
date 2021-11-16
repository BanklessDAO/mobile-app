//
//  Created with ♥ by BanklessDAO contributors on 2021-11-10.
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

class IconButtonNavigationBarItem: UIView {
    // MARK: - Properties -
    
    private let icon: UIImage
    
    var rxTap: Driver<Void> {
        return button.rx.tap.asDriver()
    }
    let disposer = DisposeBag()
    
    // MARK: - Subviews -
    
    private var button: UIButton!
    
    // MARK: - Initializers -
    
    init(
        icon: UIImage
    ) {
        self.icon = icon
        super.init(frame: .zero)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup -
    
    private func setUp() {
        setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        setUpSubviews()
        setUpConstraints()
    }
    
    private func setUpSubviews() {
        button = UIButton(type: .custom)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.setImage(icon, for: .normal)
        addSubview(button)
    }
    
    private func setUpConstraints() {
        UIView.performWithoutAnimation {
            constrain(button, self) { button, view in
                button.edges == view.edges
            }
        }
    }
}
