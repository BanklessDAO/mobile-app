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

class TimelineSectionHeaderCell: UITableViewCell {
    class var reuseIdentifier: String {
        return String(describing: TimelineSectionHeaderCell.self)
    }
    
    // MARK: - Constants -
    
    private static let expandButtonColor: UIColor = .primaryRed
    
    // MARK: - Properties -

    private var expandAction: (() -> Void)?
    
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
    
    // MARK: - Setters -
    
    func set(title: String) {
        titleLabel.text = title
    }
    
    func setExpandButton(title: String, action: @escaping () -> Void) {
        self.expandButton.setTitle(title, for: .normal)
        self.expandAction = action
    }
    
    // MARK: - Setup -
    
    func setUp() {
        setUpSubviews()
        setUpConstraints()
    }
    
    func setUpSubviews() {
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
        expandButton.setTitleColor(TimelineSectionHeaderCell.expandButtonColor, for: .normal)
        expandButton.addTarget(self, action: #selector(expandButtonTapped), for: .touchUpInside)
        contentView.addSubview(expandButton)
    }
    
    func setUpConstraints() {
        constrain(titleLabel, expandButton, contentView) { title, expand, view in
            title.height == Appearance.Text.Font.Title1.lineHeight
            title.height == expand.height
            title.centerY == expand.centerY
            title.left == view.left + Appearance.contentInsets.left
            title.edges == view.edges.inseted(by: Appearance.contentInsets)
        }
        
        constrain(expandButton, contentView) { expand, view in
            expand.top == view.top + Appearance.contentInsets.top
            expand.right == view.right - Appearance.contentInsets.right
            expand.bottom == view.bottom - Appearance.contentInsets.bottom
            expand.width == 0 ~ .defaultLow
        }
    }
    
    // MARK: - Action -
    
    @objc private func expandButtonTapped() {
        expandAction?()
    }
}
