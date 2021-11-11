//
//  Created with ♥ by BanklessDAO contributors on 2021-09-30.
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

final class BaseNavigationController: UINavigationController {
    // MARK: - Navigation bar -
    
    override var navigationBar: BaseNavigationBar {
        return super.navigationBar as! BaseNavigationBar
    }
    
    // MARK: - Subviews -
    
    private var curtainView: UIView!
    
    // MARK: - Curtain -
    
    func setCurtain(on isVisible: Bool) {
        curtainView?.removeFromSuperview()
        
        guard isVisible else { return }
        
        curtainView = UIView()
        curtainView.backgroundColor = .init(white: 0.0, alpha: 0.5)
        view.addSubview(curtainView)
        
        constrain(curtainView, view) { (curtain, view) in
            curtain.edges == view.edges
        }
    }
}
