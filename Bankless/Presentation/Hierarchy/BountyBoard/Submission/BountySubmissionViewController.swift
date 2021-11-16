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

class BountySubmissionViewController: BaseViewController<BountySubmissionViewModel> {
    // MARK: - Constants -

    private static let textFieldHeight: CGFloat = 50.0
    private static let textViewHeight: CGFloat = 140.0
    private static let buttonHeight: CGFloat = 50.0
    private static let headerSeparatorHeight: CGFloat = 1

    private static let navLabelText0 = NSLocalizedString(
        "bounty.details.navigation.title",
        value: "Bounty",
        comment: ""
    )
    private static let navLabelText1 = NSLocalizedString(
        "bounty.submission.navigation.title",
        value: "Submit",
        comment: ""
    )
    private static let fields = (
        link: (
            title: NSLocalizedString(
                "bounty.submission.link.title",
                value: "Link to the result",
                comment: ""
            ),
            placeholder: NSLocalizedString(
                "bounty.submission.link.placeholder",
                value: "Enter or paste the URL",
                comment: ""
            )
        ),
        notes: (
            title: NSLocalizedString(
                "bounty.submission.notes.title",
                value: "Notes",
                comment: ""
            ),
            placeholder: NSLocalizedString(
                "bounty.submission.notes.placeholder",
                value: "Any notes supporting your work?",
                comment: ""
            )
        ),
        message: (
            title: NSLocalizedString(
                "bounty.submission.message.title",
                value: "Discord message",
                comment: ""
            ),
            placeholder: NSLocalizedString(
                "bounty.submission.message.placeholder",
                value: "Want to notify the bounty owner directly?",
                comment: ""
            )
        ),
        submit: (
            title: NSLocalizedString(
                "bounty.submission.action.submit.title",
                value: "Submit",
                comment: ""
            ),
            placeholder: nil as String?
        )
    )

    // MARK: - Subviews -
    
    private var scrollView: UIScrollView!
    private var containerView: UIView!

    private var navigationLabel: UILabel!
    private var titleLabel: UILabel!
    private var headerSeparatorView: UIView!
    private var linkTitleLabel: UILabel!
    private var linkTextField: TextField!
    private var notesTitleLabel: UILabel!
    private var notesTextView: TextView!
    private var messageTitleLabel: UILabel!
    private var messageTextView: TextView!
    private var submitButton: UIButton!

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
        
