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
import Cartography
import RxSwift
import RxCocoa
import Kingfisher

class AcademyCourseDetailCard: CardView {
    // MARK: - Constants -
    
    private static let backgroundColor: UIColor = .backgroundGrey.withAlphaComponent(0.3)
    private static let separatorColor: UIColor = .primaryRed
    private static let separatorSize: CGSize = .init(width: 20.0, height: 4.0)
    
    // MARK: - Properties -
    
    private let disposer = DisposeBag()
    
    // MARK: - Subviews -
    
    private var titleLabel: UILabel!
    private var separatorView: UIView!
    private var bodyLabel: UILabel!
    
    // MARK: - Initialiers -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup -
    
    private func setUp() {
        clipsToBounds = true
        backgroundColor = AcademyCourseDetailCard.backgroundColor
        
        setUpSubviews()
        setUpConstraints()
    }
    
    func setUpSubviews() {
        titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .secondaryWhite
        titleLabel.font = Appearance.Text.Font.Label2.font(bold: true)
        addSubview(titleLabel)
        
        separatorView = UIView()
        separatorView.backgroundColor = AcademyCourseDetailCard.separatorColor
        addSubview(separatorView)
        
        bodyLabel = UILabel()
        bodyLabel.numberOfLines = 0
        bodyLabel.textColor = .secondaryWhite
        bodyLabel.font = Appearance.Text.Font.Body.font(bold: false)
        addSubview(bodyLabel)
    }
    
    func setUpConstraints() {
        constrain(titleLabel, self) { (title, view) in
            title.top == view.top + CardView.contentInsets.top
            title.left == view.left + CardView.contentInsets.left
            title.right == view.right - CardView.contentInsets.right
        }
        
        constrain(separatorView, titleLabel, self) { (sep, title, view) in
            sep.left == title.left
            sep.top == title.bottom
            sep.height == AcademyCourseDetailCard.separatorSize.height
            sep.width == AcademyCourseDetailCard.separatorSize.width
        }
        
        constrain(bodyLabel, separatorView, self) { (body, sep, view) in
            body.top == sep.bottom + CardView.contentPaddings.bottom
            body.left == view.left + CardView.contentInsets.left
            body.right == view.right - CardView.contentInsets.right
            body.bottom == view.bottom - CardView.contentInsets.bottom
        }
    }
    
    func bind(viewModel: AcademyCourseDetailViewModel) {
        let input = AcademyCourseDetailViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.title.drive(titleLabel.rx.text).disposed(by: disposer)
        output.body.drive(bodyLabel.rx.attributedText).disposed(by: disposer)
    }
}
