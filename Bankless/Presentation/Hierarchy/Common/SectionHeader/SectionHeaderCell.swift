//
//  Created with ♥ by BanklessDAO contributors on 2021-10-07.
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

class SectionHeaderCell: BaseTableViewCell<SectionHeaderViewModel> {
    class var reuseIdentifier: String {
        return String(describing: SectionHeaderCell.self)
    }
    
    // MARK: - Constants -
    
    private static let expandButtonColor: UIColor = .primaryRed
    
    // MARK: - Subviews -
    
    private var titleLabel: UILabel!
    private var expandButton: UIButton!
    
    // MARK: - Initializers -
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        
        separatorInset = .init(
            top: 0,
            left: CGFloat.greatestFiniteMagnitude,
            bottom: 0,
            right: 0
        )
        
        titleLabel = UILabel()
        titleLabel.font = Appearance.Text.Font.Title1.font(bold: true)
        titleLabel.textColor = .secondaryWhite
        contentView.addSubview(titleLabel)
        
        expandButton = UIButton(type: .custom)
        expandButton.setTitleColor(SectionHeaderCell.expandButtonColor, for: .normal)
        contentView.addSubview(expandButton)
    }
    
    override func setUpConstraints() {
        constrain(titleLabel, contentView) { title, view in
            title.height == Appearance.Text.Font.Title1.lineHeight
            title.edges == view.edges.inseted(
                by: .init(
                    top: Appearance.contentInsets.top * 2,
                    left: Appearance.contentInsets.left * 2,
                    bottom: Appearance.contentInsets.bottom,
                    right: Appearance.contentInsets.right * 2
                )
            )
        }
        
        constrain(expandButton, titleLabel, contentView) { expand, title, view in
            expand.height == title.height
            expand.centerY == title.centerY
            expand.right == view.right - Appearance.contentInsets.right * 2
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
