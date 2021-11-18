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

final class HomeCoordinator: Coordinator {
    private let container: DependencyContainer
    
    var initialViewController: UIViewController!
    
    init(
        container: DependencyContainer
    ) {
        self.container = container
        initialViewController = createHomeViewController()
    }
    
    // MARK: - Initialization -
    
    private func createHomeViewController() -> UIViewController {
        let viewModel = HomeViewModel(container: container)
        
        viewModel.actions.openNews
            .bind(onNext: { [weak self] in self?.openNews() })
            .disposed(by: viewModel.disposer)
        viewModel.actions.openNewsletterItem
            .bind(onNext: { [weak self] in self?.openNewsletterItem($0) })
            .disposed(by: viewModel.disposer)
        viewModel.actions.openPodcastItem
            .bind(onNext: { [weak self] in self?.openPodcastItem($0) })
            .disposed(by: viewModel.disposer)
        viewModel.actions.openAchievements
            .bind(onNext: { [weak self] in self?.openAchievements() })
            .disposed(by: viewModel.disposer)
        viewModel.actions.openBountyBoard
            .bind(onNext: { [weak self] in self?.openBountyBoard() })
            .disposed(by: viewModel.disposer)
        viewModel.actions.openBounty
            .bind(onNext: { [weak self] in self?.openBounty($0) })
            .disposed(by: viewModel.disposer)
        
        let viewController = HomeViewController.init(nibName: nil, bundle: nil)
        viewController.set(viewModel: viewModel)
        return viewController
    }
    
    // MARK: - Transitions -
    
    private func openNews() {
        let coordinator = NewsCoordinator(container: container)
        container.resolve(coordinator)
        
        coordinator.start(from: initialViewController.navigationController!)
    }
    
    private func openNewsletterItem(_ newsletterItem: NewsletterItem) {
        let coordinator = NewsletterDetailsCoordinator(container: self.container)
        self.container.resolve(coordinator)
        
        coordinator.start(
            with: newsletterItem,
            from: self.initialViewController.navigationController!
        )
    }
    
    private func openPodcastItem(_ podcastItem: PodcastItem) {
        let coordinator = PodcastDetailsCoordinator(container: self.container)
        self.container.resolve(coordinator)
        
        coordinator.start(
            with: podcastItem,
            from: self.initialViewController.navigationController!
        )
    }
    
    private func openAchievements() {
        let coordinator = AchievementsCoordinator(container: container)
        container.resolve(coordinator)
        
        initialViewController.navigationController?
            .pushViewController(coordinator.initialViewController, animated: true)
    }
    
    private func openBountyBoard() {
        let coordinator = BountyBoardCoordinator(container: container)
        container.resolve(coordinator)
        
        coordinator.start(from: initialViewController.navigationController!)
    }
    
    private func openBounty(_ bounty: Bounty) {
        let coordinator = BountyDetailsCoordinator(container: self.container)
        self.container.resolve(coordinator)
        
        coordinator.start(
            with: bounty,
            from: self.initialViewController.navigationController!
        )
    }
}
