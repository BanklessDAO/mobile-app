//
//  Created with ♥ by BanklessDAO contributors on 2021-11-16.
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

class FeaturedNewsItemView: BaseView<NewsItemViewModel> {
    // MARK: - Constants -
    
    private static let absoluteItemWidth: CGFloat = UIScreen.main.bounds.width * 0.75
    private static let previewImageRatio: CGSize = .init(width: 16, height: 9)
    
    // MARK: - Subviews -
    
    private var previewImageView: UIImageView!
    private var categoryTitleLabel: UILabel!
    private var titleLabel: UILabel!
    
    // MARK: - Initializers -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup -
    
    private func setUp() {
        setUpSubviews()
        setUpConstraints()
    }
    
    private func setUpSubviews() {
        previewImageView = UIImageView()
        previewImageView.clipsToBounds = true
        previewImageView.layer.cornerRadius = Appearance.cornerRadius
        previewImageView.contentMode = .scaleAspectFill
        addSubview(previewImageView)
        
        categoryTitleLabel = UILabel()
        categoryTitleLabel.numberOfLines = 1
        categoryTitleLabel.textColor = .primaryRed
        categoryTitleLabel.font = Appearance.Text.Font.Note.font(bold: false)
        addSubview(categoryTitleLabel)
        
        titleLabel = UILabel()
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.textColor = .secondaryWhite
        titleLabel.font = Appearance.Text.Font.Label1.font(bold: true)
        addSubview(titleLabel)
    }
    
    private func setUpConstraints() {
        constrain(self) { view in
            view.width == FeaturedNewsItemView.absoluteItemWidth
        }
        
        constrain(previewImageView, self) { image, view in
            image.left == view.left + contentInsets.left
            image.right == view.right - contentInsets.right
            image.top == view.top + contentInsets.top
            image.height == image.width
                / FeaturedNewsItemView.previewImageRatio.width
                * FeaturedNewsItemView.previewImageRatio.height
        }
        
        constrain(categoryTitleLabel, previewImageView, self) { category, image, view in
            category.left == image.left
            category.right == image.right
            category.top == image.bottom + contentPaddings.bottom
            category.height == Appearance.Text.Font.Note.lineHeight
        }
        
        constrain(titleLabel, categoryTitleLabel, self) { title, category, view in
            title.left == category.left
            title.right == category.right
            title.top == category.bottom + contentPaddings.bottom
            title.height <= Appearance.Text.Font.Label1.lineHeight * 3
            title.bottom == view.bottom - contentInsets.bottom
        }
    }
    
    override func bindViewModel() {
        let output = viewModel.transform(input: input())
        
        output.previewImageURL
            .drive(onNext: { [weak self] url in
                self?.previewImageView.kf.setImage(with: url)
            })
            .disposed(by: disposer)
        
        output.categoryTitle.drive(categoryTitleLabel.rx.text).disposed(by: disposer)
        output.title.drive(titleLabel.rx.text).disposed(by: disposer)
    }
    
    private func input() -> NewsItemViewModel.Input {
        return .init()
    }
}
