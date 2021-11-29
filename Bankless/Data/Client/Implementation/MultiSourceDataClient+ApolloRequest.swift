//
//  Created with ♥ by BanklessDAO contributors on 2021-10-14.
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

extension MultiSourceDataClient {
    func apolloRequest<Q, T>(
        apolloQuery: Q,
        responseType: T.Type,
        resultMapper: @escaping (Apollo.GraphQLResult<Q.Data>) -> Result<T, Error>
    ) -> Observable<T> where Q: Apollo.GraphQLQuery {
        return Observable<T>.create { [weak self] observer in
            self?.apollo.fetch(query: apolloQuery) { result in
                switch result {
                    
                case .success(let graphQLResult):
                    if let errors = graphQLResult.errors {
                        print(errors)
                        
                        let genericError = DataError.rawCollection(errors)
                        observer.onError(genericError)
                    }
                    
                    let mappingResult = resultMapper(graphQLResult)
                    
                    switch mappingResult {
                        
                    case .success(let payload):
                        observer.onNext(payload)
                    case .failure(let error):
                        print(error.localizedDescription)
                        
                        let mappingError = DataError.mappingError(error)
                        observer.onError(mappingError)
                    }
                case .failure(let error):
                    print(error)
                    
                    let genericError = DataError.rawCollection([error])
                    observer.onError(genericError)
                }
            }
            
            return Disposables.create()
        }
    }
}
