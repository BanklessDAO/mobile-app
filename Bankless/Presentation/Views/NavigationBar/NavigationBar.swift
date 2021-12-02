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

class NavigationBar: BaseNavigationView {
    // MARK: - Constants -
    
    private static let itemPadding: CGFloat = 0.0
    
    // MARK: - Properties -
    
    private var views: [UIView]!
    
    // MARK: - Subviews -
    
    private var stackView: UIStackView!
    
    // MARK: - Initializers -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setters -
    
    func set(views: [UIView]) {
        self.views = views
        
        UIView.performWithoutAnimation {
            resetLayout()
        }
    }
    
    // MARK: - Setup -
    
    private func setUp() {
        UIView.performWithoutAnimation {
            setUpSubviews()
            setUpConstraints()
            
            set(views: [])
        }
    }
    
    private func setUpSubviews() {
        stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = NavigationBar.itemPadding
        stackView.axis = .horizontal
        addSubview(stackView)
    }
    
    private func setUpConstraints() {
        constrain(stackView, self) { stack, view in
            stack.left == view.left + Appearance.contentInsets.left * 2
            stack.top == view.top
            stack.bottom == view.bottom - Appearance.contentPaddings.bottom
            stack.right == view.right - Appearance.contentInsets.left * 2
        }
    }
    
    // MARK: - Dynamic layout -
    
    private func resetLayout() {
        for subview in stackView.subviews {
            subview.removeFromSuperview()
        }
        
        for view in views {
            stackView.addArrangedSubview(view)
        }
        
        UIView.performWithoutAnimation {
            stackView.setNeedsLayout()
            stackView.layoutIfNeeded()
        }
    }
}
