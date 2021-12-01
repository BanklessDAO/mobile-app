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
import Kingfisher

class AchievementsBarView: UIView {
    // MARK: - Constants -
    
    private static let maxPreviewItemCount: Int = 3
    private static let itemPadding: CGFloat = 5.0
    private static let placeholderMessage = NSLocalizedString(
        "achievements.event.bar.placeholder.message",
        value: "0 Achievements",
        comment: ""
    )
    
    // MARK: - Properties -
    
    private var achievementImageURLs: [URL]!
    
    // MARK: - Subviews -
    
    private var achievementsStackView: UIStackView!
    private var truncationLabel: AutoWidthLabel!
    
    // MARK: - Initializers -
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle -
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for view in achievementsStackView.arrangedSubviews {
            view.layer.cornerRadius = view.bounds.height / 2
        }
    }
    
    // MARK: - Setters -
    
    func set(achievementImageURLs: [URL]) {
        self.achievementImageURLs = achievementImageURLs
        resetAchievementsLayout()
    }
    
    // MARK: - Setup -
    
    private func setUp() {
        setUpSubviews()
        setUpConstraints()
        
        set(achievementImageURLs: [])
    }
    
    func setUpSubviews() {
        backgroundColor = .backgroundGrey
        layer.cornerRadius = Appearance.cornerRadius
        
        achievementsStackView = UIStackView()
        achievementsStackView.alignment = .leading
        achievementsStackView.spacing = AchievementsBarView.itemPadding
        achievementsStackView.axis = .horizontal
        addSubview(achievementsStackView)
        
        truncationLabel = AutoWidthLabel()
        truncationLabel.numberOfLines = 1
        truncationLabel.textColor = .secondaryWhite
        addSubview(truncationLabel)
    }
    
    func setUpConstraints() {
        constrain(achievementsStackView, truncationLabel, self) { achievements, label, view in
            achievements.left == view.left + Appearance.contentInsets.left
            achievements.top == view.top + AchievementsBarView.itemPadding
            achievements.bottom == view.bottom - AchievementsBarView.itemPadding
            achievements.right == label.left
            label.right == view.right - Appearance.contentPaddings.right
            label.centerY == view.centerY
            label.height == view.height
        }
    }
    
    // MARK: - Dynamic layout -
    
    private func resetAchievementsLayout() {
        for subview in achievementsStackView.subviews {
            subview.removeFromSuperview()
        }
        truncationLabel.text = ""
        
        guard !achievementImageURLs.isEmpty else {
            truncationLabel.text = AchievementsBarView.placeholderMessage
            return
        }
        
        let previewItemCount = min(
            achievementImageURLs.count,
            AchievementsBarView.maxPreviewItemCount
        )
        
        for imageURL in achievementImageURLs[0 ..< previewItemCount] {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            
            imageView.kf.setImage(with: imageURL)
            
            constrain(imageView) { image in
                image.width == image.height
            }
            
            achievementsStackView.addArrangedSubview(imageView)
        }
        
        let hiddenCount = achievementImageURLs.count - previewItemCount
        if hiddenCount > 0 {
            truncationLabel.text = " +" + String(hiddenCount)
        }
        
        layoutIfNeeded()
        
        for subview in achievementsStackView.arrangedSubviews {
            subview.clipsToBounds = true
            subview.layer.cornerRadius = subview.bounds.height / 2
        }
    }
}
