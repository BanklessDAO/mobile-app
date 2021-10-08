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

final class HomeCoordinator {
    private let container: DependencyContainer
    
    var initialViewController: UIViewController!
    
    init(
        container: DependencyContainer
    ) {
        self.container = container
        initialViewController = createHomeViewController()
    }
    
    private func createHomeViewController() -> UIViewController {
        let viewModel = HomeViewModel(container: container)
        viewModel.set(router: HomeRouter())
        
        let viewController = HomeViewController.init(nibName: nil, bundle: nil)
        viewController.set(viewModel: viewModel)
        return viewController
    }
}
