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
                                   UserSettingsServiceDependency,
                                   BanklessServiceDependency,
                                   AchievementsServiceDependency,
                                   TimelineServiceDependency
{
    // MARK: - Input / Output -
    
    struct Input {
        let refresh: Driver<Void>
        let selection: Driver<ViewModelFoundation>
    }
    
    struct Output {
        let isRefreshing: Driver<Bool>
        let isAnonymous: Driver<Bool>
        let gaugeClusterViewModel: Driver<GaugeClusterViewModel>
        let featuredNewsSectionHeaderViewModel: Driver<SectionHeaderViewModel>
        let featuredNewsViewModel: Driver<FeaturedNewsViewModel>
        let bountiesSectionHeaderViewModel: Driver<SectionHeaderViewModel>
        let bountyViewModels: Driver<[BountyViewModel]>
        let academyCoursesSectionHeaderViewModel: Driver<SectionHeaderViewModel>
        let academyCourseViewModels: Driver<[AcademyCourseViewModel]>
    }
    
    // MARK: - Constants -
    
    static let expandSectionButtonTitle = NSLocalizedString(
        "home.timeline.section.controls.expand.title", value: "See All", comment: ""
    )
    
    static let featuredNewsSectionTitle = NSLocalizedString(
        "home.timeline.section.news.title", value: "Latest", comment: ""
    )
    
    static let bountiesSectionTitle = NSLocalizedString(
        "home.timeline.section.bounties.title", value: "Bounties", comment: ""
    )
    
    static let academySectionTitle = NSLocalizedString(
        "home.timeline.section.academy.title", value: "Academy", comment: ""
    )
    
    static let maxNewsItemPreviewCount = 3
    
    // MARK: - Properties -
    
    private let activityTracker = ActivityTracker()
    private let autorefresh = PublishRelay<Void>()
    
    // MARK: - Events -
    
    let expandNewsTransitionRequested = PublishRelay<Void>()
    let newsletterItemTransitionRequested = PublishRelay<NewsletterItem>()
    let podcastItemTransitionRequested = PublishRelay<PodcastItem>()
    let expandBountiesTransitionRequested = PublishRelay<Void>()
    let bountyTransitionRequested = PublishRelay<Bounty>()
    let expandAcademyTransitionRequested = PublishRelay<Void>()
    let academyCourseTransitionRequested = PublishRelay<AcademyCourse>()
    
    // MARK: - Components -
    
    var userSettingsService: UserSettingsService!
    var banklessService: BanklessService!
    var achievementsService: AchievementsService!
    var timelineService: TimelineService!
    
    // MARK: - Transformer -
    
    func transform(input: Input) -> Output {
        let refreshTrigger = Driver
            .merge([input.refresh, autorefresh.asDriver(onErrorDriveWith: .empty())])
            .startWith(())
        
        let ethAddress = userSettingsService
            .streamValue(for: .publicETHAddress)
            .map({ $0 as? String })
            .share(replay: 1)
        
        let timelineItems = self.timelineItems(refreshInput: refreshTrigger).share()
        
        let bounties = timelineItems.map({ $0.bounties }).share()
        
        let bountiesHeaderVM = SectionHeaderViewModel()
        bountiesHeaderVM.set(title: HomeTimelineViewModel.bountiesSectionTitle)
        bountiesHeaderVM.setExpandButton(
            title: HomeTimelineViewModel.expandSectionButtonTitle
        ) { [weak self] in
            self?.expandBountiesTransitionRequested.accept(())
        }
        let bountyViewModels = bounties
            .map({ bounties in
                return bounties.map({ return BountyViewModel(bounty: $0) })
            })
        
        let academyCourses = timelineItems
            .map({ $0.academyCourses })
            .share()
        
        let coursesHeaderVM = SectionHeaderViewModel()
        coursesHeaderVM.set(title: HomeTimelineViewModel.academySectionTitle)
        coursesHeaderVM.setExpandButton(
            title: HomeTimelineViewModel.expandSectionButtonTitle
        ) { [weak self] in
            self?.expandAcademyTransitionRequested.accept(())
        }
        let academyCourseViewModels = academyCourses
            .map({ academyCourses in
                return academyCourses
                    .map({ return AcademyCourseViewModel(academyCourse: $0) })
            })
        
        let featuredNewsHeaderVM = SectionHeaderViewModel()
        featuredNewsHeaderVM.set(title: HomeTimelineViewModel.featuredNewsSectionTitle)
        featuredNewsHeaderVM.setExpandButton(
            title: HomeTimelineViewModel.expandSectionButtonTitle
        ) { [weak self] in
            self?.expandNewsTransitionRequested.accept(())
        }
        let featuredNewsViewModel = timelineItems
            .map({ ($0.newsletterItems + $0.podcastItems) as [NewsItemPreviewBehaviour] })
            .map({ $0.sorted(by: { $0.date > $1.date }) })
            .map({ Array($0.prefix(HomeTimelineViewModel.maxNewsItemPreviewCount)) })
            .map({ items -> FeaturedNewsViewModel in
                let viewModel = FeaturedNewsViewModel(newsItems: items)
                viewModel.set(title: HomeTimelineViewModel.featuredNewsSectionTitle)
                viewModel.setExpandButton(
                    title: HomeTimelineViewModel.expandSectionButtonTitle
                )
                
                viewModel.selectionRelay.asDriver(onErrorDriveWith: .empty())
                    .drive(onNext: { [weak self] index in
                        guard let self = self else {
                            return
                        }
                        
                        switch items[index] {
                        
                        case let newsletterItem as NewsletterItem:
                            self.newsletterItemTransitionRequested.accept(newsletterItem)
                        case let podcastItem as PodcastItem:
                            self.podcastItemTransitionRequested.accept(podcastItem)
                        default:
                            fatalError("unexpected type")
                        }
                    })
                    .disposed(by: viewModel.disposer)
                
                viewModel.expandRelay
                    .bind(to: self.expandNewsTransitionRequested)
                    .disposed(by: self.disposer)
                
                return viewModel
            })
            .share()
        
        bindSelection(input: input.selection)
        
        return Output(
            isRefreshing: activityTracker.asDriver(),
            isAnonymous: ethAddress
                .map({ $0?.isValidEVMAddress ?? false })
                .asDriver(onErrorDriveWith: .empty()),
            gaugeClusterViewModel: gaugeClusterViewModel(
                refreshInput: refreshTrigger, ethAddress: ethAddress
            )
                .asDriver(onErrorDriveWith: .empty()),
            featuredNewsSectionHeaderViewModel: .just(featuredNewsHeaderVM),
            featuredNewsViewModel: featuredNewsViewModel.asDriver(onErrorDriveWith: .empty()),
            bountiesSectionHeaderViewModel: .just(bountiesHeaderVM),
            bountyViewModels: bountyViewModels.asDriver(onErrorDriveWith: .empty()),
            academyCoursesSectionHeaderViewModel: .just(coursesHeaderVM),
            academyCourseViewModels: academyCourseViewModels.asDriver(onErrorDriveWith: .empty())
        )
    }
    
    // MARK: - Gauge cluster -
    
    private func gaugeClusterViewModel(
        refreshInput: Driver<Void>,
        ethAddress: Observable<String?>
    ) -> Observable<GaugeClusterViewModel> {
        let inputTrigger = Observable
            .combineLatest(refreshInput.asObservable(), ethAddress) { $1 }
        
        return inputTrigger
            .flatMap({ [weak self] ethAddress -> Observable<GaugeClusterViewModel> in
                guard let self = self else { return .empty() }
                
                guard let ethAddress = ethAddress else {
                    return .just(GaugeClusterViewModel(bankAccount: nil, attendanceTokens: nil))
                }
                
                let bankAccount = self.daoOwnership(for: ethAddress)
                    .map({ $0.bankAccount })
                let attendanceTokens = self.achievements(for: ethAddress)
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
            })
    }
    
    private func daoOwnership(
        for ethAddress: String
    ) -> Observable<DAOOwnershipResponse> {
        return self.banklessService
            .getDAOOwnership(request: .init(ethAddress: ethAddress))
            .handleError()
            .trackActivity(self.activityTracker)
    }
    
    private func achievements(
        for ethAddress: String
    ) -> Observable<AchievementsResponse> {
        return self.achievementsService
            .getAchiements(request: .init(ethAddress: ethAddress))
            .handleError()
            .trackActivity(self.activityTracker)
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
                    .handleError()
                    .trackActivity(self.activityTracker)
            })
    }
    
    // MARK: - Selection -
    
    private func bindSelection(
        input: Driver<ViewModelFoundation>
    ) {
        input.asObservable()
            .subscribe(onNext: { [weak self] viewModel in
                switch viewModel {
                
                case let bountyViewModel as BountyViewModel:
                    self?.bountyTransitionRequested
                        .accept(bountyViewModel.bounty)
                case let academyCourseViewModel as AcademyCourseViewModel:
                    self?.academyCourseTransitionRequested
                        .accept(academyCourseViewModel.academyCourse)
                default:
                    break
                }
            })
            .disposed(by: disposer)
    }
}
