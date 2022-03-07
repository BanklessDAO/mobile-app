//
//  Created with ♥ by BanklessDAO contributors on 2021-11-10.
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
import Apollo
import RxSwift
import BigInt
import Ink

extension MultiSourceDataClient: ContentGatewayClient {
    // MARK: - Constants -
    
    private static let bankTokenDecimalPlaces = 0
    private static let youtubeVideoURLForID: (String) -> URL = { id -> URL in
        return URL(string: "https://youtube.com/watch?v=\(id)")!
    }
    
    // MARK: - Methods -
    
    func resolveENS(request: ResolveENSRequest) -> Observable<ResolveENSResponse> {
        switch request.type {
            
        case let .address(ethAddress):
            return apolloRequest(
                apolloQuery: EnsNameQuery(ethAddress: ethAddress.lowercased()),
                responseType: ResolveENSResponse.self
            ) { graphQLResult in
                if let responseData = graphQLResult.data {
                    guard let record = responseData.historical.ensV1.ensDomainV1s.data.first else {
                        return .success(
                            ResolveENSResponse(
                                name: nil,
                                address: ethAddress
                            )
                        )
                    }
                    
                    return .success(
                        ResolveENSResponse(
                            name: record.name!,
                            address:  record.address!
                        )
                    )
                } else if let errors = graphQLResult.errors {
                    return .failure(DataError.rawCollection(errors))
                } else {
                    fatalError("not supported")
                }
            }
        case let .name(ensName):
            return apolloRequest(
                apolloQuery: EnsAddressQuery(ensName: ensName.lowercased()),
                responseType: ResolveENSResponse.self
            ) { graphQLResult in
                if let responseData = graphQLResult.data {
                    guard let record = responseData.historical.ensV1.ensDomainV1s.data.first else {
                        return .failure(DataError.unknown)
                    }
                    
                    return .success(
                        ResolveENSResponse(
                            name: record.name!,
                            address:  record.address!
                        )
                    )
                } else if let errors = graphQLResult.errors {
                    return .failure(DataError.rawCollection(errors))
                } else {
                    fatalError("not supported")
                }
            }
        }
    }
    
    func getUserBANKAccount(request: BANKAccountRequest) -> Observable<BANKAccount> {
        return apolloRequest(
            apolloQuery: BankAccountQuery(ethAddress: request.ethAddress.lowercased()),
            responseType: BANKAccount.self
        ) { graphQLResult in
            if let responseData = graphQLResult.data {
                let accountInfo = responseData.historical.banklessTokenV1.myAccount.data.first
                
                let balanceIntString = accountInfo != nil
                ? String(accountInfo!.balance!.split(separator: ".").first!)
                : nil
                                
                let fromTXs = responseData.historical.banklessTokenV1.fromTransfers.data
                    .map({ t -> BANKAccount.Transaction in
                        let amountIntString = String(t.value!.split(separator: ".").first!)
                        
                        return BANKAccount.Transaction(
                            fromAddress: t.fromId!,
                            toAddress: t.toId!,
                            amount: BigInt(stringLiteral: amountIntString)
                            * BigInt(MultiSourceDataClient.bankTokenDecimalPlaces)
                        )
                    })
                let toTXs = responseData.historical.banklessTokenV1.toTransfers.data
                    .map({ t -> BANKAccount.Transaction in
                        let amountIntString = String(t.value!.split(separator: ".").first!)
                        
                        return BANKAccount.Transaction(
                            fromAddress: t.fromId!,
                            toAddress: t.toId!,
                            amount: BigInt(stringLiteral: amountIntString)
                            * BigInt(10).power(MultiSourceDataClient.bankTokenDecimalPlaces)
                        )
                    })
                
                let lastTransactionTimestamp = accountInfo?.lastTransactionExecutedAt != nil
                ? Date(
                    timeIntervalSince1970: TimeInterval(accountInfo!.lastTransactionExecutedAt!)!
                )
                : nil
                
                let bankAccount = BANKAccount(
                    address: request.ethAddress,
                    balance: (
                        balanceIntString != nil
                        ? BigInt(stringLiteral: balanceIntString!)
                        : BigInt(0)
                    ) * BigInt(10).power(MultiSourceDataClient.bankTokenDecimalPlaces),
                    transactions: fromTXs + toTXs, // TODO: Add TX timestamps to sort based on
                    lastTransactionTimestamp: lastTransactionTimestamp
                )
                
                return .success(bankAccount)
            } else if let errors = graphQLResult.errors {
                return .failure(DataError.rawCollection(errors))
            } else {
                fatalError("not supported")
            }
        }
    }
    
