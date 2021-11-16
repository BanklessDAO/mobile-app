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
import Cartography

class BaseNavigationBar: UINavigationBar {
    // MARK: - Subviews -
    
    private let customViewContainer: UIView
    private(set) var customNavigationView: UIView?
    
    // MARK: - Initializers -
    
    override init(frame: CGRect) {
        customViewContainer = UIView()
        super.init(frame: .zero)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        customViewContainer = UIView()
        super.init(coder: aDecoder)
        setUp()
    }
    
    // MARK: - Setup -
    
    private func setUp() {
        setUpSubviews()
        
        UIView.performWithoutAnimation {
            setUpConstraints()
        }
    }
    
    private func setUpSubviews() {
        customViewContainer.isUserInteractionEnabled = false
        addSubview(customViewContainer)
    }
    
    private func setUpConstraints() {
        constrain(customViewContainer, self) { (container, view) in
            container.edges == view.edges
        }
    }
    
    // MARK: - Custom view setup -
    
    func set(customNavigationView: BaseNavigationView) {
        removeCustomNavigationView()
        
        UIView.performWithoutAnimation {
            self.customNavigationView = customNavigationView
            customViewContainer.addSubview(customNavigationView)
            customViewContainer.isUserInteractionEnabled = true
            
            constrain(customNavigationView, customViewContainer) { (view, container) in
                view.edges == container.edges
            }
        }
    }
    
    func removeCustomNavigationView() {
        self.customNavigationView?.removeFromSuperview()
        self.customNavigationView = nil
        customViewContainer.isUserInteractionEnabled = false
    }
}
