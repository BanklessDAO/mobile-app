//
//  Created with ♥ by BanklessDAO contributors on 2021-11-29.
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
import Moya

extension PrimitiveSequence where Trait == CompletableTrait, Element == Swift.Never {
    func catchMapError() -> Completable {
        return `catch`({ (error: Error) -> Completable in
            let result: Completable
            
            if let moyaError = error as? MoyaError {
                result = Completable.error(
                    self.catchMapMoyaError(moyaError) ?? moyaError
                )
            } else {
                print("Encountered error: \(error)")
                result = Completable.error(error)
            }
            
            return result
        })
    }
}

extension PrimitiveSequence where Trait == SingleTrait {
    func catchMapError() -> Single<Element> {
        return `catch`({ (error: Error) -> Single<Element> in
            let result: Single<Element>
            
            if let moyaError = error as? MoyaError {
                result = Single<Element>.error(
                    self.catchMapMoyaError(moyaError) ?? moyaError
                )
            } else {
                print("Encountered error: \(error)")
                result = Single<Element>.error(error)
            }
            
            return result
        })
    }
}

extension PrimitiveSequence where Trait == SingleTrait, Element: Response {
    func catchMapError(by networkProvider: NetworkProvider) -> PrimitiveSequence<Trait, Element> {
        return `catch`({ (error: Error) -> PrimitiveSequence<Trait, Element> in
            guard let moyaError = error as? MoyaError else {
                return self
            }
            
            return PrimitiveSequence<Trait, Element>.error(
                self.catchMapMoyaError(moyaError, networkProvider: networkProvider) ?? moyaError
            )
        })
    }
}

extension ObservableType {
    func catchMapError() -> Observable<Element> {
        return `catch`({ (error: Error) -> Observable<Element> in
            let result: Observable<Element>
            
            if let moyaError = error as? MoyaError {
                result = Observable<Element>.error(
                    self.catchMapMoyaError(
                        moyaError
                    ) ?? moyaError
                )
            } else {
                print("Encountered error: \(error)")
                result = Observable<Element>.error(error)
            }
            
            return result
        })
    }
}

extension ObservableConvertibleType {
    fileprivate func catchMapMoyaError(
        _ moyaError: MoyaError,
        networkProvider: NetworkProvider? = nil
    ) -> Error? {
        var error: Error?
        
        if let provider = networkProvider {
            /**
             Session errors
             */
            if case let .statusCode(response) = moyaError,
               [401, 403].contains(response.statusCode) {
                
                error = provider.sessionStorage.token != nil
                ?  DataError.sessionInvalid
                :  DataError.unknown
                
                provider.sessionStorage.clear()
                
                return error
            }
            
            return moyaError
        }
        
        /**
         Client-side errors
         */
        
        if let clientError = catchClientError(from: moyaError) {
            return clientError
        }
        
        /**
         No specific handle-able error identified
         */
        return DataError.raw(moyaError)
    }
}

func catchClientError(
    from moyaError: MoyaError
) -> DataError? {
    guard case let .statusCode(response) = moyaError, response.statusCode == 400 else {
        return nil
    }
    
    /**
     This is where our domain-specific errors are supposed to be handled.
     If the server returns an HTTP 400 error indicating that something should
     be different in the request — this function will be triggered.
     */
    return DataError.raw(moyaError)
}
