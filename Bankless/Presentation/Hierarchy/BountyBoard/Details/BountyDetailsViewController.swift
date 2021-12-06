//
//  Created with ♥ by BanklessDAO contributors on 2021-11-11.
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

class BountyDetailsViewController: BaseViewController<BountyDetailsViewModel> {
    // MARK: - Constants -
    
    private static let tagPadding: CGFloat = 30.0
    private static let tagHeight: CGFloat = 40.0
    private static let buttonHeight: CGFloat = 50.0
    private static let headerSeparatorHeight: CGFloat = 1
    
    private static let navLabelText = NSLocalizedString(
        "bounty.details.navigation.title",
        value: "Bounty",
        comment: ""
    )
    private static let titles = (
        reward: NSLocalizedString(
            "bounty.details.reward.title",
            value: "Reward",
            comment: ""
        ),
        status: NSLocalizedString(
            "bounty.details.status.title",
            value: "Status",
            comment: ""
        ),
        description: NSLocalizedString(
            "bounty.details.description.title",
            value: "Description",
            comment: ""
        ),
        criteria: NSLocalizedString(
            "bounty.details.criteria.title",
            value: "Done Criteria",
            comment: ""
        ),
        requestedBy: NSLocalizedString(
            "bounty.details.requested_by.title",
            value: "Requested By",
            comment: ""
        ),
        claimedBy: NSLocalizedString(
            "bounty.details.claimed_by.title",
            value: "Claimed By",
            comment: ""
        )
    )
    
    // MARK: - Properties -
    
    private var dynamicConstraints = ConstraintGroup()
    
    // MARK: - Subviews -
    
    private var scrollView: UIScrollView!
    private var containerView: UIView!
    
    private var navigationLabel: UILabel!
    private var titleLabel: UILabel!
    private var rewardTitleLabel: AutoWidthLabel!
    private var rewardTagView: TagView!
    private var statusTitleLabel: AutoWidthLabel!
    private var statusTagView: TagView!
    private var lifecycleActionButton: UIButton!
    private var headerSeparatorView: UIView!
    private var descriptionTitleLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var criteriaTitleLabel: UILabel!
    private var criteriaLabel: UILabel!
    private var requestedByTitleLabel: UILabel!
    private var requestedByTagView: IdentityStripeView!
    private var claimedByTitleLabel: UILabel!
    private var claimedByTagView: IdentityStripeView!
    
    // MARK: - Setup -
    
    override func setUp() {
        setUpSubviews()
        setUpConstraints()
        bindViewModel()
    }
    
