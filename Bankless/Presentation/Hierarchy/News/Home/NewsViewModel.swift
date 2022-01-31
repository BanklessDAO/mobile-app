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
import RxSwift
import RxCocoa

class NewsViewModel: BaseViewModel, NewsServiceDependency {
    // MARK: - Input/Output -
    
    struct Input {
        let refresh: Driver<Void>
        let endOfList: Driver<Int>
        let selection: Driver<ViewModelFoundation>
    }
    
    struct Output {
        let isRefreshing: Driver<Bool>
        let title: Driver<String>
        let newsItemViewModels: Driver<[NewsItemViewModel]>
    }
    
    // MARK: - Events -
    
    struct Events {
        let newsletterItemTransitionRequest = PublishRelay<NewsletterItem>()
        let podcastItemTransitionRequest = PublishRelay<PodcastItem>()
    }
    
    let events = Events()
    
    // MARK: - Constants -
    
    private static let title = NSLocalizedString(
        "news.list.title", value: "Updates", comment: ""
    )
    
    // MARK: - Properties -
    
    private let activityTracker = ActivityTracker()
    private let autorefresh = PublishRelay<Void>()
    private let newsItemsRelay = BehaviorRelay<[NewsItemPreviewBehaviour]>(value: [])
    
    // MARK: - Pagination -
    
    private struct NextItemPage {
        let doesNewsletterPageExist: Bool
        let newsletterToken: String?
        let doesPodcastPageExist: Bool
        let podcastToken: String?
        
        init(
            doesNewsletterPageExist: Bool = true,
            newsletterToken: String? = nil,
            doesPodcastPageExist: Bool = true,
            podcastToken: String? = nil
        ) {
            self.doesNewsletterPageExist = doesNewsletterPageExist
            self.newsletterToken = newsletterToken
            self.podcastToken = podcastToken
            self.doesPodcastPageExist = doesPodcastPageExist
        }
    }
    
    private let nextItemPageRelay = BehaviorRelay<NextItemPage>(value: .init())
    
    // MARK: - Components -
    
    var newsService: NewsService!
    
    // MARK: - Transformer -
    
    func transform(input: Input) -> Output {
        let refreshTrigger = Driver
            .merge([input.refresh, autorefresh.asDriver(onErrorDriveWith: .empty())])
            .startWith(())
            .do(onNext: { [weak self] in
                self?.newsItemsRelay.accept([])
                self?.nextItemPageRelay.accept(.init())
            })
        
        let nextPageTrigger = Driver<NextItemPage>
            .merge([
                refreshTrigger.map({ .init() }),
                input.endOfList.map({ [weak self] _ in self?.nextItemPageRelay.value ?? .init() })
            ])
        
        bindSelection(input: input.selection)
                
        let newsItemViewModels = newsItems(nextPageInput: nextPageTrigger)
            .map({ $0.sorted(by: { $0.date > $1.date }) })
            .do(onNext: { [weak self] items in self?.newsItemsRelay.accept(items) })
            .map({ $0.map(NewsItemViewModel.init) })
        
        return Output(
            isRefreshing: activityTracker.asDriver(),
            title: .just(NewsViewModel.title),
            newsItemViewModels: newsItemViewModels.asDriver(onErrorDriveWith: .empty())
        )
    }
    
    // MARK: - List -
    
    private func newsItems(
        nextPageInput: Driver<NextItemPage>
    ) -> Observable<[NewsItemPreviewBehaviour]> {
        return nextPageInput
            .asObservable()
            .flatMapLatest({ [weak self] nextPage -> Observable<[NewsItemPreviewBehaviour]> in
                guard let self = self else { return .empty() }
                
                return self.newsService
                    .listNewsItems(
                        request: .init(
                            lastNewsletterItemId: nextPage.newsletterToken,
                            lastPodcastItemId: nextPage.podcastToken
                        )
                    )
                    .map({ [weak self] response -> [NewsItemPreviewBehaviour] in
                        guard let self = self else { return [] }
                        
                        let newsItemsPage: [NewsItemPreviewBehaviour]
                        = (self.nextItemPageRelay.value.doesNewsletterPageExist
                            ? response.newsletterItems : [])
                        + (self.nextItemPageRelay.value.doesPodcastPageExist
                            ? response.podcastItems : [])
                        
                        self.nextItemPageRelay.accept(
                            .init(
                                doesNewsletterPageExist: response.newsletterNextPageToken != nil,
                                newsletterToken: response.newsletterNextPageToken,
                                doesPodcastPageExist: response.podcastNextPageToken != nil,
                                podcastToken: response.podcastNextPageToken
                            )
                        )
                        
                        return self.newsItemsRelay.value + newsItemsPage
                    })
                    .handleError()
                    .trackActivity(self.activityTracker)
            })
    }
    
    // MARK: - Selection -
    
    private func bindSelection(
        input: Driver<ViewModelFoundation>
    ) {
        input.asObservable()
            .map({ $0 as! NewsItemViewModel })
            .map({ $0.newsItem })
            .subscribe(onNext: { [weak self] newsItem in
                switch newsItem {
                    
                case let newsletterItem as NewsletterItem:
                    self?.events.newsletterItemTransitionRequest.accept(newsletterItem)
                case let podcastItem as PodcastItem:
                    self?.events.podcastItemTransitionRequest.accept(podcastItem)
                default:
                    fatalError("unexpected type")
                }
            })
            .disposed(by: disposer)
    }
}
