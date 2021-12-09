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
    
    // MARK: - Components -
    
    var newsService: NewsService!
    
    // MARK: - Transformer -
    
    func transform(input: Input) -> Output {
        let refreshTrigger = Driver
            .merge([input.refresh, autorefresh.asDriver(onErrorDriveWith: .empty())])
            .startWith(())
        
        bindSelection(input: input.selection)
        
        let newsItemViewModels = newsItems(refreshInput: refreshTrigger)
            .map({
                ($0.newsletterItems as [NewsItemPreviewBehaviour])
                + ($0.podcastItems as [NewsItemPreviewBehaviour])
            })
            .map({ $0.sorted(by: { $0.date > $1.date }) })
            .map({ $0.map(NewsItemViewModel.init) })
        
        return Output(
            isRefreshing: activityTracker.asDriver(),
            title: .just(NewsViewModel.title),
            newsItemViewModels: newsItemViewModels.asDriver(onErrorDriveWith: .empty())
        )
    }
    
    // MARK: - List -
    
    private func newsItems(
        refreshInput: Driver<Void>
    ) -> Observable<
        (
            newsletterItems: [NewsletterItem],
            podcastItems: [PodcastItem]
        )
    > {
        return refreshInput
            .asObservable()
            .flatMapLatest({
                [weak self] _ -> Observable<
                    (
                        newsletterItems: [NewsletterItem],
                        podcastItems: [PodcastItem]
                    )
                > in
                
                guard let self = self else { return .empty() }
                
                return self.newsService.listNewsItems()
                    .map({
                        return (
                            newsletterItems: $0.newsletterItems,
                            podcastItems: $0.podcastItems
                        )
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
