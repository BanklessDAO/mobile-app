//
//  Created with ♥ by BanklessDAO contributors on 2021-11-18.
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

final class AcademyCourseDetailsCoordinator: Coordinator {
    private let container: DependencyContainer
    
    weak var initialViewController: AcademyCourseDetailsViewController!
    
    init(
        container: DependencyContainer
    ) {
        self.container = container
    }
    
    func start(
        with academyCourse: AcademyCourse,
        from navigationController: UINavigationController
    ) {
        let viewController = createAcademyCourseDetailsViewController(academyCourse: academyCourse)
        
        UIView.performWithoutAnimation {
            navigationController.pushViewController(viewController, animated: true)
        }
        
        initialViewController = viewController
        subscibeToEvents(in: initialViewController.viewModel)
    }
    
    private func createAcademyCourseDetailsViewController(
        academyCourse: AcademyCourse
    ) -> AcademyCourseDetailsViewController {
        let viewModel = AcademyCourseDetailsViewModel(
            academyCourse: academyCourse,
            container: container
        )
        
        let viewController = AcademyCourseDetailsViewController(nibName: nil, bundle: nil)
        viewController.set(viewModel: viewModel)
        viewController.coordinator = self
        
        return viewController
    }
    
    private func subscibeToEvents(in viewModel: AcademyCourseDetailsViewModel) {
        viewModel.events.academyCourseStartFlowRequest.asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { [weak self] academyCourse in
                guard let self = self else { return }
                
                let coordinator = AcademyCourseFlowCoordinator(container: self.container)
                self.container.resolve(coordinator)
                
                coordinator.start(
                    with: academyCourse,
                    from: self.initialViewController.navigationController!
                )
            })
            .disposed(by: initialViewController.disposer)
    }
}