    func setUpSubviews() {
        view.backgroundColor = .backgroundBlack
        
        scrollView = UIScrollView()
        view.addSubview(scrollView)
        
        containerView = UIView()
        containerView.backgroundColor = .backgroundBlack
        scrollView.addSubview(containerView)
        
        navigationLabel = UILabel()
        navigationLabel.text = BountyDetailsViewController.navLabelText
        navigationLabel.textColor = .primaryRed
        navigationLabel.font = Appearance.Text.Font.Note.font(bold: false)
        containerView.addSubview(navigationLabel)
        
        titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .secondaryWhite
        titleLabel.font = Appearance.Text.Font.Title2.font(bold: true)
        containerView.addSubview(titleLabel)
        
        rewardTitleLabel = AutoWidthLabel()
        rewardTitleLabel.text = BountyDetailsViewController.titles.reward
        rewardTitleLabel.textColor = .backgroundGrey
        rewardTitleLabel.font = Appearance.Text.Font.Label2.font(bold: true)
        containerView.addSubview(rewardTitleLabel)
        
        rewardTagView = TagView()
        rewardTagView.font = Appearance.Text.Font.Label2.font(bold: true)
        rewardTagView.cornerRadius = Appearance.cornerRadius
        rewardTagView.backgroundColor = .backgroundGrey.withAlphaComponent(0.5)
        rewardTagView.horizontalPadding = BountyDetailsViewController.tagPadding
        containerView.addSubview(rewardTagView)
        
        statusTitleLabel = AutoWidthLabel()
        statusTitleLabel.text = BountyDetailsViewController.titles.status
        statusTitleLabel.textColor = .backgroundGrey
        statusTitleLabel.font = Appearance.Text.Font.Label2.font(bold: true)
        containerView.addSubview(statusTitleLabel)
        
        statusTagView = TagView()
        statusTagView.font = Appearance.Text.Font.Label2.font(bold: true)
        statusTagView.cornerRadius = Appearance.cornerRadius
        statusTagView.backgroundColor = .backgroundGrey.withAlphaComponent(0.5)
        statusTagView.horizontalPadding = BountyDetailsViewController.tagPadding
        containerView.addSubview(statusTagView)
        
        lifecycleActionButton = UIButton(type: .custom)
        lifecycleActionButton.titleLabel?.font = Appearance.Text.Font.Label2.font(bold: true)
        lifecycleActionButton.isHidden = true
        lifecycleActionButton.backgroundColor = .primaryRed.withAlphaComponent(0.75)
        lifecycleActionButton.layer.cornerRadius = Appearance.cornerRadius
        containerView.addSubview(lifecycleActionButton)
        
        headerSeparatorView = UIView()
        headerSeparatorView.backgroundColor = .backgroundGrey
        containerView.addSubview(headerSeparatorView)
        
        descriptionTitleLabel = UILabel()
        descriptionTitleLabel.text = BountyDetailsViewController.titles.description
        descriptionTitleLabel.textColor = .backgroundGrey
        descriptionTitleLabel.font = Appearance.Text.Font.Label2.font(bold: true)
        containerView.addSubview(descriptionTitleLabel)
        
        descriptionLabel = UILabel()
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .secondaryWhite
        descriptionLabel.font = Appearance.Text.Font.Body.font(bold: false)
        containerView.addSubview(descriptionLabel)
        
        criteriaTitleLabel = UILabel()
        criteriaTitleLabel.text = BountyDetailsViewController.titles.criteria
        criteriaTitleLabel.textColor = .backgroundGrey
        criteriaTitleLabel.font = Appearance.Text.Font.Label2.font(bold: true)
        containerView.addSubview(criteriaTitleLabel)
        
        criteriaLabel = UILabel()
        criteriaLabel.numberOfLines = 0
        criteriaLabel.textColor = .secondaryWhite
        criteriaLabel.font = Appearance.Text.Font.Body.font(bold: false)
        containerView.addSubview(criteriaLabel)
        
        requestedByTitleLabel = UILabel()
        requestedByTitleLabel.text = BountyDetailsViewController.titles.requestedBy
        requestedByTitleLabel.textColor = .backgroundGrey
        requestedByTitleLabel.font = Appearance.Text.Font.Label2.font(bold: true)
        containerView.addSubview(requestedByTitleLabel)
        
        requestedByTagView = IdentityStripeView(layoutDirection: .leftHand)
        containerView.addSubview(requestedByTagView)
        
        claimedByTitleLabel = UILabel()
        claimedByTitleLabel.text = BountyDetailsViewController.titles.claimedBy
        claimedByTitleLabel.isHidden = true
        claimedByTitleLabel.textColor = .backgroundGrey
        claimedByTitleLabel.font = Appearance.Text.Font.Label2.font(bold: true)
        containerView.addSubview(claimedByTitleLabel)
        
        claimedByTagView = IdentityStripeView(layoutDirection: .leftHand)
        claimedByTagView.isHidden = true
        containerView.addSubview(claimedByTagView)
    }
    
