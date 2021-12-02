//
//  Created with ♥ by BanklessDAO contributors on 2021-10-17.
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

class AchievementsViewController: BaseViewController<AchievementsViewModel> {
    // MARK: - Subviews -
    
    private var collectionView: AchievementCollectionView!
    
    // MARK: - Setup -
    
    override func setUp() {
        setUpSubviews()
        setUpConstraints()
        bindViewModel()
    }
    
    func setUpSubviews() {
        view.backgroundColor = .backgroundBlack
        
        collectionView = AchievementCollectionView()
        view.addSubview(collectionView)
    }
    
    func setUpConstraints() {
        constrain(collectionView, view) { (collection, view) in
            collection.left == view.left
            collection.top == view.safeAreaLayoutGuide.top
            collection.right == view.right
            collection.bottom == view.bottom
        }
    }
    
    func bindViewModel() {
        let output = viewModel.transform(input: .init())
        collectionView.bind(viewModel: output.collectionViewModel)
    }
}
