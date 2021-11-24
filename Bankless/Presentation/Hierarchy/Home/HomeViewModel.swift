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

class HomeViewModel: BaseViewModel, AuthServiceDependency, IdentityServiceDependency {
    // MARK: - Input/Output -
    
    struct Input { }
    
    struct Output {
        let timelineViewModel: Driver<HomeTimelineViewModel>
    }
    
    // MARK: - Actions -
    
    struct Actions {
        let openAchievements = PublishRelay<Void>()
        let openNews = PublishRelay<Void>()
        let openNewsletterItem = PublishRelay<NewsletterItem>()
        let openPodcastItem = PublishRelay<PodcastItem>()
        let openBountyBoard = PublishRelay<Void>()
        let openBounty = PublishRelay<Bounty>()
        let openAcademy = PublishRelay<Void>()
        let openAcademyCourse = PublishRelay<AcademyCourse>()
    }
    
    let actions = Actions()
    
    // MARK: - Components -
    
    var authService: AuthService!
    var identityService: IdentityService!
    
    // MARK: - Transformer -
    
    func transform(input: Input) -> Output {
        ensureDiscordAccess()
            .subscribe()
            .disposed(by: disposer)
        
        subscribeToInputEvents()
        
        let timelineViewModel = self.timelineViewModel()
        
        return Output(
            timelineViewModel: timelineViewModel.asDriver(onErrorDriveWith: .empty())
        )
    }
    
    // MARK: - Discord Data -
    
    private func ensureDiscordAccess() -> Completable {
        return authService.getDiscordAccess()
            .asObservable()
            .do(onCompleted: {
                NotificationCenter.default
                    .post(
                        name: NotificationEvent.discordAccessHasBeenGranted.notificationName,
                        object: nil
                    )
            })
            .asCompletable()
    }
    
    // MARK: - Timeline -
    
    private func timelineViewModel() -> Observable<HomeTimelineViewModel> {
        let viewModel = HomeTimelineViewModel()
        self.container?.resolve(viewModel)
        viewModel.expandNewsTransitionRequested
            .bind(to: actions.openNews).disposed(by: disposer)
        viewModel.newsletterItemTransitionRequested
            .bind(to: actions.openNewsletterItem).disposed(by: disposer)
        viewModel.podcastItemTransitionRequested
            .bind(to: actions.openPodcastItem).disposed(by: disposer)
        viewModel.expandBountiesTransitionRequested
            .bind(to: actions.openBountyBoard).disposed(by: disposer)
        viewModel.bountyTransitionRequested
            .bind(to: actions.openBounty).disposed(by: disposer)
        viewModel.expandAcademyTransitionRequested
            .bind(to: actions.openAcademy).disposed(by: disposer)
        viewModel.academyCourseTransitionRequested
            .bind(to: actions.openAcademyCourse).disposed(by: disposer)
        
        return .just(viewModel)
    }
    
    // MARK: - Subscriptions -
    
    private func subscribeToInputEvents() {
        NotificationCenter.default.rx
            .notification(NotificationEvent.achievementsPreviewTapped.notificationName, object: nil)
            .subscribe(onNext: { [weak self] _ in
                self?.actions.openAchievements.accept(())
            })
            .disposed(by: disposer)
    }
}