    func setUpConstraints() {
        constrain(scrollView, view) { scroll, view in
            scroll.top == view.safeAreaLayoutGuide.top
            scroll.left == view.left
            scroll.right == view.right
            scroll.bottom == view.bottom
        }
        
        constrain(containerView, scrollView, view) { container, scroll, view in
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
        
        constrain(navigationLabel, containerView) { nav, view in
            nav.left == view.left + contentInsets.left
            nav.right == view.right - contentInsets.right
            nav.top == view.safeAreaLayoutGuide.top + contentInsets.top
            nav.height == Appearance.Text.Font.Note.lineHeight
        }
        
        constrain(titleLabel, navigationLabel, containerView) { title, nav, view in
            title.left == view.left + contentInsets.left
            title.right == view.right - contentInsets.right
            title.top == nav.bottom + contentPaddings.bottom
        }
        
        constrain(rewardTitleLabel, titleLabel, containerView) { rew, title, view in
            rew.left == view.left + contentInsets.left
            rew.top == title.bottom + contentInsets.bottom
            rew.height == Appearance.Text.Font.Label2.lineHeight
        }
        
        constrain(rewardTagView, rewardTitleLabel, containerView) { tag, title, view in
            tag.left == view.left + contentInsets.left
            tag.top == title.bottom + contentPaddings.bottom
            tag.height == BountyDetailsViewController.tagHeight
        }
        
        constrain(
            statusTitleLabel, rewardTitleLabel, rewardTagView, view
        ) { st, rewTitle, rew, view in
            st.left == rew.right + contentInsets.left
            st.top == rewTitle.top
            st.height == Appearance.Text.Font.Label2.lineHeight
        }
        
        constrain(statusTagView, statusTitleLabel, containerView) { tag, title, view in
            tag.left == title.left
            tag.top == title.bottom + contentPaddings.bottom
            tag.height == BountyDetailsViewController.tagHeight
        }
        
        constrain(lifecycleActionButton, rewardTagView, containerView) { button, rew, view in
            button.left == view.left + contentInsets.left
            button.right == view.right - contentInsets.right
        }
        
        constrain(headerSeparatorView, lifecycleActionButton, containerView) { sep, button, view in
            sep.left == view.left + contentInsets.left
            sep.right == view.right - contentInsets.right
            sep.top == button.bottom + contentInsets.bottom * 2
            sep.height == BountyDetailsViewController.headerSeparatorHeight
        }
        
        constrain(descriptionTitleLabel, headerSeparatorView, containerView) { title, sep, view in
            title.left == view.left + contentInsets.left
            title.right == view.right - contentInsets.right
            title.top == sep.bottom + contentInsets.bottom * 2
            title.height == Appearance.Text.Font.Label2.lineHeight
        }
        
        constrain(descriptionLabel, descriptionTitleLabel, containerView) { desc, title, view in
            desc.left == view.left + contentInsets.left
            desc.right == view.right - contentInsets.right
            desc.top == title.bottom + contentPaddings.bottom
        }
        
        constrain(criteriaTitleLabel, descriptionLabel, containerView) { title, desc, view in
            title.left == view.left + contentInsets.left
            title.right == view.right - contentInsets.right
            title.top == desc.bottom + contentInsets.bottom * 2
            title.height == Appearance.Text.Font.Label2.lineHeight
        }
        
        constrain(criteriaLabel, criteriaTitleLabel, containerView) { crit, title, view in
            crit.left == view.left + contentInsets.left
            crit.right == view.right - contentInsets.right
            crit.top == title.bottom + contentPaddings.bottom
        }
        
        constrain(requestedByTitleLabel, criteriaLabel, containerView) { title, crit, view in
            title.left == view.left + contentInsets.left
            title.right == view.right - contentInsets.right
            title.top == crit.bottom + contentInsets.bottom * 2
            title.height == Appearance.Text.Font.Label2.lineHeight
        }
        
        constrain(requestedByTagView, requestedByTitleLabel, containerView) { tag, title, view in
            tag.left == view.left + contentInsets.left
            tag.right == view.right - contentInsets.right
            tag.top == title.bottom + contentPaddings.bottom
        }
        
        constrain(claimedByTitleLabel, requestedByTagView, containerView) { title, req, view in
            title.left == view.left + contentInsets.left
            title.right == view.right - contentInsets.right
            title.top == req.bottom + contentInsets.bottom * 2
            title.height == Appearance.Text.Font.Label2.lineHeight
        }
        
        constrain(claimedByTagView, claimedByTitleLabel, containerView) { tag, title, view in
            tag.left == view.left + contentInsets.left
            tag.right == view.right - contentInsets.right
            tag.top == title.bottom + contentPaddings.bottom
            tag.bottom == view.bottom - contentInsets.bottom * 2
        }
    }
    
    private func resetDynamicConstraints() {
        if lifecycleActionButton.isHidden {
            constrain(
                lifecycleActionButton, rewardTagView, replace: dynamicConstraints
            ) { button, tag in
                button.top == tag.bottom
                button.height == 0
            }
        } else {
            constrain(
                lifecycleActionButton, rewardTagView, replace: dynamicConstraints
            ) { button, tag in
                button.top == tag.bottom + contentInsets.bottom * 2
                button.height == BountyDetailsViewController.buttonHeight
            }
        }
    }
    
    func bindViewModel() {
        let output = viewModel.transform(input: input())
        
        output.title.drive(titleLabel.rx.text).disposed(by: disposer)
        output.reward.drive(rewardTagView.rx.text).disposed(by: disposer)
        output.status.map({ $0.title }).drive(statusTagView.rx.text).disposed(by: disposer)
        output.status.map({ $0.color }).drive(statusTagView.rx.textColor).disposed(by: disposer)
        output.lifecycleActionTitle.map({ $0 != nil })
            .drive(onNext: { [weak self] isActionable in
                self?.lifecycleActionButton.isHidden = !isActionable
                self?.resetDynamicConstraints()
            })
            .disposed(by: disposer)
        output.lifecycleActionTitle
            .drive(lifecycleActionButton.rx.title(for: .normal))
            .disposed(by: disposer)
        output.description.drive(descriptionLabel.rx.text).disposed(by: disposer)
        output.criteria.drive(criteriaLabel.rx.text).disposed(by: disposer)
        requestedByTagView.bind(viewModel: output.requestedByViewModel)
        output.claimedByViewModel.map({ $0 == nil })
            .drive(claimedByTitleLabel.rx.isHidden)
            .disposed(by: disposer)
        claimedByTagView
            .bind(viewModel: output.claimedByViewModel.filter({ $0 != nil }).map({ $0! }))
        output.claimedByViewModel.map({ $0 == nil })
            .drive(claimedByTagView.rx.isHidden)
            .disposed(by: disposer)
    }
    
    private func input() -> BountyDetailsViewModel.Input {
        return .init(
            lifecycleAction: lifecycleActionButton.rx.tap.asDriver(),
            tapRequestedBy: .empty(),
            tapClaimedBy: .empty()
        )
    }
}
