//
//  Created with ♥ by BanklessDAO contributors on 2021-11-18.
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

class AcademyHeaderCell: UITableViewCell {
    class var reuseIdentifier: String {
        return String(describing: AcademyHeaderCell.self)
    }
    
    // MARK: - Subviews -
    
    private var titleLabel: UILabel!
    
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
    
    // MARK: - Setup -
    
    func setUp() {
        backgroundColor = .backgroundBlack
        
        setUpSubviews()
        setUpConstraints()
    }
    
    func setUpSubviews() {
        separatorInset = .init(
            top: 0,
            left: CGFloat.greatestFiniteMagnitude,
            bottom: 0,
            right: 0
        )
        
        titleLabel = UILabel()
        titleLabel.font = Appearance.Text.Font.Header1.font(bold: true)
        titleLabel.textColor = .secondaryWhite
        contentView.addSubview(titleLabel)
    }
    
    func setUpConstraints() {
        constrain(titleLabel, contentView) { (title, view) in
            title.height == Appearance.Text.Font.Header1.lineHeight
            title.edges == view.edges.inseted(by: Appearance.contentInsets)
        }
    }
}
