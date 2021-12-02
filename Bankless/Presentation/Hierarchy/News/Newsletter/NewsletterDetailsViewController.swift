//
//  Created with ♥ by BanklessDAO contributors on 2021-11-17.
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

class NewsletterDetailsViewController: BaseViewController<NewsletterDetailsViewModel> {
    // MARK: - Constants -
    
    private static let navLabelText = NSLocalizedString(
        "news.newsletter.item.details.navigation.title",
        value: "BanklessDAO Newsletter",
        comment: ""
    )
    
    // MARK: - Subviews -
    
    private var scrollView: UIScrollView!
    private var containerView: UIView!
    
    private var navigationLabel: UILabel!
    private var titleLabel: UILabel!
    private var subtitleLabel: UILabel!
    private var markupView: MarkupView!
    
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
        containerView.addSubview(navigationLabel)
        
        titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .secondaryWhite
        titleLabel.font = Appearance.Text.Font.Title2.font(bold: true)
        containerView.addSubview(titleLabel)
        
        subtitleLabel = UILabel()
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textColor = .secondaryWhite.withAlphaComponent(0.5)
        subtitleLabel.font = Appearance.Text.Font.Label2.font(bold: false)
        containerView.addSubview(subtitleLabel)
        
        markupView = MarkupView()
        containerView.addSubview(markupView)
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
            title.top == nav.bottom + contentInsets.bottom * 2
        }
        
        constrain(subtitleLabel, titleLabel, containerView) { sub, title, view in
            sub.left == view.left + contentInsets.left
            sub.right == view.right - contentInsets.right
            sub.top == title.bottom + contentInsets.bottom * 2
        }
        
        constrain(markupView, subtitleLabel, containerView) { markup, sub, view in
            markup.left == view.left + contentInsets.left
            markup.right == view.right - contentInsets.right
            markup.top == sub.bottom + contentInsets.bottom * 2
            markup.bottom == view.bottom
        }
    }
    
    func bindViewModel() {
        let output = viewModel.transform(input: input())
        
        output.date
            .drive(onNext: { [weak self] dateString in
                let navLabelAttributedString0 = NSMutableAttributedString(
                    string: NewsletterDetailsViewController.navLabelText,
                    attributes: .init(
                        [
                            .font: Appearance.Text.Font.Note.font(bold: false),
                            .foregroundColor: UIColor.primaryRed
                        ]
                    )
                )
                let navLabelAttributedString1 = NSAttributedString(
                    string: " " + dateString,
                    attributes: .init(
                        [
                            .font: Appearance.Text.Font.Note.font(bold: false),
                            .foregroundColor: UIColor.backgroundGrey
                        ]
                    )
                )
                navLabelAttributedString0.append(navLabelAttributedString1)
                
                self?.navigationLabel.attributedText = navLabelAttributedString0
            })
            .disposed(by: disposer)
        output.title.drive(titleLabel.rx.text).disposed(by: disposer)
        output.subtitle.drive(subtitleLabel.rx.text).disposed(by: disposer)
        markupView.bind(viewModel: output.markupViewModel)
    }
    
    private func input() -> NewsletterDetailsViewModel.Input {
        return .init()
    }
}
