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
import RxSwift
import RxCocoa
import Cartography
import Kingfisher

class AcademyCourseDetailsViewController: BaseViewController<AcademyCourseDetailsViewModel> {
    // MARK: - Constants -
    
    private static let tagPadding: CGFloat = 30.0
    private static let tagHeight: CGFloat = 40.0
    private static let buttonHeight: CGFloat = 50.0
    private static let separatorHeight: CGFloat = 1
    private static let collectibleImageToScreenWidthRatio = 0.25
    
    private static let navLabelText0 = NSLocalizedString(
        "academy_course.details.navigation.pt0.title",
        value: "Academy",
        comment: ""
    )
    private static let navLabelText1 = NSLocalizedString(
        "academy_course.details.navigation.pt1.title",
        value: "Course",
        comment: ""
    )
    private static let fields = (
        collectible: NSLocalizedString(
            "academy_course.details.collectible.title",
            value: "Collectible",
            comment: ""
        ),
        collectibleSub: NSLocalizedString(
            "academy_course.details.collectible.subtitle",
            value: "You will get a POAP after completing this course.",
            comment: ""
        )
    )
    
    // MARK: - Subviews -
    
    private var contentView: UIView!
    private var scrollView: UIScrollView!
    private var scrollContainerView: UIView!
    
    private var navigationLabel: UILabel!
    private var difficultyTagView: TagView!
    private var durationTagView: TagView!
    private var titleLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var headerSeparatorView: UIView!
    private var detailsContainerView: UIView!
    private var detailCards: [AcademyCourseDetailCard]!
    private var collectibleTextContainerView: UIView!
    private var collectibleTitleLabel: UILabel!
    private var collectibleSubtitleLabel: UILabel!
    private var collectibleImageView: UIImageView!
    private var footerSeparatorView: UIView!
    private var navControl: SectionNavigationControlView!
    
    // MARK: - Setup -
    
    override func setUp() {
        setUpSubviews()
        setUpConstraints()
        bindViewModel()
    }
    
    func setUpSubviews() {
        view.backgroundColor = .backgroundBlack
        
        contentView = UIView()
        contentView.backgroundColor = .backgroundBlack
        view.addSubview(contentView)
        
        scrollView = UIScrollView()
        contentView.addSubview(scrollView)
        
        scrollContainerView = UIView()
        scrollContainerView.backgroundColor = .backgroundBlack
        scrollView.addSubview(scrollContainerView)
        
        let navLabelAttributedString0 = NSMutableAttributedString(
            string: AcademyCourseDetailsViewController.navLabelText0,
            attributes: .init(
                [
                    .font: Appearance.Text.Font.Note.font(bold: false),
                    .foregroundColor: UIColor.primaryRed
                ]
            )
        )
        let navLabelAttributedString1 = NSAttributedString(
            string: " " + AcademyCourseDetailsViewController.navLabelText1,
            attributes: .init(
                [
                    .font: Appearance.Text.Font.Note.font(bold: false),
                    .foregroundColor: UIColor.backgroundGrey
                ]
            )
        )
        navLabelAttributedString0.append(navLabelAttributedString1)
        
        navigationLabel = UILabel()
        navigationLabel.attributedText = navLabelAttributedString0
        scrollContainerView.addSubview(navigationLabel)
        
        difficultyTagView = TagView()
        difficultyTagView.font = Appearance.Text.Font.Label2.font(bold: true)
        difficultyTagView.cornerRadius = Appearance.cornerRadius
        difficultyTagView.backgroundColor = .backgroundGrey
        difficultyTagView.horizontalPadding = AcademyCourseDetailsViewController.tagPadding
        scrollContainerView.addSubview(difficultyTagView)
        
        durationTagView = TagView()
        durationTagView.font = Appearance.Text.Font.Label2.font(bold: true)
        durationTagView.cornerRadius = Appearance.cornerRadius
        durationTagView.backgroundColor = .backgroundGrey
        durationTagView.horizontalPadding = AcademyCourseDetailsViewController.tagPadding
        scrollContainerView.addSubview(durationTagView)
        
        titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .secondaryWhite
        titleLabel.font = Appearance.Text.Font.Title2.font(bold: true)
        scrollContainerView.addSubview(titleLabel)
        
        descriptionLabel = UILabel()
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .secondaryWhite
        descriptionLabel.font = Appearance.Text.Font.Label2.font(bold: false)
        scrollContainerView.addSubview(descriptionLabel)
        
        headerSeparatorView = UIView()
        headerSeparatorView.backgroundColor = .backgroundGrey
        scrollContainerView.addSubview(headerSeparatorView)
        
        detailsContainerView = UIView()
        scrollContainerView.addSubview(detailsContainerView)
        
        collectibleTextContainerView = UIView()
        scrollContainerView.addSubview(collectibleTextContainerView)
        
        collectibleTitleLabel = UILabel()
        collectibleTitleLabel.text = AcademyCourseDetailsViewController.fields.collectible
        collectibleTitleLabel.textColor = .secondaryWhite
        collectibleTitleLabel.font = Appearance.Text.Font.Title2.font(bold: true)
        collectibleTextContainerView.addSubview(collectibleTitleLabel)
        
        collectibleSubtitleLabel = UILabel()
        collectibleSubtitleLabel.numberOfLines = 0
        collectibleSubtitleLabel.text = AcademyCourseDetailsViewController.fields.collectibleSub
        collectibleSubtitleLabel.textColor = .secondaryWhite
        collectibleSubtitleLabel.font = Appearance.Text.Font.Body.font(bold: false)
        collectibleTextContainerView.addSubview(collectibleSubtitleLabel)
        
        collectibleImageView = UIImageView()
        collectibleImageView.contentMode = .scaleAspectFit
        scrollContainerView.addSubview(collectibleImageView)
        
        footerSeparatorView = UIView()
        footerSeparatorView.backgroundColor = .backgroundGrey.withAlphaComponent(0.5)
        view.addSubview(footerSeparatorView)
        
        navControl = SectionNavigationControlView()
        view.addSubview(navControl)
    }
    
