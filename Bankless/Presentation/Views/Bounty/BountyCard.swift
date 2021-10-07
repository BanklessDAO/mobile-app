//
//  Created with ♥ by BanklessDAO contributors on 2021-10-06.
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

class BountyCard: CardView {
    // MARK: - Constants -
    
    private static let backgroundColor: UIColor = .backgroundGrey.withAlphaComponent(0.3)
    private static let forwardNavigationIcon = UIImage(named: "arrow_right")!
    private static let rewardTagHeight: CGFloat = 60.0
    
    // MARK: - Properties -
    
    private let disposer = DisposeBag()
    
    // MARK: - Subviews -
    
    private var titleLabel: UILabel!
    private var forwardNavIconView: UIImageView!
    private var rewardTagView: TagView!
    
    // MARK: - Initialiers -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup -
    
    private func setUp() {
        clipsToBounds = true
        backgroundColor = BountyCard.backgroundColor
        
        setUpSubviews()
        setUpConstraints()
    }
    
    func setUpSubviews() {
        titleLabel = UILabel()
        titleLabel.textColor = .secondaryWhite
        titleLabel.font = Appearance.Text.Font.Label2.font(bold: true)
        addSubview(titleLabel)
        
        forwardNavIconView = UIImageView(image: BountyCard.forwardNavigationIcon)
        forwardNavIconView.contentMode = .scaleAspectFit
        addSubview(forwardNavIconView)
        
        rewardTagView = TagView()
        rewardTagView.cornerRadius = Appearance.cornerRadius
        rewardTagView.backgroundColor = .backgroundGrey
        addSubview(rewardTagView)
    }
    
    func setUpConstraints() {
        constrain(forwardNavIconView, self) { (icon, view) in
            icon.top == view.top + Appearance.contentInsets.top
            icon.right == view.right - Appearance.contentInsets.right
            icon.height == Appearance.Text.Font.Label2.lineHeight
            icon.width == icon.height
        }
        
        constrain(titleLabel, forwardNavIconView, self) { (title, icon, view) in
            title.left == view.left + Appearance.contentInsets.left
            title.height == icon.height
            title.centerY == icon.centerY
            title.right == icon.left - Appearance.contentPaddings.left
        }
        
        constrain(rewardTagView, titleLabel, self) { (reward, title, view) in
            reward.top == title.bottom + Appearance.contentPaddings.bottom
            reward.left == view.left + Appearance.contentInsets.left
            reward.bottom == view.bottom - Appearance.contentInsets.bottom
            reward.height == BountyCard.rewardTagHeight
        }
    }
    
    func bind(viewModel: BountyViewModel) {
        let input = BountyViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.title.drive(titleLabel.rx.text).disposed(by: disposer)
        output.reward.drive(rewardTagView.rx.text).disposed(by: disposer)
    }
}
