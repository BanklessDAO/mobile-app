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

class IdentityStripeView: BaseView<IdentityStripeViewModel> {
    // MARK: - Properties -
    
    private let layoutDirection: LayoutDirection
    
    // MARK: - Subviews -
    
    private var domainIconView: UIImageView!
    private var button: UIButton!
    private var titleLabel: UILabel!
    
    // MARK: - Initializers -
    
    init(
        layoutDirection: LayoutDirection
    ) {
        self.layoutDirection = layoutDirection
        super.init(frame: .zero)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup -
    
    private func setUp() {
        clipsToBounds = true
        layer.cornerRadius = Appearance.cornerRadius
        backgroundColor = .backgroundGrey.withAlphaComponent(0.30)
        
        setUpSubviews()
        
        UIView.performWithoutAnimation {
            setUpConstraints()
        }
    }
    
    private func setUpSubviews() {
        domainIconView = UIImageView()
        domainIconView.backgroundColor = .backgroundGrey.withAlphaComponent(0.75)
        domainIconView.alpha = 0.75
        domainIconView.contentMode = .scaleAspectFit
        domainIconView.setContentHuggingPriority(.required, for: .horizontal)
        domainIconView.setContentCompressionResistancePriority(.required, for: .horizontal)
        addSubview(domainIconView)
        
        button = UIButton(type: .custom)
        addSubview(button)
        
        titleLabel = UILabel()
        titleLabel.lineBreakMode = .byTruncatingMiddle
        titleLabel.textColor = .secondaryWhite
        addSubview(titleLabel)
    }
    
    private func setUpConstraints() {
        switch layoutDirection {
            
        case .leftHand:
            constrain(domainIconView, titleLabel, self) { icon, title, view in
                icon.left == view.left
                title.left == icon.right + contentPaddings.right
                title.right == view.right - contentPaddings.left
            }
        case .rightHand:
            constrain(domainIconView, titleLabel, self) { icon, title, view in
                icon.right == view.right
                title.right == icon.left - contentPaddings.left
                title.left == view.left + contentPaddings.right
            }
        }
        
        constrain(domainIconView, self) { icon, view in
            icon.centerY == view.centerY
            icon.height == view.height
        }
        
        constrain(titleLabel, self) { title, view in
            title.centerY == view.centerY
            title.height == view.height - contentPaddings.top - contentPaddings.bottom
        }
        
        constrain(button, self) { button, view in
            button.edges == view.edges
        }
    }
    
    override func bindViewModel() {
        let output = viewModel.transform(input: input())
        
        output.domainIcon.drive(domainIconView.rx.image).disposed(by: disposer)
        output.title.drive(titleLabel.rx.text).disposed(by: disposer)
    }
    
    private func input() -> IdentityStripeViewModel.Input {
        return .init(
            tap: button.rx.tap.asDriver()
        )
    }
}

extension IdentityStripeView {
    enum LayoutDirection {
        case leftHand
        case rightHand
    }
}
