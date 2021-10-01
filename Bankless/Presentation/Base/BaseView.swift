//
//  Created with ♥ by BanklessDAO contributors on 2021-09-30.
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

class BaseView<VM: ViewModel>: UIView {
    // MARK: - Constants -
    
    let contentInsets = Appearance.contentInsets
    let contentPaddings = Appearance.contentPaddings
    
    var insetsWidth: CGFloat {
        return contentInsets.left + contentInsets.right
    }
    
    var insetsHeight: CGFloat {
        return contentInsets.top + contentInsets.bottom
    }
    
    // MARK: - Properties -
    
    private var viewModelIsConnected = PublishRelay<Void>()
    
    var viewModel: VM!
    var disposer = DisposeBag()
    
    // MARK: - Initializers -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Binders -
    
    func bind(viewModel: Driver<VM>) {
        viewModel
            .drive(onNext: { [weak self] viewModel in
                self?.set(viewModel: viewModel)
            })
            .disposed(by: disposer)
    }
    
    // MARK: - Setters -
    
    func set(viewModel: VM) {
        self.viewModel = viewModel
        bindViewModel()
        
        viewModelIsConnected.accept(())
    }
    
    func bindViewModel() {
        fatalError("must be implemented in subclasses")
    }
    
    // MARK: - Input -
    
    func viewModelConnection() -> Driver<Void> {
        return viewModelIsConnected.asDriver(onErrorDriveWith: .empty())
    }
}
