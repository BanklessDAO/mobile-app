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

class AcademyCourseQuizSectionView: BaseView<AcademyCourseQuizSectionViewModel>,
                                    AcademyCourseSectionView
{
    // MARK: - Constants -
    
    static let separatorColor: UIColor = .primaryRed
    static let separatorSize: CGSize = .init(width: 20.0, height: 4.0)
    
    // MARK: - Subviews -
    
    private var titleLabel: UILabel!
    private var separatorView: UIView!
    private var quizItemView: QuizItemView!
    
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
        titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .secondaryWhite
        titleLabel.font = Appearance.Text.Font.Title1.font(bold: true)
        addSubview(titleLabel)
        
        separatorView = UIView()
        separatorView.backgroundColor = AcademyCourseLearnSectionView.separatorColor
        addSubview(separatorView)
        
        quizItemView = QuizItemView()
        addSubview(quizItemView)
    }
    
    private func setUpConstraints() {
        constrain(titleLabel, self) { title, view in
            title.left == view.left
            title.right == view.right
            title.top == view.top
        }
        
        constrain(separatorView, titleLabel, self) { (sep, title, view) in
            sep.left == title.left
            sep.top == title.bottom + contentPaddings.bottom
            sep.height == AcademyCourseLearnSectionView.separatorSize.height
            sep.width == AcademyCourseLearnSectionView.separatorSize.width
        }
        
        constrain(quizItemView, separatorView, self) { quiz, sep, view in
            quiz.left == view.left
            quiz.right == view.right
            quiz.top == sep.bottom + contentInsets.bottom * 2
            quiz.bottom == view.bottom
        }
    }
    
    override func bindViewModel() {
        let output = viewModel.transform(input: .init())
        
        output.title.drive(titleLabel.rx.text).disposed(by: disposer)
        quizItemView.bind(viewModel: output.quizItemViewModel)
    }
}
