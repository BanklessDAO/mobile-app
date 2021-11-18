//
//  Created with ♥ by BanklessDAO contributors on 2021-11-17.
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

final class NewsCoordinator: Coordinator {
    private let container: DependencyContainer
    
    weak var initialViewController: NewsViewController!
    
    init(
        container: DependencyContainer
    ) {
        self.container = container
    }
    
    func start(from navigationController: UINavigationController) {
        let viewController = createNewsViewController()
        navigationController.pushViewController(viewController, animated: true)
        
        initialViewController = viewController
        subscibeToEvents(in: initialViewController.viewModel)
    }
    
    private func createNewsViewController() -> NewsViewController {
        let viewModel = NewsViewModel(container: container)
        
        let viewController = NewsViewController(nibName: nil, bundle: nil)
        viewController.set(viewModel: viewModel)
        viewController.coordinator = self
        
        return viewController
    }
    
    private func subscibeToEvents(in viewModel: NewsViewModel) {
        viewModel.events.newsletterItemTransitionRequest.asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { [weak self] newsletterItem in
                guard let self = self else { return }
                
                let coordinator = NewsletterDetailsCoordinator(container: self.container)
                self.container.resolve(coordinator)
                
                coordinator.start(
                    with: newsletterItem,
                    from: self.initialViewController.navigationController!
                )
            })
            .disposed(by: initialViewController.disposer)
        viewModel.events.podcastItemTransitionRequest.asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { [weak self] podcastItem in
                guard let self = self else { return }
                
                let coordinator = PodcastDetailsCoordinator(container: self.container)
                self.container.resolve(coordinator)
                
                coordinator.start(
                    with: podcastItem,
                    from: self.initialViewController.navigationController!
                )
            })
            .disposed(by: initialViewController.disposer)
    }
}
