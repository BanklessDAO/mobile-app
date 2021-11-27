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

final class AchievementCollectionViewModel: BaseViewModel, AchievementsServiceDependency {
    // MARK: - Input / Output -
    
    struct Input {
        let refresh: Driver<Void>
        let selection: Driver<IndexPath>
    }
    
    struct Output {
        let isRefreshing: Driver<Bool>
        let title: Driver<String>
        let attendanceTokensSectionTitle: Driver<String>
        let attendanceTokenViewModels: Driver<[AttendanceTokenViewModel]>
    }
    
    // MARK: - Constants -
    
    private static let collectionTitle = NSLocalizedString(
        "home.collection.title", value: "Achievements", comment: ""
    )
    
    static let attendanceTokensSectionTitle = NSLocalizedString(
        "home.collection.section.attendance_tokens.title", value: "POAP Tokens", comment: ""
    )
    
    // MARK: - Properties -
    
    private let activityTracker = ActivityTracker()
    private let autorefresh = PublishRelay<Void>()
    
    // MARK: - Components -
    
    var achievementsService: AchievementsService!
    
    // MARK: - Transformer -
    
    func transform(input: Input) -> Output {
        let refreshTrigger = Driver
            .merge([input.refresh, autorefresh.asDriver(onErrorDriveWith: .empty())])
            .startWith(())
        
        let collectionItems = self.collectionItems(refreshInput: refreshTrigger).share()
        
        let attendanceTokens = collectionItems.map({ $0.attendanceTokens }).share()
        
        let attendanceTokenViewModels = attendanceTokens
            .map({ attendanceTokens in
                return attendanceTokens
                    .map({ return AttendanceTokenViewModel(attendanceToken: $0) })
            })
        
       bindSelection(input: input.selection)
        
        return Output(
            isRefreshing: activityTracker.asDriver(),
            title: .just(AchievementCollectionViewModel.collectionTitle),
            attendanceTokensSectionTitle: .just(
                AchievementCollectionViewModel.attendanceTokensSectionTitle
            ),
            attendanceTokenViewModels: attendanceTokenViewModels
                .asDriver(onErrorDriveWith: .empty())
        )
    }
    
    // MARK: - Timeline -
    
    private func collectionItems(
        refreshInput: Driver<Void>
    ) -> Observable<AchievementsResponse> {
        return refreshInput
            .asObservable()
            .flatMapLatest({ [weak self] _ -> Observable<AchievementsResponse> in
                guard let self = self else { return .empty() }
                
                return self.achievementsService.getAchiements()
                    .trackActivity(self.activityTracker)
            })
    }
    
    // MARK: - Selection -
    
    private func bindSelection(
        input: Driver<IndexPath>
    ) {
        // TODO: Implement transitions
    }
}
