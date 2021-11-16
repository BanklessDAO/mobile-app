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
            apolloQuery: SampleDataQuery(),
            responseType: BANKAccount.self
        ) { graphQLResult in
            if let _ = graphQLResult.data?.poapEvent {
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
            apolloQuery: SampleDataQuery(),
            responseType: [AttendanceToken].self
        ) { graphQLResult in
            if let _ = graphQLResult.data?.poapEvent {
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
            apolloQuery: SampleDataQuery(),
            responseType: TimelineContentResponse.self
        ) { graphQLResult in
            if let _ = graphQLResult.data?.poapEvent {
                let response = TimelineContentResponse(
                    bounties: Bounty.generateMocks(.random(in: 3 ... 3)),
                    academyCourses: AcademyCourse.generateMocks(.random(in: 1 ... 1))
                )
                
                return .success(response)
            } else if let errors = graphQLResult.errors {
                return .failure(DataError.generic(errors))
            } else {
                fatalError("not supported")
            }
        }
    }
}
