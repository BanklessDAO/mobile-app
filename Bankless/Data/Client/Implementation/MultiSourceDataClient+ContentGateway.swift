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
import RxSwift

extension MultiSourceDataClient: ContentGatewayClient {
    func getUserBANKAccount() -> Observable<BANKAccount> {
        return apolloRequest(
            apolloQuery: TimelineQuery(),
            responseType: BANKAccount.self
        ) { graphQLResult in
            if let _ = graphQLResult.data?.banklessTokens?.data {
                return .success(BANKAccount.generateMock())
            } else if let errors = graphQLResult.errors {
                return .failure(DataError.generic(errors))
            } else {
                fatalError("not supported")
            }
        }
    }
    
    func getUserAttendanceTokens() -> Observable<[AttendanceToken]> {
        return apolloRequest(
            apolloQuery: TimelineQuery(),
            responseType: [AttendanceToken].self
        ) { graphQLResult in
            if let _ = graphQLResult.data?.poapTokens?.data {
                return .success(AttendanceToken.generateMocks(5))
            } else if let errors = graphQLResult.errors {
                return .failure(DataError.generic(errors))
            } else {
                fatalError("not supported")
            }
        }
    }
    
    func getTimelineContent() -> Observable<TimelineContentResponse> {
        return apolloRequest(
            apolloQuery: TimelineQuery(),
            responseType: TimelineContentResponse.self
        ) { graphQLResult in
            if let timelineData = graphQLResult.data {
                let bounties = Array(
                        (timelineData.bounties?.data ?? [])
                        .reversed()[0 ... 2]
                    )
                    .map({
                        Bounty(
                            id: $0.id!,
                            season: $0.season!,
                            title: $0.title!,
                            descrtiption: $0.description!,
                            criteria: "TBD",
                            reward: .init(
                                currency: "BANK",
                                amount: Float($0.rewardAmount!),
                                scale: 1
                            ),
                            createdBy: .generateMock(),
                            createdAt: nil,
                            dueAt: nil,
                            discordMessageId: nil,
                            status: .open,
                            statusHistory: [],
                            claimedBy: nil,
                            claimedAt: nil,
                            submissionNotes: nil,
                            submissionUrl: nil,
                            submittedAt: nil,
                            submittedBy: nil,
                            reviewedAt: nil,
                            reviewedBy: nil
                        )
                    })
                
                let academyCourses = timelineData.courses?.data
                    .map({
                        AcademyCourse(
                            id: UUID().uuidString,
                            name: $0.name!,
                            slug: $0.slug!,
                            backgroundImageURL: URL(string: $0.poapImageLink!)!,
                            notionId: UUID().uuidString,
                            poapEventId: Int($0.poapEventId!),
                            description: $0.description!,
                            duration: Int($0.duration!),
                            difficulty: .init(rawValue: $0.difficulty!.lowercased())!,
                            poapImageLink: URL(string: $0.poapImageLink!)!,
                            learnings: $0.learnings!,
                            learningActions: $0.learningActions!,
                            knowledgeRequirements: $0.knowledgeRequirements!,
                            sections: $0.sections
                                .map({
                                    $0.compactMap({ section -> AcademyCourse.Section in
                                        AcademyCourse.Section(
                                            id: UUID().uuidString,
                                            type: .init(rawValue: section!.type!.lowercased())!,
                                            title: section!.title!,
                                            content: section!.content!,
                                            quiz: nil,
                                            component: nil
                                        )
                                    })
                                }) ?? []
                        )
                    })
                
                let response = TimelineContentResponse(
                    newsletterItems: NewsletterItem.generateMocks(.random(in: 2 ... 4)),
                    podcastItems: PodcastItem.generateMocks(.random(in: 2 ... 4)),
                    bounties: bounties,
                    academyCourses: academyCourses ?? []
                )
                
                return .success(response)
            } else if let errors = graphQLResult.errors {
                return .failure(DataError.generic(errors))
            } else {
                fatalError("not supported")
            }
        }
    }
    
    func getNewsContent() -> Observable<NewsContentResponse> {
        return .just(
            NewsContentResponse(
                newsletterItems: NewsletterItem.generateMocks(.random(in: 20 ... 40)),
                podcastItems: PodcastItem.generateMocks(.random(in: 90 ... 120))
            )
        )
    }
}
