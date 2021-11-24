//
//  Created with ♥ by BanklessDAO contributors on 2021-11-22.
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

class AcademyCoursePoapSectionView: BaseView<AcademyCoursePoapSectionViewModel>,
                                    AcademyCourseSectionView
{
    // MARK: - Constants -
    
    private static let imageToViewWidthRatio: CGFloat = 0.5
    private static let title = NSLocalizedString(
        "acedemy.course.section.poap.title",
        value: "Collect your POAP",
        comment: ""
    )
    private static let subtitle = NSLocalizedString(
        "acedemy.course.section.poap.subtitle",
        value: "You've completed the course! Collect your POAP to show off.",
        comment: ""
    )
    private static let claimActionTitle = NSLocalizedString(
        "acedemy.course.section.poap.action.claim.title",
        value: "Claim POAP",
        comment: ""
    )
    private static let buttonHeight: CGFloat = 50.0
    
    // MARK: - Subviews -
    
    private var containerView: UIView!
    private var poapImageView: UIImageView!
    private var titleLabel: UILabel!
    private var subtitleLabel: UILabel!
    private var actionButton: UIButton!
    
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
        
        poapImageView = UIImageView()
        poapImageView.contentMode = .scaleAspectFit
        containerView.addSubview(poapImageView)
        
        titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.text = AcademyCoursePoapSectionView.title
        titleLabel.textColor = .secondaryWhite
        titleLabel.textAlignment = .center
        titleLabel.font = Appearance.Text.Font.Title2.font(bold: true)
        containerView.addSubview(titleLabel)
        
        subtitleLabel = UILabel()
        subtitleLabel.numberOfLines = 0
        subtitleLabel.text = AcademyCoursePoapSectionView.subtitle
        subtitleLabel.textColor = .secondaryWhite
        subtitleLabel.textAlignment = .center
        subtitleLabel.font = Appearance.Text.Font.Body.font(bold: false)
        containerView.addSubview(subtitleLabel)
        
        actionButton = UIButton(type: .custom)
        actionButton.setTitle(
            "  \(AcademyCoursePoapSectionView.claimActionTitle)  ",
            for: .normal
        )
        actionButton.titleLabel?.font = Appearance.Text.Font.Label2.font(bold: true)
        actionButton.backgroundColor = .primaryRed.withAlphaComponent(0.75)
        actionButton.layer.cornerRadius = Appearance.cornerRadius
        containerView.addSubview(actionButton)
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
        
        constrain(poapImageView, containerView) { image, view in
            image.centerX == view.centerX
            image.top == view.top + contentInsets.top
            image.width == view.width * AcademyCoursePoapSectionView.imageToViewWidthRatio
            image.height == image.width
        }
        
        constrain(titleLabel, poapImageView, containerView) { title, image, view in
            title.top == image.bottom + contentInsets.bottom
            title.left == view.left + contentInsets.left
            title.right == view.right - contentInsets.right
        }
        
        constrain(subtitleLabel, titleLabel, containerView) { subtitle, title, view in
            subtitle.top == title.bottom + contentInsets.bottom
            subtitle.left == view.left + contentInsets.left
            subtitle.right == view.right - contentInsets.right
        }
        
        constrain(actionButton, subtitleLabel, containerView) { button, subtitle, view in
            button.top == subtitle.bottom + contentInsets.bottom
            button.centerX == view.centerX
            button.height == AcademyCoursePoapSectionView.buttonHeight
            button.bottom == view.bottom - contentInsets.bottom
        }
    }
    
    override func bindViewModel() {
        let output = viewModel.transform(
            input: .init(claim: actionButton.rx.tap.asDriver())
        )
        
        output.poapImageURL
            .drive(onNext: { [weak self] url in self?.poapImageView.kf.setImage(with: url) })
            .disposed(by: disposer)
    }
}