        let navLabelAttributedString0 = NSMutableAttributedString(
            string: BountySubmissionViewController.navLabelText0,
            attributes: .init(
                [
                    .font: Appearance.Text.Font.Note.font(bold: false),
                    .foregroundColor: UIColor.primaryRed
                ]
            )
        )
        let navLabelAttributedString1 = NSAttributedString(
            string: " " + BountySubmissionViewController.navLabelText1,
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
        containerView.addSubview(navigationLabel)

        titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .secondaryWhite
        titleLabel.font = Appearance.Text.Font.Title2.font(bold: true)
        containerView.addSubview(titleLabel)
        
        headerSeparatorView = UIView()
        headerSeparatorView.backgroundColor = .backgroundGrey
        containerView.addSubview(headerSeparatorView)

        linkTitleLabel = UILabel()
        linkTitleLabel.text = BountySubmissionViewController.fields.link.title
        linkTitleLabel.textColor = .backgroundGrey
        linkTitleLabel.font = Appearance.Text.Font.Label2.font(bold: true)
        containerView.addSubview(linkTitleLabel)
        
        linkTextField = TextField()
        linkTextField.keyboardType = .URL
        linkTextField.autocorrectionType = .no
        linkTextField.autocapitalizationType = .none
        linkTextField.placeholder = BountySubmissionViewController.fields.link.placeholder
        containerView.addSubview(linkTextField)
        
        notesTitleLabel = UILabel()
        notesTitleLabel.text = BountySubmissionViewController.fields.notes.title
        notesTitleLabel.textColor = .backgroundGrey
        notesTitleLabel.font = Appearance.Text.Font.Label2.font(bold: true)
        containerView.addSubview(notesTitleLabel)
        
        notesTextView = TextView()
        containerView.addSubview(notesTextView)
        
        messageTitleLabel = UILabel()
        messageTitleLabel.text = BountySubmissionViewController.fields.message.title
        messageTitleLabel.textColor = .backgroundGrey
        messageTitleLabel.font = Appearance.Text.Font.Label2.font(bold: true)
        containerView.addSubview(messageTitleLabel)
        
        messageTextView = TextView()
        containerView.addSubview(messageTextView)

        submitButton = UIButton(type: .custom)
        submitButton.titleLabel?.font = Appearance.Text.Font.Label2.font(bold: true)
        submitButton.setTitle(
            BountySubmissionViewController.fields.submit.title.uppercased(),
            for: .normal
        )
        submitButton.backgroundColor = .primaryRed.withAlphaComponent(0.75)
        submitButton.layer.cornerRadius = Appearance.cornerRadius
        containerView.addSubview(submitButton)
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
            container.width == view.width
            container.height == view.height ~ .defaultLow
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
        
        constrain(headerSeparatorView, titleLabel, containerView) { sep, title, view in
            sep.left == view.left + contentInsets.left
            sep.right == view.right - contentInsets.right
            sep.top == title.bottom + contentInsets.bottom * 2
            sep.height == BountySubmissionViewController.headerSeparatorHeight
        }

        constrain(linkTitleLabel, headerSeparatorView, containerView) { title, sep, view in
            title.left == view.left + contentInsets.left
            title.right == view.right - contentInsets.right
            title.top == sep.bottom + contentInsets.bottom * 2
            title.height == Appearance.Text.Font.Label2.lineHeight
        }
        
        constrain(linkTextField, linkTitleLabel, containerView) { txt, title, view in
            txt.left == view.left + contentInsets.left
            txt.right == view.right - contentInsets.right
            txt.top == title.bottom + contentPaddings.bottom
            txt.height == BountySubmissionViewController.textFieldHeight
        }

        constrain(notesTitleLabel, linkTextField, containerView) { title, txt, view in
            title.left == view.left + contentInsets.left
            title.right == view.right - contentInsets.right
            title.top == txt.bottom + contentInsets.bottom
            title.height == Appearance.Text.Font.Label2.lineHeight
        }
        
        constrain(notesTextView, notesTitleLabel, containerView) { txt, title, view in
            txt.left == view.left + contentInsets.left
            txt.right == view.right - contentInsets.right
            txt.top == title.bottom + contentPaddings.bottom
            txt.height == BountySubmissionViewController.textViewHeight
        }
        
        constrain(messageTitleLabel, notesTextView, containerView) { title, txt, view in
            title.left == view.left + contentInsets.left
            title.right == view.right - contentInsets.right
            title.top == txt.bottom + contentInsets.bottom
            title.height == Appearance.Text.Font.Label2.lineHeight
        }
        
        constrain(messageTextView, messageTitleLabel, containerView) { txt, title, view in
            txt.left == view.left + contentInsets.left
            txt.right == view.right - contentInsets.right
            txt.top == title.bottom + contentPaddings.bottom
            txt.height == BountySubmissionViewController.textViewHeight
        }
        
        constrain(submitButton, messageTextView, containerView) { button, txt, view in
            button.left == view.left + contentInsets.left
            button.right == view.right - contentInsets.right
            button.top == txt.bottom + contentInsets.bottom * 2
            button.height == BountySubmissionViewController.buttonHeight
            button.bottom == view.bottom - contentInsets.bottom * 2
        }
    }

    func bindViewModel() {
        let output = viewModel.transform(input: input())

        output.title.drive(titleLabel.rx.text).disposed(by: disposer)
        output.validationErrors.map({ $0.isEmpty })
            .drive(onNext: { [weak self] isInputValid in
                self?.submitButton.isEnabled = isInputValid
                self?.submitButton.alpha = isInputValid ? 1.0 : 0.5
            }).disposed(by: disposer)
    }

    private func input() -> BountySubmissionViewModel.Input {
        return .init(
            resultURL: linkTextField.rx.text.orEmpty.asDriver(),
            notes: notesTextView.rx.text.orEmpty.asDriver(),
            message: messageTextView.rx.text.orEmpty.asDriver(),
            submit: submitButton.rx.tap.asDriver()
        )
    }
}
