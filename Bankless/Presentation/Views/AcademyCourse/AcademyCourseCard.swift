//
//  Created with ♥ by BanklessDAO contributors on 2021-10-06.
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

class AcademyCourseCard: CardView {
    // MARK: - Constants -
    
    private static let backgroundColor: UIColor = .backgroundGrey.withAlphaComponent(0.3)
    private static let backgroundCurtainAlpha: CGFloat = 0.7
    private static let forwardNavigationIcon = UIImage(named: "arrow_right")!
    private static let sizeRatio: CGSize = .init(width: 16, height: 9)
    private static let tagHeight: CGFloat = 40.0
    private static let tagPadding: CGFloat = 20.0
    
    // MARK: - Properties -
    
    private let disposer = DisposeBag()
    
    // MARK: - Subviews -
    
    private var backgroundImageView: UIImageView!
    private var backgroundCurtainView: UIView!
    private var forwardNavIconView: UIImageView!
    private var titleLabel: UILabel!
    private var subtitleLabel: UILabel!
    private var difficultyTagView: TagView!
    private var durationTagView: TagView!
    
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
        backgroundColor = AcademyCourseCard.backgroundColor
        
        setUpSubviews()
        setUpConstraints()
    }
    
    func setUpSubviews() {
        backgroundImageView = UIImageView()
        backgroundImageView.contentMode = .scaleAspectFill
        addSubview(backgroundImageView)
        
        backgroundCurtainView = UIView()
        backgroundCurtainView.backgroundColor = .black
        backgroundCurtainView.alpha = AcademyCourseCard.backgroundCurtainAlpha
        addSubview(backgroundCurtainView)
        
        forwardNavIconView = UIImageView(image: AcademyCourseCard.forwardNavigationIcon)
        forwardNavIconView.contentMode = .scaleAspectFit
        addSubview(forwardNavIconView)
        
        titleLabel = UILabel()
        titleLabel.textColor = .secondaryWhite
        titleLabel.font = Appearance.Text.Font.Label2.font(bold: true)
        addSubview(titleLabel)
        
        subtitleLabel = UILabel()
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textColor = .secondaryWhite
        subtitleLabel.font = Appearance.Text.Font.Label2.font(bold: false)
        addSubview(subtitleLabel)
        
        difficultyTagView = TagView()
        difficultyTagView.font = Appearance.Text.Font.Label2.font(bold: true)
        difficultyTagView.cornerRadius = Appearance.cornerRadius
        difficultyTagView.backgroundColor = .backgroundGrey
        difficultyTagView.horizontalPadding = AcademyCourseCard.tagPadding
        addSubview(difficultyTagView)
        
        durationTagView = TagView()
        durationTagView.font = Appearance.Text.Font.Label2.font(bold: true)
        durationTagView.cornerRadius = Appearance.cornerRadius
        durationTagView.backgroundColor = .backgroundGrey
        difficultyTagView.horizontalPadding = AcademyCourseCard.tagPadding
        addSubview(durationTagView)
    }
    
    func setUpConstraints() {
        constrain(self) { view in
            view.height == view.width
                / AcademyCourseCard.sizeRatio.width
                * AcademyCourseCard.sizeRatio.height
        }
        
        constrain(backgroundImageView, self) { bg, view in
            bg.edges == view.edges
        }
        
        constrain(backgroundCurtainView, self) { curtain, view in
            curtain.edges == view.edges
        }
        
        constrain(forwardNavIconView, self) { (icon, view) in
            icon.top == view.top + CardView.contentInsets.top
            icon.right == view.right - CardView.contentInsets.right
            icon.height == Appearance.Text.Font.Label2.lineHeight
            icon.width == icon.height
        }
        
        constrain(titleLabel, subtitleLabel, self) { (title, subtitle, view) in
            title.top >= view.top + CardView.contentInsets.top
            title.left == subtitle.left
            title.right == subtitle.right
            title.bottom == subtitle.top - CardView.contentPaddings.bottom
        }
        
        constrain(subtitleLabel, difficultyTagView, self) { (subtitle, difficulty, view) in
            subtitle.left == view.left + CardView.contentInsets.left
            subtitle.right == difficulty.left - CardView.contentPaddings.left
            subtitle.bottom == view.bottom - CardView.contentInsets.bottom
        }
        
        constrain(difficultyTagView, durationTagView, self) { (difficulty, duration, view) in
            difficulty.bottom == duration.top - CardView.contentPaddings.bottom
            difficulty.right == view.right - CardView.contentInsets.right
            difficulty.height == AcademyCourseCard.tagHeight
        }
        
        constrain(durationTagView, self) { (duration, view) in
            duration.bottom == view.bottom - CardView.contentInsets.bottom
            duration.right == view.right - CardView.contentInsets.right
            duration.height == AcademyCourseCard.tagHeight
        }
    }
    
    func bind(viewModel: AcademyCourseViewModel) {
        let input = AcademyCourseViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.backgroundImageURL
            .drive(onNext: { [weak self] url in
                self?.backgroundImageView.kf.setImage(with: url)
            })
            .disposed(by: disposer)
        output.title.drive(titleLabel.rx.text).disposed(by: disposer)
        output.description.drive(subtitleLabel.rx.text).disposed(by: disposer)
        output.difficulty.drive(difficultyTagView.rx.text).disposed(by: disposer)
        output.duration.drive(durationTagView.rx.text).disposed(by: disposer)
    }
}
