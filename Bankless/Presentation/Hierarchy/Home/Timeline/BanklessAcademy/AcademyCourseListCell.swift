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

class AcademyCourseListCell: BaseTableViewCell<AcademyCourseViewModel> {
    class var reuseIdentifier: String {
        return String(describing: AcademyCourseListCell.self)
    }
    
    // MARK: - Subviews -
    
    private var card: AcademyCourseCard!
    
    // MARK: - Setup -
    
    override func setUpSubviews() {
        separatorInset = .init(
            top: 0,
            left: CGFloat.greatestFiniteMagnitude,
            bottom: 0,
            right: 0
        )
        
        card = AcademyCourseCard()
        contentView.addSubview(card)
    }
    
    override func setUpConstraints() {
        constrain(card, contentView) { (card, view) in
            card.edges == view.edges
                .inseted(
                    by: .init(
                        top: Appearance.contentInsets.top / 2,
                        left: Appearance.contentInsets.left,
                        bottom: Appearance.contentInsets.bottom / 2,
                        right: Appearance.contentInsets.right
                    )
                )
        }
    }
    
    override func bindViewModel() {
        card.bind(viewModel: viewModel)
    }
}