    func getUserAttendanceTokens(
        request: AttendanceTokensRequest
    ) -> Observable<[AttendanceToken]> {
        return apolloRequest(
            apolloQuery: TimelineQuery(),
            responseType: [AttendanceToken].self
        ) { graphQLResult in
            fatalError("not implemented")
        }
    }
    
    func getTimelineContent() -> Observable<TimelineContentResponse> {
        return apolloRequest(
            apolloQuery: TimelineQuery(),
            responseType: TimelineContentResponse.self
        ) { graphQLResult in
            if let timelineData = graphQLResult.data {
                let newsletterItems = timelineData.historical.banklessWebsiteV1.posts.data
                    .map({ post in
                        NewsletterItem(
                            id: post.id!,
                            title: post.title!,
                            slug: post.slug!,
                            excerpt: post.excerpt!,
                            createdAt: Date(timeIntervalSince1970: post.createdAt! / 1000),
                            updatedAt: Date(timeIntervalSince1970: post.updatedAt! / 1000),
                            coverPictureURL: URL(string: post.featureImage!)!,
                            url: URL(string: post.url!)!,
                            htmlContent: post.html!,
                            readingTimeInMinutes: Int(post.readingTime!),
                            isFeatured: post.featured!
                        )
                    })
                
                let podcastItems = timelineData.historical.banklessPodcastV1.playlist.data
                    .compactMap({ playlistItem -> PodcastItem? in
                        guard (playlistItem.snippet?.thumbnails?.count ?? 0) > 0 else {
                            return nil
                        }
                        
                        let thumbnailURL = URL(
                            string: playlistItem.snippet!.thumbnails!
                                .filter({ $0!.kind == "high" }).compactMap({ $0 }).first!.url!
                        )!
                        let videoURL = MultiSourceDataClient.youtubeVideoURLForID(
                            playlistItem.contentDetails!.videoId!
                        )
                        
                        return PodcastItem(
                            id: playlistItem.id!,
                            title: playlistItem.snippet!.title!,
                            description: playlistItem.snippet!.description!,
                            publishedAt: Date(
                                timeIntervalSince1970: playlistItem.snippet!.publishedAt! / 1000
                            ),
                            thumbnailURL: thumbnailURL,
                            videoURL: videoURL
                        )
                    })
                
                let academyCourses = timelineData.historical.banklessAcademyV1.allCourses
                    .data
                    .map({ course -> AcademyCourse in
                        let sections = course.slides
                            .map({
                                $0.compactMap({ section -> AcademyCourse.Section in
                                    let type: AcademyCourse.Section.`Type` = .init(
                                        rawValue: section!.type!.lowercased()
                                    )!
                                    
                                    let quiz = section!.quiz != nil
                                    ? AcademyCourse.Section.Quiz(
                                        id: UUID().uuidString,
                                        question: section!.quiz!.question!,
                                        answers: section!.quiz!.answers!.compactMap({ $0 }),
                                        rightAnswerNumber: Int(section!.quiz!.rightAnswerNumber!)
                                        - 1
                                    )
                                    : nil
                                    
                                    return AcademyCourse.Section(
                                        id: UUID().uuidString,
                                        type: type,
                                        title: section!.title!,
                                        content: type == .learn
                                        ? section!.content!
                                        : nil,
                                        quiz: quiz,
                                        component: nil,
                                        poapImageLink: type == .poap
                                        ? URL(string: course.poapImageLink!)!
                                        : nil
                                    )
                                })
                            }) ?? []
                        
                        return AcademyCourse(
                            id: UUID().uuidString,
                            name: course.name!,
                            slug: course.slug!,
                            backgroundImageURL: URL(string: course.lessonImageLink!)!,
                            notionId: UUID().uuidString,
                            poapEventId: Int(course.poapEventId!),
                            description: course.description!,
                            duration: Int(course.duration!),
                            difficulty: .init(rawValue: course.difficulty!.lowercased())!,
                            poapImageLink: URL(string: course.poapImageLink!)!,
                            learnings: course.learnings!,
                            learningActions: course.learningActions!,
                            knowledgeRequirements: course.knowledgeRequirements!,
                            sections: sections
                        )
                    })
                
                let response = TimelineContentResponse(
                    newsletterItems: Array(newsletterItems),
                    podcastItems: Array(podcastItems),
                    bounties: [],
                    academyCourses: academyCourses
                )
                
                return .success(response)
            } else if let errors = graphQLResult.errors {
                return .failure(DataError.rawCollection(errors))
            } else {
                fatalError("not supported")
            }
        }
    }
    