    func setUpConstraints() {
        constrain(contentView, footerSeparatorView, view) { content, footer, view in
            content.top == view.safeAreaLayoutGuide.top
            content.left == view.left
            content.right == view.right
            content.bottom == footer.top
        }
        
        constrain(scrollView, contentView) { scroll, view in
            scroll.top == view.safeAreaLayoutGuide.top
            scroll.left == view.left
            scroll.right == view.right
            scroll.bottom == view.bottom
        }
        
        constrain(scrollContainerView, scrollView, view) { container, scroll, view in
            container.edges == scroll.edges
                .inseted(by: .init(
                    top: contentInsets.top,
                    left: contentInsets.left,
                    bottom: contentInsets.bottom,
                    right: contentInsets.right
                ))
            container.width == view.width - contentInsets.left - contentInsets.right
            container.height == view.height
            - contentInsets.top - contentInsets.bottom
            ~ .defaultLow
        }
        
        constrain(navigationLabel, scrollContainerView) { nav, view in
            nav.left == view.left + contentInsets.left
            nav.right == view.right - contentInsets.right
            nav.top == view.safeAreaLayoutGuide.top + contentInsets.top
            nav.height == Appearance.Text.Font.Note.lineHeight
        }
        
        constrain(
            difficultyTagView, navigationLabel, scrollContainerView
        ) { (difficulty, nav, view) in
            difficulty.top == nav.bottom + contentInsets.bottom
            difficulty.left == view.left + contentInsets.left
            difficulty.height == AcademyCourseDetailsViewController.tagHeight
        }
        
        constrain(durationTagView, difficultyTagView) { (duration, dif) in
            duration.centerY == dif.centerY
            duration.left == dif.right + contentInsets.right
            duration.height == AcademyCourseDetailsViewController.tagHeight
        }
        
        constrain(titleLabel, difficultyTagView, scrollContainerView) { title, dif, view in
            title.left == view.left + contentInsets.left
            title.right == view.right - contentInsets.right
            title.top == dif.bottom + contentPaddings.bottom * 2
        }
        
        constrain(descriptionLabel, titleLabel, scrollContainerView) { subtitle, title, view in
            subtitle.left == view.left + contentInsets.left
            subtitle.right == view.right - contentInsets.right
            subtitle.top == title.bottom + contentPaddings.bottom
        }
        
        constrain(
            headerSeparatorView, descriptionLabel, scrollContainerView
        ) { sep, subtitle, view in
            sep.left == view.left + contentInsets.left
            sep.right == view.right - contentInsets.right
            sep.top == subtitle.bottom + contentInsets.bottom * 2
            sep.height == AcademyCourseDetailsViewController.separatorHeight
        }
        
        constrain(
            detailsContainerView, headerSeparatorView, scrollContainerView
        ) { details, sep, view in
            details.top == sep.bottom + contentInsets.bottom * 2
            details.left == view.left + contentInsets.left
            details.right == view.right - contentInsets.right
        }
        
        constrain(
            collectibleImageView, detailsContainerView, scrollContainerView
        ) { colImage, details, view in
            colImage.right == view.right - contentInsets.right
            colImage.top == details.bottom + contentInsets.bottom * 2
            colImage.width == view.width
                * AcademyCourseDetailsViewController.collectibleImageToScreenWidthRatio
            colImage.height == colImage.width
            colImage.bottom == view.bottom - contentInsets.bottom
        }
        
        constrain(
            collectibleTextContainerView, collectibleImageView, scrollContainerView
        ) { colText, colImage, view in
            colText.left == view.left + contentInsets.left
            colText.right == colImage.left - contentPaddings.left
            colText.centerY == colImage.centerY
        }
        
        constrain(
            collectibleTitleLabel, collectibleTextContainerView
        ) { colTitle, container in
            colTitle.left == container.left
            colTitle.right == container.right
            colTitle.top == container.top
        }
        
        constrain(
            collectibleSubtitleLabel, collectibleTitleLabel, collectibleTextContainerView
        ) { colSub, colTitle, container in
            colSub.left == container.left
            colSub.right == container.right
            colSub.top == colTitle.bottom + contentPaddings.bottom
            colSub.bottom == container.bottom
        }
        
        constrain(footerSeparatorView, navControl, view) { sep, nav, view in
            sep.left == view.left + contentInsets.left
            sep.right == view.right - contentInsets.right
            sep.bottom == nav.top - contentInsets.bottom * 2
            sep.height == AcademyCourseDetailsViewController.separatorHeight
        }
        
        constrain(navControl, view) { nav, view in
            nav.left == view.left + contentInsets.left
            nav.right == view.right - contentInsets.right
            nav.height == AcademyCourseDetailsViewController.buttonHeight
            nav.bottom == view.safeAreaLayoutGuide.bottom - contentInsets.bottom
        }
    }
    
