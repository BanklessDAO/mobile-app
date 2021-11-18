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

final class PodcastDetailsViewModel: BaseViewModel {
    // MARK: - Input/Output -
    
    struct Input { }
    
    struct Output {
        let date: Driver<String>
        let videoViewModel: Driver<VideoViewModel>
        let title: Driver<String>
        let description: Driver<String>
    }
    
    // MARK: - Data -
    
    private let podcastItem: PodcastItem
    
    // MARK: - Initializers -
    
    init(podcastItem: PodcastItem) {
        self.podcastItem = podcastItem
    }
    
    // MARK: - Transformer -
    
    func transform(input: Input) -> Output {
        let videoViewModel = VideoViewModel(videoSource: podcastItem)
        
        return Output(
            date: dateString().asDriver(onErrorDriveWith: .empty()),
            videoViewModel: .just(videoViewModel),
            title: .just(podcastItem.title),
            description: .just(podcastItem.description)
        )
    }
    
    private func dateString() -> Observable<String> {
        return .just(
            podcastItem.date.format(with: DateFormatter.Style.medium)
        )
    }
}