    func getNewsContent(request: NewsContentRequest) -> Observable<NewsContentResponse> {
        return apolloRequest(
            apolloQuery: NewsQuery(
                lastPodcastId: request.lastPodcastItemId,
                lastWebsitePostId: request.lastNewsletterItemId
            ),
            responseType: NewsContentResponse.self
        ) { graphQLResult in
            if let responseData = graphQLResult.data {
                let podcastsPageInfo = responseData.historical.banklessPodcastV1.playlist.pageInfo
                
                let podcastItems = responseData.historical.banklessPodcastV1.playlist.data
                    .compactMap({ playlistItem -> PodcastItem? in
                        guard (playlistItem.snippet?.thumbnails?.count ?? 0) > 0 else {
                            return nil
                        }
                        
                        let thumbnailURL = URL(
                            string: playlistItem.snippet!.thumbnails!
                                .filter({ $0!.kind == "high" }).compactMap({ $0 }).first!.url!
                        )!
                        let videoURL = MultiSourceDataClient.youtubeVideoURLForID(
                            playlistItem.contentDetails!.videoId!
                        )
                        
                        return PodcastItem(
                            id: playlistItem.id!,
                            title: playlistItem.snippet!.title!,
                            description: playlistItem.snippet!.description!,
                            publishedAt: Date(
                                timeIntervalSince1970: playlistItem.snippet!.publishedAt!  / 1000
                            ),
                            thumbnailURL: thumbnailURL,
                            videoURL: videoURL
                        )
                    })
                
                let response = NewsContentResponse(
                    newsletterItems: [],
                    newsletterNextPageToken: nil,
                    podcastItems: podcastItems,
                    podcastNextPageToken: podcastsPageInfo.nextPageToken
                )
                
                return .success(response)
            } else if let errors = graphQLResult.errors {
                return .failure(DataError.rawCollection(errors))
            } else {
                fatalError("not supported")
            }
        }
    }
    
    func getAcademyCourses() -> Observable<AcademyCoursesResponse> {
        return apolloRequest(
            apolloQuery: AcademyQuery(),
            responseType: AcademyCoursesResponse.self
        ) { graphQLResult in
            if let responseData = graphQLResult.data {
                let academyCourses = responseData.historical.banklessAcademyV1.allCourses.data
                    .map({ course -> AcademyCourse in
                        let sections = course.slides
                            .map({
                                $0.compactMap({ section -> AcademyCourse.Section in
                                    let type: AcademyCourse.Section.`Type` = .init(
                                        rawValue: section!.type!.lowercased()
                                    )!
                                    
                                    let quiz = section!.quiz != nil
                                    ? AcademyCourse.Section.Quiz(
                                        id: UUID().uuidString,
                                        question: section!.quiz!.question!,
                                        answers: section!.quiz!.answers!.compactMap({ $0 }),
                                        rightAnswerNumber: Int(section!.quiz!.rightAnswerNumber!)
                                        - 1
                                    )
                                    : nil
                                    
                                    return AcademyCourse.Section(
                                        id: UUID().uuidString,
                                        type: type,
                                        title: section!.title!,
                                        content: type == .learn
                                        ? section!.content!
                                        : nil,
                                        quiz: quiz,
                                        component: nil,
                                        poapImageLink: type == .poap
                                        ? URL(string: course.poapImageLink!)!
                                        : nil
                                    )
                                })
                            }) ?? []
                        
                        return AcademyCourse(
                            id: UUID().uuidString,
                            name: course.name!,
                            slug: course.slug!,
                            backgroundImageURL: URL(string: course.lessonImageLink!)!,
                            notionId: UUID().uuidString,
                            poapEventId: Int(course.poapEventId!),
                            description: course.description!,
                            duration: Int(course.duration!),
                            difficulty: .init(rawValue: course.difficulty!.lowercased())!,
                            poapImageLink: URL(string: course.poapImageLink!)!,
                            learnings: course.learnings!,
                            learningActions: course.learningActions!,
                            knowledgeRequirements: course.knowledgeRequirements!,
                            sections: sections
                        )
                    })
                
                let response = AcademyCoursesResponse(courses: academyCourses)
                
                return .success(response)
            } else if let errors = graphQLResult.errors {
                return .failure(DataError.rawCollection(errors))
            } else {
                fatalError("not supported")
            }
        }
    }
}
