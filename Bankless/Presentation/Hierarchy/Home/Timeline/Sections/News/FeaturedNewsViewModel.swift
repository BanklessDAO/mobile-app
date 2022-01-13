//
//  Created with ♥ by BanklessDAO contributors on 2021-10-07.
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

final class FeaturedNewsViewModel: BaseViewModel {
    // MARK: - Input/Output -
    
    struct Input {
        let selection: Driver<Int>
        let expand: Driver<Void>
    }
    
    struct Output {
        let title: Driver<String>
        let expandButtonTitle: Driver<String>
        let items: Driver<[NewsItemPreviewBehaviour]>
    }
    
    // MARK: - Constants -
    
    private static let title = NSLocalizedString(
        "home.timeline.news.title", value: "Latest", comment: ""
    )
    
    static let expandButtonTitle = NSLocalizedString(
        "home.timeline.news.controls.expand.title", value: "See All", comment: ""
    )
    
    // MARK: - Data -
    
    private let newsItems: [NewsItemPreviewBehaviour]
    
    // MARK: - Events -
    
    let selectionRelay = PublishRelay<Int>()
    let expandRequestRelay = PublishRelay<Void>()
    
    // MARK: - Initializets -
    
    init(newsItems: [NewsItemPreviewBehaviour]) {
        self.newsItems = newsItems + [ShowMorePlaceholderItem()]
    }
    
    // MARK: - Transformer -
    
    func transform(input: Input) -> Output {
        input.selection
            .drive(onNext: { [weak self] index in
                guard let self = self else { return }
                
                guard !(self.newsItems[index] is ShowMorePlaceholderItem) else {
                    self.expandRequestRelay.accept(())
                    return
                }
                
                self.selectionRelay.accept(index)
            }).disposed(by: disposer)
        
        input.expand.drive(onNext: { [weak self] in
            guard let self = self else { return }
            
            self.expandRequestRelay.accept(())
        }).disposed(by: disposer)
        
        return Output(
            title: .just(FeaturedNewsViewModel.title),
            expandButtonTitle: .just(FeaturedNewsViewModel.expandButtonTitle),
            items: .just(newsItems)
        )
    }
}
