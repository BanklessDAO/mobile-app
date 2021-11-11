//
//  Created with ♥ by BanklessDAO contributors on 2021-10-05.
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

class ApplicationCoordinator: NSObject {
    // MARK: - View hierarchy -
    
    private let window: UIWindow
    private var navigationController: BaseNavigationController!
    
    // MARK: - Coordination -
    
    private let homeCoordinator: HomeCoordinator
    
    // MARK: - Dependencies -
    
    private let container: DependencyContainer
    
    init(
        appDelegate: AppDelegate,
        window: UIWindow,
        container: DependencyContainer
    ) {
        self.window = window
        self.container = container
        homeCoordinator = HomeCoordinator(container: container)
        
        super.init()
        
        setUpNavigationController()
    }
    
    private func setUpNavigationController() {
        if navigationController == nil {
            navigationController = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(
                    withIdentifier: String(describing: BaseNavigationController.self)
                ) as? BaseNavigationController
        }
        
        navigationController.setViewControllers(
            [homeCoordinator.initialViewController],
            animated: false
        )
    }
    
    func start() {
        startMainFlow()
        window.makeKeyAndVisible()
    }
    
    private func startMainFlow() {
        window.rootViewController = navigationController
    }
}
