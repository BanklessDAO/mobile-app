//
//  Created with ♥ by BanklessDAO contributors on 2021-10-18.
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

class CollectionSectionHeaderCell: BaseCollectionViewCell<SectionHeaderViewModel> {
    class var reuseIdentifier: String {
        return String(describing: SectionHeaderCell.self)
    }
    
    // MARK: - Constants -
    
    private static let expandButtonColor: UIColor = .primaryRed
    
    // MARK: - Subviews -
    
    private var titleLabel: UILabel!
    private var expandButton: UIButton!
    
    // MARK: - Initializers -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup -
    
    override func setUp() {
        setUpSubviews()
        setUpConstraints()
    }
    
    override func setUpSubviews() {
        backgroundColor = .backgroundBlack
        
        titleLabel = UILabel()
        titleLabel.font = Appearance.Text.Font.Title2.font(bold: false)
        titleLabel.textColor = .secondaryWhite
        contentView.addSubview(titleLabel)
        
        expandButton = UIButton(type: .custom)
        expandButton.setTitleColor(CollectionSectionHeaderCell.expandButtonColor, for: .normal)
        contentView.addSubview(expandButton)
    }
    
    override func setUpConstraints() {
        constrain(titleLabel, expandButton, contentView) { title, expand, view in
            title.height == Appearance.Text.Font.Title2.lineHeight
            title.centerY == expand.centerY
            title.edges == view.edges
                .inseted(by: .init(
                    top: 0,
                    left: Appearance.contentInsets.left,
                    bottom: 0,
                    right: Appearance.contentInsets.right
                ))
        }
        
        constrain(expandButton, contentView) { expand, view in
            expand.top == view.top + Appearance.contentInsets.top
            expand.right == view.right - Appearance.contentInsets.right
            expand.bottom == view.bottom - Appearance.contentInsets.bottom
            expand.width == 0 ~ .defaultLow
        }
    }
    
    override func bindViewModel() {
        let output = viewModel.transform(input: .init(expand: expandButton.rx.tap.asDriver()))
        
        output.title.drive(titleLabel.rx.text).disposed(by: disposer)
        
        output.isExpandable.map(!).drive(expandButton.rx.isHidden).disposed(by: disposer)
        
        output.expandButtonTitle.drive(expandButton.rx.title(for: .normal)).disposed(by: disposer)
    }
}
