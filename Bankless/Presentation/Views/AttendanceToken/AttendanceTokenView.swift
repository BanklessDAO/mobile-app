//
//  Created with ♥ by BanklessDAO contributors on 2021-10-17.
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

class AttendanceTokenView: BaseView<AttendanceTokenViewModel> {
    // MARK: - Subviews -
    
    private var imageView: UIImageView!
    
    // MARK: - Initializers -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle -
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = imageView.bounds.width / 2
    }
    
    // MARK: - Setup -
    
    private func setUp() {
        setUpSubviews()
        setUpConstraints()
    }
    
    func setUpSubviews() {
        imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
    }
    
    func setUpConstraints() {
        constrain(imageView, self) { image, view in
            image.center == view.center
            image.width == image.height
            image.height == view.height - contentInsets.top - contentInsets.bottom
        }
    }
    
    override func bindViewModel() {
        let output = viewModel.transform(input: input())
        
        output.imageURL
            .drive(onNext: { [weak self] url in
                self?.imageView.kf.setImage(with: url)
            })
            .disposed(by: disposer)
    }
    
    private func input() -> AttendanceTokenViewModel.Input {
        return .init()
    }
}
