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

class AchievementsTitleCell: UICollectionViewCell {
    class var reuseIdentifier: String {
        return String(describing: AchievementsTitleCell.self)
    }
    
    override var reuseIdentifier: String? {
        return AchievementsTitleCell.reuseIdentifier
    }
    
    // MARK: - Subviews -
    
    private var titleLabel: UILabel!
    
    // MARK: - Initializers -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setters -
    
    func set(title: String) {
        titleLabel.text = title
    }
    
    // MARK: - Setup -
    
    func setUp() {
        setUpSubviews()
        setUpConstraints()
    }
    
    func setUpSubviews() {
        titleLabel = UILabel()
        titleLabel.font = Appearance.Text.Font.Header1.font(bold: true)
        titleLabel.textColor = .secondaryWhite
        contentView.addSubview(titleLabel)
    }
    
    func setUpConstraints() {
        constrain(titleLabel, contentView) { (title, view) in
            title.height == Appearance.Text.Font.Header1.lineHeight
            title.edges == view.edges
                .inseted(by: .init(
                    top: Appearance.contentInsets.top * 2,
                    left: Appearance.contentInsets.left * 2,
                    bottom: Appearance.contentInsets.bottom,
                    right: Appearance.contentInsets.right * 2
                ))
        }
    }
}
