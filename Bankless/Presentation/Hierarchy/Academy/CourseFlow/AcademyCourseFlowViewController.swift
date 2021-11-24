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
import RxSwift
import RxCocoa
import Cartography
import Kingfisher

class AcademyCourseFlowViewController: BaseViewController<AcademyCourseFlowViewModel> {
    // MARK: - Constants -
    
    private static let buttonHeight: CGFloat = 50.0
    private static let separatorHeight: CGFloat = 1
    
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
    
    // MARK: - Subviews -
    
    private var contentView: UIView!
    private var scrollView: UIScrollView!
    private var scrollContainerView: UIView!
    
    private var navigationLabel: UILabel!
    private var titleLabel: UILabel!
    private var headerSeparatorView: UIView!
    private var footerSeparatorView: UIView!
    private var sectionContainerView: UIView!
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
            string: AcademyCourseFlowViewController.navLabelText0,
            attributes: .init(
                [
                    .font: Appearance.Text.Font.Note.font(bold: false),
                    .foregroundColor: UIColor.primaryRed
                ]
            )
        )
        let navLabelAttributedString1 = NSAttributedString(
            string: " " + AcademyCourseFlowViewController.navLabelText1,
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
        
        titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .secondaryWhite
        titleLabel.font = Appearance.Text.Font.Title2.font(bold: true)
        scrollContainerView.addSubview(titleLabel)
        
        headerSeparatorView = UIView()
        headerSeparatorView.backgroundColor = .backgroundGrey
        scrollContainerView.addSubview(headerSeparatorView)
        
        sectionContainerView = UIView()
        scrollContainerView.addSubview(sectionContainerView)
        
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
        
        constrain(scrollContainerView, scrollView, contentView) { container, scroll, view in
            container.edges == scroll.edges
            container.width == view.width
            container.height == view.height ~ .defaultLow
        }
        
        constrain(navigationLabel, scrollContainerView) { nav, view in
            nav.left == view.left + contentInsets.left
            nav.right == view.right - contentInsets.right
            nav.top == view.safeAreaLayoutGuide.top + contentInsets.top
            nav.height == Appearance.Text.Font.Note.lineHeight
        }
        
        constrain(titleLabel, navigationLabel, scrollContainerView) { title, nav, view in
            title.left == view.left + contentInsets.left
            title.right == view.right - contentInsets.right
            title.top == nav.bottom + contentPaddings.bottom * 2
        }
        
        constrain(headerSeparatorView, titleLabel, scrollContainerView) { sep, title, view in
            sep.left == view.left + contentInsets.left
            sep.right == view.right - contentInsets.right
            sep.top == title.bottom + contentInsets.bottom * 2
            sep.height == AcademyCourseFlowViewController.separatorHeight
        }
        
        constrain(
            sectionContainerView, headerSeparatorView, scrollContainerView
        ) { section, sep, view in
            section.top == sep.bottom + contentInsets.bottom * 2
            section.left == view.left + contentInsets.left
            section.right == view.right - contentInsets.right
            section.bottom == view.bottom - contentInsets.bottom * 2
        }
        
        constrain(footerSeparatorView, navControl, view) { sep, nav, view in
            sep.left == view.left + contentInsets.left
            sep.right == view.right - contentInsets.right
            sep.bottom == nav.top - contentInsets.bottom * 2
            sep.height == AcademyCourseFlowViewController.separatorHeight
        }
        
        constrain(navControl, view) { nav, view in
            nav.left == view.left + contentInsets.left
            nav.right == view.right - contentInsets.right
            nav.height == AcademyCourseFlowViewController.buttonHeight
            nav.bottom == view.safeAreaLayoutGuide.bottom - contentInsets.bottom
        }
    }
    
    private func loadSection(for sectionViewModel: AcademyCourseSectionViewModel) {
        sectionContainerView.subviews.forEach({ $0.removeFromSuperview() })
        
        let sectionView = AcademyCourseSectionFactory
            .createSectionView(for: sectionViewModel)
        
        sectionContainerView.addSubview(sectionView)
        
        constrain(sectionView as UIView, sectionContainerView) { section, container in
            section.edges == container.edges
        }
    }
    
    func bindViewModel() {
        let output = viewModel.transform(input: input())
        
        output.title.drive(titleLabel.rx.text).disposed(by: disposer)
        output.currentSectionViewModel
            .drive(onNext: { [weak self] sectionViewModel in
                self?.loadSection(for: sectionViewModel)
            })
            .disposed(by: disposer)
        navControl.bind(viewModel: output.sectionNavViewModel)
    }
    
    private func input() -> AcademyCourseFlowViewModel.Input {
        return .init()
    }
}
