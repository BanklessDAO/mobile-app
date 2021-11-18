//
//  Created with ♥ by BanklessDAO contributors on 2021-11-16.
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

class FeaturedNewsExpandCell: UICollectionViewCell {
    class var reuseIdentifier: String {
        return String(describing: FeaturedNewsExpandCell.self)
    }
    
    override var reuseIdentifier: String? {
        return FeaturedNewsExpandCell.reuseIdentifier
    }
    
    // MARK: - Constants -
    
    private static let absoluteItemWidth: CGFloat = UIScreen.main.bounds.width * 0.70
    private static let placeholderRatio: CGSize = .init(width: 16, height: 9)
    private static let borderColor: UIColor = .primaryRed.withAlphaComponent(0.2)
    private static let borderWidth: CGFloat = 2
    
    // MARK: - Properties -
    
    private var placeholderItem: ShowMorePlaceholderItem!
    
    // MARK: - Subviews -
    
    private var placeholderView: UIView!
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
    
    func set(placeholderItem: ShowMorePlaceholderItem) {
        self.placeholderItem = placeholderItem
        
        placeholderView?.removeFromSuperview()
        
        placeholderView = UIView()
        placeholderView.layer.cornerRadius = Appearance.cornerRadius
        placeholderView.layer.borderWidth = FeaturedNewsExpandCell.borderWidth
        placeholderView.layer.borderColor = FeaturedNewsExpandCell.borderColor.cgColor
        contentView.addSubview(placeholderView)
        
        titleLabel = UILabel()
        titleLabel.text = placeholderItem.title
        titleLabel.textAlignment = .center
        titleLabel.textColor = .secondaryWhite.withAlphaComponent(0.75)
        titleLabel.font = Appearance.Text.Font.Label1.font(bold: true)
        placeholderView.addSubview(titleLabel)
        
        constrain(placeholderView, contentView) { (placeholder, view) in
            placeholder.left == view.left + Appearance.contentInsets.left
            placeholder.right == view.right - Appearance.contentInsets.right
            placeholder.top == view.top + Appearance.contentInsets.top
            placeholder.bottom == view.bottom - Appearance.contentInsets.bottom
            
            placeholder.width == FeaturedNewsExpandCell.absoluteItemWidth
            placeholder.height == placeholder.width
                / FeaturedNewsExpandCell.placeholderRatio.width
                * FeaturedNewsExpandCell.placeholderRatio.height
        }
        
        constrain(titleLabel, placeholderView) { title, placeholder in
            title.center == placeholder.center
            title.width == placeholder.width
            title.height == Appearance.Text.Font.Label1.lineHeight
        }
    }
    
    // MARK: - Setup -
    
    func setUp() {
        backgroundColor = .backgroundBlack
    }
}
