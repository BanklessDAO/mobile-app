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
import RxSwift
import RxCocoa

class ApplicationCoordinator: NSObject {
    // MARK: - Properties -
    
    private let disposer = DisposeBag()
    
    // MARK: - App services -
    
    let errorReporter: ErrorReporter
    
    // MARK: - View hierarchy -
    
    private let window: UIWindow
    private(set) var navigationController: BaseNavigationController!
    
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
        
        errorReporter = SentryErrorReporter()
        errorReporter.start()
        
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
        
        let navigationBar = NavigationBar()
        
        navigationController?.navigationBar
            .set(customNavigationView: navigationBar)
        
        navigationController.controllerStack.asObservable()
            .subscribe(onNext: { [weak self] viewControllers in
                var views: [UIView] = []
                
                if viewControllers.count > 1 {
                    let backButtonItem = IconButtonNavigationBarItem(
                        icon: NavigationBarIcon.back.image
                    )
                    backButtonItem.rxTap
                        .drive(onNext: { [weak self] in
                            _ = self?.navigationController.popViewController(animated: true)
                        })
                        .disposed(by: backButtonItem.disposer)
                    views.append(backButtonItem)
                }
                
                let identityViewModel = IdentityStripeViewModel(mode: .currentUser)
                self?.container.resolve(identityViewModel)
                
                let identityItem = IdentityStripeView(layoutDirection: .rightHand)
                identityItem.set(viewModel: identityViewModel)
                identityItem.setContentHuggingPriority(.defaultLow, for: .horizontal)
                views.append(identityItem)
                
                navigationBar.set(views: views)
            })
            .disposed(by: disposer)
    }
    
    func start() {
        startMainFlow()
        window.makeKeyAndVisible()
    }
    
    private func startMainFlow() {
        window.rootViewController = navigationController
    }
}
