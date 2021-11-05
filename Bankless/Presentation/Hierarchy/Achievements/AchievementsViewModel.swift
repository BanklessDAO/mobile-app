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
import RxSwift
import RxCocoa

class AchievementsViewModel: BaseViewModel, AchievementsServiceDependency {
    // MARK: - Input/Output -
    
    struct Input { }
    
    struct Output {
        let collectionViewModel: Driver<AchievementCollectionViewModel>
    }
    
    // MARK: - Components -
    
    var achievementsService: AchievementsService!
    
    // MARK: - Transformer -
    
    func transform(input: Input) -> Output {
        let collectionViewModel = self.collectionViewModel()
        
        return Output(
            collectionViewModel: collectionViewModel.asDriver(onErrorDriveWith: .empty())
        )
    }
    
    // MARK: - Timeline -
    
    private func collectionViewModel() -> Observable<AchievementCollectionViewModel> {
        let viewModel = AchievementCollectionViewModel()
        self.container?.resolve(viewModel)
        
        return .just(viewModel)
    }
}
