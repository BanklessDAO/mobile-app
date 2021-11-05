//
//  Created with ♥ by BanklessDAO contributors on 2021-10-08.
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
import Apollo

class ApolloGraphQLClient: DataClient {
    let apollo: ApolloClient
    
    init(
        baseURL: URL
    ) {
        self.apollo = ApolloClient(url: baseURL)
    }
    
    func request<T>(query: DataQuery) -> Observable<T> {
        switch query {
            
        case .timelineItems:
            return apolloRequest(
                apolloQuery: SampleDataQuery(),
                responseType: T.self
            ) { graphQLResult in
                if let event = graphQLResult.data?.poapEvent {
                    print(event)
                    
                    let response = TimelineItemsResponse(
                        bounties: Bounty.generateMocks(.random(in: 2 ... 2)),
                        academyCourses: AcademyCourse.generateMocks(.random(in: 1 ... 1))
                    )
                    
                    return .success(response as! T)
                } else if let errors = graphQLResult.errors {
                    return .failure(DataError.generic(errors))
                } else {
                    fatalError("not supported")
                }
            }
        case .bankOnChainInfo:
            return apolloRequest(
                apolloQuery: SampleDataQuery(),
                responseType: T.self
            ) { graphQLResult in
                if let event = graphQLResult.data?.poapEvent {
                    print(event)
                    
                    let response = DAOOwnershipResponse(
                        bankAccount: BANKAccount.generateMock()
                    )
                    
                    return .success(response as! T)
                } else if let errors = graphQLResult.errors {
                    return .failure(DataError.generic(errors))
                } else {
                    fatalError("not supported")
                }
            }
        case .poapTokens:
            return apolloRequest(
                apolloQuery: SampleDataQuery(),
                responseType: T.self
            ) { graphQLResult in
                if let event = graphQLResult.data?.poapEvent {
                    print(event)
                    
                    let response = AchievementsResponse(
                        attendanceTokens: AttendanceToken.generateMocks(.random(in: 5 ... 5))
                    )
                    
                    return .success(response as! T)
                } else if let errors = graphQLResult.errors {
                    return .failure(DataError.generic(errors))
                } else {
                    fatalError("not supported")
                }
            }
        }
    }
}
