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

class FeaturedNewsItemCell: UICollectionViewCell {
    class var reuseIdentifier: String {
        return String(describing: FeaturedNewsItemCell.self)
    }
    
    override var reuseIdentifier: String? {
        return FeaturedNewsItemCell.reuseIdentifier
    }
    
    // MARK: - Subviews -
    
    private var itemView: FeaturedNewsItemView!
    
    // MARK: - Initializers -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle -
    
    override func prepareForReuse() {
        super.prepareForReuse()
        itemView.disposer = DisposeBag()
    }
    
    // MARK: - Setters -
    
    func set(itemView: FeaturedNewsItemView) {
        self.itemView?.removeFromSuperview()
        
        self.itemView = itemView
        contentView.addSubview(itemView)
        
        constrain(itemView, contentView) { (item, view) in
            item.edges == view.edges
        }
    }
    
    // MARK: - Setup -
    
    func setUp() {
        backgroundColor = .backgroundBlack
    }
}
