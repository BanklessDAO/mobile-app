//
//  Created with ♥ by BanklessDAO contributors on 2021-10-14.
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

class GaugeClusterView: BaseView<GaugeClusterViewModel> {
    // MARK: - Constants -
    
    private static let tagHeight: CGFloat = 40.0
    private static let tagPadding: CGFloat = 20.0
    
    // MARK: - Subviews -
    
    private var balanceTagView: TagView!
    private var lastTransactionLabel: UILabel!
    private var achievementsBarView: AchievementsBarView!
    private var lastAchievementLabel: UILabel!
    
    // MARK: - Initializers -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup -
    
    private func setUp() {
        setUpSubviews()
        setUpConstraints()
    }
    
    func setUpSubviews() {
        balanceTagView = TagView()
        balanceTagView.layer.cornerRadius = Appearance.cornerRadius
        balanceTagView.backgroundColor = .primaryRed.withAlphaComponent(0.5)
        balanceTagView.textColor = .secondaryWhite
        balanceTagView.font = Appearance.Text.Font.Label2.font(bold: true)
        balanceTagView.horizontalPadding = GaugeClusterView.tagPadding
        addSubview(balanceTagView)
        
        achievementsBarView = AchievementsBarView()
        addSubview(achievementsBarView)
        
        lastTransactionLabel = UILabel()
        lastTransactionLabel.numberOfLines = 0
        lastTransactionLabel.font = Appearance.Text.Font.Label2.font(bold: false)
        lastTransactionLabel.textColor = .secondaryWhite
        addSubview(lastTransactionLabel)
        
        lastAchievementLabel = UILabel()
        lastAchievementLabel.numberOfLines = 0
        lastAchievementLabel.font = Appearance.Text.Font.Label2.font(bold: false)
        lastAchievementLabel.textColor = .secondaryWhite
        addSubview(lastAchievementLabel)
    }
    
    func setUpConstraints() {
        constrain(balanceTagView, self) { balance, view in
            balance.top == view.top + contentInsets.top
            balance.right == view.right - contentInsets.right
            balance.height == GaugeClusterView.tagHeight
        }
        
        constrain(achievementsBarView, balanceTagView, self) { achievements, balance, view in
            achievements.top == balance.bottom + contentPaddings.bottom
            achievements.right == balance.right
            achievements.height == GaugeClusterView.tagHeight
            achievements.bottom == view.bottom - Appearance.contentInsets.bottom
        }
        
        constrain(lastTransactionLabel, balanceTagView, self) { tx, balance, view in
            tx.left == view.left + contentInsets.left
            tx.height == balance.height
            tx.centerY == balance.centerY
            tx.right == balance.left - contentPaddings.left
        }
        
        constrain(lastAchievementLabel, achievementsBarView, self) { event, events, view in
            event.left == view.left + contentInsets.left
            event.height == events.height
            event.centerY == events.centerY
            event.right == events.left - contentPaddings.left
        }
    }
    
    override func bindViewModel() {
        let output = viewModel.transform(input: input())
        
        output.balance.drive(balanceTagView.rx.text).disposed(by: disposer)
        output.achievementImageURLs
            .drive(onNext: { [weak self] URLs in
                self?.achievementsBarView.set(achievementImageURLs: URLs ?? [])
            })
            .disposed(by: disposer)
        output.lastTransaction.drive(lastTransactionLabel.rx.text).disposed(by: disposer)
        output.lastAchievementMessage.drive(lastAchievementLabel.rx.text).disposed(by: disposer)
    }
    
    private func input() -> GaugeClusterViewModel.Input {
        return .init(
            tapAchievements: .empty()
        )
    }
}
