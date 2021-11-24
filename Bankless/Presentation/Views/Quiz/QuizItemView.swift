//
//  Created with ♥ by BanklessDAO contributors on 2021-11-23.
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

class QuizItemView: BaseView<QuizItemViewModel> {
    // MARK: - Constants -
    
    private static let quizActionTitle = NSLocalizedString(
        "quiz.action.title",
        value: "Tap the correct answer",
        comment: ""
    )
    private static let optionPaddingSpace: CGFloat = 20.0
    
    // MARK: - Properties -
    
    private var validOptionIndex: Int!
    private let optionPickRelay = PublishRelay<Int>()
    
    // MARK: - Subviews -
    
    private var titleLabel: UILabel!
    private var optionsStackView: UIStackView!
    private var optionViews: [QuizItemOptionView]!
    
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
        clipsToBounds = true
        backgroundColor = .backgroundGrey.withAlphaComponent(0.5)
        layer.cornerRadius = Appearance.cornerRadius
        
        setUpSubviews()
        setUpConstraints()
    }
    
    private func setUpSubviews() {
        titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.text = QuizItemView.quizActionTitle
        titleLabel.textColor = .secondaryWhite
        titleLabel.font = Appearance.Text.Font.Label1.font(bold: true)
        addSubview(titleLabel)
        
        optionsStackView = UIStackView()
        optionsStackView.alignment = .fill
        optionsStackView.distribution = .fillProportionally
        optionsStackView.spacing = QuizItemView.optionPaddingSpace
        optionsStackView.axis = .vertical
        addSubview(optionsStackView)
    }
    
    private func setUpConstraints() {
        constrain(titleLabel, self) { title, view in
            title.top == view.top + contentInsets.top * 2
            title.left == view.left + contentInsets.left * 2
            title.right == view.right - contentInsets.right * 2
        }
        
        constrain(optionsStackView, titleLabel, self) { options, title, view in
            options.top == title.bottom + contentInsets.bottom * 2
            options.left == view.left + contentInsets.left * 2
            options.right == view.right - contentInsets.right * 2
            options.bottom == view.bottom - contentInsets.bottom * 2
        }
    }
    
    override func bindViewModel() {
        let output = viewModel.transform(
            input: .init(tapOption: optionPickRelay.asDriver(onErrorDriveWith: .empty()))
        )
        
        output.options
            .drive(onNext: { [weak self] options in
                self?.loadOptions(options)
            })
            .disposed(by: disposer)
        
        output.validOptionIndex
            .drive(onNext: { [weak self] in self?.validOptionIndex = $0 })
            .disposed(by: disposer)
        
        output.isPassed
            .map({ !$0 })
            .drive(optionsStackView.rx.isUserInteractionEnabled)
            .disposed(by: disposer)
        
        optionPickRelay.asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { [weak self] pickedOptionIndex in
                let validIndex = self?.validOptionIndex ?? -1
                let newState: QuizItemOptionView.State = pickedOptionIndex != validIndex
                ? .invalid
                : .valid
                
                self?.optionViews[pickedOptionIndex].set(state: newState, animated: true)
            })
            .disposed(by: disposer)
    }
    
    // MARK: - Transitions -
    
    private func loadOptions(_ options: [String]) {
        var optionViews = self.optionViews ?? []
        
        for subview in optionViews {
            optionsStackView.removeArrangedSubview(subview)
        }
        
        for (i, option) in options.enumerated() {
            let optionView = QuizItemOptionView(title: option) { [weak self] in
                self?.optionPickRelay.accept(i)
            }
            
            optionViews.append(optionView)
            optionsStackView.addArrangedSubview(optionView)
        }
        
        self.optionViews = optionViews
    }
}
