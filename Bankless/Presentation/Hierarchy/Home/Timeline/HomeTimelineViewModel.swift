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
import RxSwift
import RxCocoa

final class HomeTimelineViewModel: BaseViewModel,
                                   BanklessServiceDependency,
                                   AchievementsServiceDependency,
                                   TimelineServiceDependency
{
    // MARK: - Input / Output -
    
    struct Input {
        let refresh: Driver<Void>
        let selection: Driver<IndexPath>
        let expandSection: Driver<Int>
    }
    
    struct Output {
        let gaugeClusterViewModel: Driver<GaugeClusterViewModel>
        let title: Driver<String>
        let bountiesSectionTitle: Driver<String>
        let bountyViewModels: Driver<[BountyViewModel]>
        let academyCoursesSectionTitle: Driver<String>
        let academyCourseViewModels: Driver<[AcademyCourseViewModel]>
        let expandSectionButtonTitle: Driver<String>
    }
    
    // MARK: - Constants -
    
    private static let timelineTitle = NSLocalizedString(
        "home.timeline.title", value: "Today", comment: ""
    )
    
    static let expandSectionButtonTitle = NSLocalizedString(
        "home.timeline.section.controls.expand.title", value: "See All", comment: ""
    )
    
   static let bountiesSectionTitle = NSLocalizedString(
        "home.timeline.section.bounties.title", value: "Bounties", comment: ""
    )
    
    static let academySectionTitle = NSLocalizedString(
        "home.timeline.section.academy.title", value: "Academy", comment: ""
    )
    
    // MARK: - Components -
    
    private var homeRouter: HomeRouter!
    var banklessService: BanklessService!
    var achievementsService: AchievementsService!
    var timelineService: TimelineService!
    
    // MARK: - Setters -
    
    override func set<Router>(router: Router) {
        if let homeRouter = router as? HomeRouter {
            self.homeRouter = homeRouter
        }
    }
    
    // MARK: - Transformer -
    
    func transform(input: Input) -> Output {
        let refreshTrigger = Driver<Void>.just(())
        
        let timelineItems = self.timelineItems(refreshInput: refreshTrigger).share()
        
        let bounties = timelineItems.map({ $0.bounties }).share()
        
        let bountyViewModels = bounties
            .map({ bounties in
                return bounties.map({ return BountyViewModel(bounty: $0) })
            })
        
        
        let academyCourses = timelineItems
            .map({ $0.academyCourses })
            .share()
        
        let academyCourseViewModels = academyCourses
            .map({ academyCourses in
                return academyCourses
                    .map({ return AcademyCourseViewModel(academyCourse: $0) })
            })
        
        bindSelection(input: input.selection)
        
        return Output(
            gaugeClusterViewModel: gaugeClusterViewModel(refreshInput: refreshTrigger)
                .asDriver(onErrorDriveWith: .empty()),
            title: .just(HomeTimelineViewModel.timelineTitle),
            bountiesSectionTitle: .just(HomeTimelineViewModel.bountiesSectionTitle),
            bountyViewModels: bountyViewModels.asDriver(onErrorDriveWith: .empty()),
            academyCoursesSectionTitle: .just(HomeTimelineViewModel.academySectionTitle),
            academyCourseViewModels: academyCourseViewModels.asDriver(onErrorDriveWith: .empty()),
            expandSectionButtonTitle: .just(HomeTimelineViewModel.expandSectionButtonTitle)
        )
    }
    
    // MARK: - Gauge cluster -
    
    private func gaugeClusterViewModel(
        refreshInput: Driver<Void>
    ) -> Observable<GaugeClusterViewModel> {
        let bankAccount = daoOwnership(refreshInput: refreshInput)
            .map({ $0.bankAccount })
        let attendanceTokens = achievements(refreshInput: refreshInput)
            .map({ $0.attendanceTokens })
        
        return .combineLatest(
            bankAccount,
            attendanceTokens
        ) { bankAccount, attendanceTokens in
            return GaugeClusterViewModel(
                bankAccount: bankAccount,
                attendanceTokens: attendanceTokens
            )
        }
    }
    
    private func daoOwnership(
        refreshInput: Driver<Void>
    ) -> Observable<DAOOwnershipResponse> {
        return refreshInput
            .asObservable()
            .flatMapLatest({ [weak self] _ -> Observable<DAOOwnershipResponse> in
                guard let self = self else { return .empty() }

                return self.banklessService.getDAOOwnership()
            })
    }
    
    private func achievements(
        refreshInput: Driver<Void>
    ) -> Observable<AchievementsResponse> {
        return refreshInput
            .asObservable()
            .flatMapLatest({ [weak self] _ -> Observable<AchievementsResponse> in
                guard let self = self else { return .empty() }
                
                return self.achievementsService.getAchiements()
            })
    }
    
    // MARK: - Timeline -
    
    private func timelineItems(
        refreshInput: Driver<Void>
    ) -> Observable<TimelineItemsResponse> {
        return refreshInput
            .asObservable()
            .flatMapLatest({ [weak self] _ -> Observable<TimelineItemsResponse> in
                guard let self = self else { return .empty() }
                
                return self.timelineService.getTimelineItems()
            })
    }
    
    // MARK: - Selection -
    
    private func bindSelection(
        input: Driver<IndexPath>
    ) {
        // TODO: Implement transitions
    }
}
