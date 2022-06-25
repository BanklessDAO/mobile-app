//
//  Created with ♥ by BanklessDAO contributors on 2022-06-24.
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

extension MultiSourceDataClient: ENSClient {
    func resolveENS(request: ResolveENSRequest) -> Observable<ResolveENSResponse> {
        switch request.type {
            
        case let .address(ethAddress):
            return apolloRequest(
                apolloClient: ensGraphQLClient,
                apolloQuery: EnsNameQuery(ethAddress: ethAddress.lowercased()),
                responseType: ResolveENSResponse.self
            ) { graphQLResult in
                if let responseData = graphQLResult.data {
                    guard let record = responseData.domains.first else {
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
                            address:  ethAddress
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
                apolloClient: ensGraphQLClient,
                apolloQuery: EnsAddressQuery(ensName: ensName.lowercased()),
                responseType: ResolveENSResponse.self
            ) { graphQLResult in
                if let responseData = graphQLResult.data {
                    guard let record = responseData.domains.first else {
                        return .failure(DataError.unknown)
                    }
                    
                    return .success(
                        ResolveENSResponse(
                            name: ensName,
                            address: record.resolvedAddress!.id
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
}
