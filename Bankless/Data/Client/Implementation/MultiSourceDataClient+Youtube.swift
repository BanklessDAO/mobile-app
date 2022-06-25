//
//  Created with ♥ by BanklessDAO contributors on 2022-06-25.
//  Copyright (C) 2022 BanklessDAO.

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

extension MultiSourceDataClient: YoutubeClient {
    private static let youtubeVideoURLForID: (String) -> URL = { id -> URL in
        return URL(string: "https://youtube.com/watch?v=\(id)")!
    }
    
    func getPodcastContent(request: PodcastItemsRequest) -> Observable<PodcastItemsResponse> {
        return youtubeAPI
            .request(.banklessPodcastPlaylistItems)
            .asObservable().do(onNext: { _ in print("MAPPING PODCAST") })
            .map(YoutubePlaylistItemsResponse.self)
            .map({
                $0.items.compactMap({ playlistItem -> PodcastItem? in
                    guard playlistItem.snippet.thumbnails.count > 0 else {
                        return nil
                    }
                    
                    let thumbnailURL = URL(
                        string: playlistItem.snippet.thumbnails["high"]!.url
                    )!
                    let videoURL = MultiSourceDataClient.youtubeVideoURLForID(
                        playlistItem.contentDetails.videoId
                    )
                    
                    return PodcastItem(
                        id: playlistItem.id,
                        title: playlistItem.snippet.title,
                        description: playlistItem.snippet.description,
                        publishedAt: Date(
                            dateString: playlistItem.snippet.publishedAt,
                            format: "yyyy-MM-dd'T'HH:mm:ss'Z'"
                        ),
                        thumbnailURL: thumbnailURL,
                        videoURL: videoURL
                    )
                })
            })
            .map({ PodcastItemsResponse(podcastItems: $0, podcastNextPageToken: nil) })
            .asObservable()
            .catchMapError()
    }
}
