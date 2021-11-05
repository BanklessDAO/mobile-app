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
import Cartography
import RxSwift
import RxCocoa

typealias BaseCollectionViewCell<VM: ViewModel> = CollectionViewCellFoundation<VM> & ReusableCell

class CollectionViewCellFoundation<VM: ViewModel>: UICollectionViewCell {
    // MARK: - Constants -
    
    let contentInsets = Appearance.contentInsets
    let contentPaddings = Appearance.contentPaddings
    
    var insetsHeight: CGFloat {
        return contentInsets.top + contentInsets.bottom
    }
    
    // MARK: - Properties -
    
    var viewModel: VM!
    var disposer = DisposeBag()
    
    // MARK: - Initializers -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle -
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposer = DisposeBag()
    }
    
    // MARK: - Setters -
    
    func set(viewModel: VM) {
        self.viewModel = viewModel
        bindViewModel()
    }
    
    // MARK: - Setup -
    
    func setUp() {
        setUpSubviews()
        setUpConstraints()
    }
    
    func setUpSubviews() {
        fatalError("must be implemented in a subclass")
    }
    
    func setUpConstraints() {
        fatalError("must be implemented in a subclass")
    }
    
    // MARK: - Bindings -
    
    func bindViewModel() {
        fatalError("must be implemented in subclasses")
    }
}
