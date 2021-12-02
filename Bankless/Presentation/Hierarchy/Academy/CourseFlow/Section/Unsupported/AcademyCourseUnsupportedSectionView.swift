//
//  Created with ♥ by BanklessDAO contributors on 2021-12-01.
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

class AcademyCourseUnsupportedSectionView: BaseView<AcademyCourseUnsupportedSectionViewModel>,
                                           AcademyCourseSectionView
{
    // MARK: - Constants -
    
    private static let imageToViewWidthRatio: CGFloat = 0.5
    private static let title = NSLocalizedString(
        "academy.course.section.unsupported.title",
        value: "Unsupported Section",
        comment: ""
    )
    private static let subtitle = NSLocalizedString(
        "academy.course.section.unsupported.subtitle",
        value: "This section can only be completed in a web browser with Metamask conneted. Please use the web version of Bankless Academy.",
        comment: ""
    )
    private static let buttonHeight: CGFloat = 50.0
    private static let unsupportedIcon = UIImage(named: "unsupported_sign")!
    
    // MARK: - Subviews -
    
    private var containerView: UIView!
    private var unsupportedImageView: UIImageView!
    private var titleLabel: UILabel!
    private var subtitleLabel: UILabel!
    
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
    
    private func setUpSubviews() {
        containerView = UIView()
        containerView.backgroundColor = .backgroundGrey.withAlphaComponent(0.5)
        containerView.layer.cornerRadius = Appearance.cornerRadius
        addSubview(containerView)
        
        unsupportedImageView = UIImageView()
        unsupportedImageView.image = AcademyCourseUnsupportedSectionView.unsupportedIcon
        unsupportedImageView.contentMode = .scaleAspectFit
        containerView.addSubview(unsupportedImageView)
        
        titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.text = AcademyCourseUnsupportedSectionView.title
        titleLabel.textColor = .secondaryWhite
        titleLabel.textAlignment = .center
        titleLabel.font = Appearance.Text.Font.Title2.font(bold: true)
        containerView.addSubview(titleLabel)
        
        subtitleLabel = UILabel()
        subtitleLabel.numberOfLines = 0
        subtitleLabel.text = AcademyCourseUnsupportedSectionView.subtitle
        subtitleLabel.textColor = .secondaryWhite
        subtitleLabel.textAlignment = .center
        subtitleLabel.font = Appearance.Text.Font.Body.font(bold: false)
        containerView.addSubview(subtitleLabel)
    }
    
    private func setUpConstraints() {
        constrain(self) { view in
            view.height == 0 ~ .defaultLow
        }
        
        constrain(containerView, self) { container, view in
            container.left == view.left + contentInsets.left
            container.right == view.right - contentInsets.right
            container.top == view.top + contentInsets.top
            container.bottom == view.bottom - contentInsets.bottom
        }
        
        constrain(unsupportedImageView, containerView) { image, view in
            image.centerX == view.centerX
            image.top == view.top + contentInsets.top * 2
            image.width == view.width * AcademyCourseUnsupportedSectionView.imageToViewWidthRatio
            image.height == image.width
        }
        
        constrain(titleLabel, unsupportedImageView, containerView) { title, image, view in
            title.top == image.bottom + contentInsets.bottom
            title.left == view.left + contentInsets.left * 2
            title.right == view.right - contentInsets.right * 2
        }
        
        constrain(subtitleLabel, titleLabel, containerView) { subtitle, title, view in
            subtitle.top == title.bottom + contentInsets.bottom
            subtitle.left == view.left + contentInsets.left * 2
            subtitle.right == view.right - contentInsets.right * 2
            subtitle.bottom == view.bottom - contentInsets.bottom * 2
        }
    }
    
    override func bindViewModel() { }
}