    private func spawnDetails(for detailViewModels: [AcademyCourseDetailViewModel]) {
        guard let firstDetailVM = detailViewModels.first else { return }
        
        let firstDetailCard = AcademyCourseDetailCard()
        firstDetailCard.bind(viewModel: firstDetailVM)
        detailsContainerView.addSubview(firstDetailCard)
        
        constrain(firstDetailCard, detailsContainerView) { card, container in
            card.top == container.top
            card.left == container.left
            card.right == container.right
        }
        
        var lastDetailCard = firstDetailCard
        for detailIndex in 1 ..< detailViewModels.count {
            let detailVM = detailViewModels[detailIndex]
            
            let detailCard = AcademyCourseDetailCard()
            detailCard.bind(viewModel: detailVM)
            detailsContainerView.addSubview(detailCard)
            
            constrain(detailCard, lastDetailCard, detailsContainerView) { cur, last, container in
                cur.top == last.bottom + contentInsets.bottom
                cur.left == container.left
                cur.right == container.right
            }
            
            lastDetailCard = detailCard
        }
        
        constrain(lastDetailCard, detailsContainerView) { last, container in
            last.bottom == container.bottom
        }
    }
    
    func bindViewModel() {
        let output = viewModel.transform(input: input())
        
        output.difficulty.drive(difficultyTagView.rx.text).disposed(by: disposer)
        output.duration.drive(durationTagView.rx.text).disposed(by: disposer)
        output.title.drive(titleLabel.rx.text).disposed(by: disposer)
        output.description.drive(descriptionLabel.rx.text).disposed(by: disposer)
        output.detailViewModels
            .drive(onNext: { [weak self] detailViewModels in
                self?.spawnDetails(for: detailViewModels)
            })
            .disposed(by: disposer)
        output.collectibleImageURL
            .drive(onNext: { [weak self] url in
                self?.collectibleImageView.kf.setImage(with: url)
            })
            .disposed(by: disposer)
        navControl.bind(viewModel: output.sectionNavViewModel)
    }
    
    private func input() -> AcademyCourseDetailsViewModel.Input {
        return .init()
    }
}
