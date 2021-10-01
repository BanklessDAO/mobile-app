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
import RxSwift
import RxCocoa

class HomeViewController: BaseViewController<HomeViewModel> {
    // MARK: - Constants -
    
    static let headerContentHeight: CGFloat = 64.0
    
    static let separatorColor: UIColor = .secondaryGrey
    static let separatorHeight = 1.0
    
    // MARK: - Subviews -
    
    private var titleLabel: UILabel!
    private var horizontalSeparatorView: UIView!
    private var timelineView: HomeTimelineView!
    
    // MARK: - Setup -
    
    override func setUp() {
        setUpSubviews()
        setUpConstraints()
        bindViewModel()
    }
    
    func setUpSubviews() {
        titleLabel = UILabel()
        titleLabel.font = Appearance.Text.Heading.H1.font
        titleLabel.textColor = .secondaryWhite
        view.addSubview(titleLabel)
        
        horizontalSeparatorView = UIView()
        horizontalSeparatorView.backgroundColor = .secondaryGrey
        horizontalSeparatorView.isHidden = true
        view.addSubview(horizontalSeparatorView)
        
        timelineView = HomeTimelineView()
        view.addSubview(timelineView)
        
    }
    
    func setUpConstraints() {
        fatalError("not implemented")
    }
    
    func bindViewModel() {
        fatalError("not implemented")
    }
}
