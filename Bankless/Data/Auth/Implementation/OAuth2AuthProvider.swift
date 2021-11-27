//
//  Created with ♥ by BanklessDAO contributors on 2021-11-05.
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
import OAuthSwift

final class OAuth2AuthProvider: AuthProvider {
    private let server: AuthProviderServer
    private let sessionStorage: SessionStorage
    private let oAuthHandler: OAuth2Swift
    private var lastRequest: OAuthSwiftRequestHandle?
    
    init(server: AuthProviderServer, sessionStorage: SessionStorage) {
        self.server = server
        self.sessionStorage = sessionStorage
        
        print("Auth Request Data:")
        print(server.clientId)
        print(server.clientSecret)
        print(server.autorizationURL)
        print(server.redirectURL)
        print(server.responseType)
        print(server.requestedScope)
        print(server.stateHandler?.generate() ?? "")
        
        self.oAuthHandler = OAuth2Swift(
            consumerKey:    server.clientId,
            consumerSecret: server.clientSecret,
            authorizeUrl:   server.autorizationURL,
            accessTokenUrl: server.accessTokenURL,
            responseType:   server.responseType
        )
        oAuthHandler.authorizeURLHandler = OAuth2WebViewController()
    }
    
    func authorizeClient(with server: AuthProviderServer) -> Completable {
        let existingSession = useCurrentSession()
        
        let authRequest = Completable
            .create { [weak self] observer in
                self?.lastRequest = self?.oAuthHandler.authorize(
                    withCallbackURL: server.redirectURL,
                    scope: server.requestedScope,
                    state: server.stateHandler?.generate() ?? "default",
                    parameters: server.customParameters ?? [:],
                    completionHandler: { result in
                        switch result {
                            
                        case .success(let (credentials, _, _)):
                            self?.sessionStorage.register(
                                token: credentials.oauthToken,
                                refreshToken: credentials.oauthRefreshToken,
                                tokenExpirationTimestamp: Int(
                                    credentials.oauthTokenExpiresAt?.timeIntervalSince1970 ?? 0.0
                                )
                            )
                            observer(.completed)
                        case .failure(let error):
                            print(
                                "Error while authorizing the client: "
                                    + error.localizedDescription
                            )
                            observer(.error(AuthError.authRequest(error)))
                        }
                    }
                )
                
                return Disposables.create()
            }
        
        return existingSession
            .catch { _ in
                return authRequest
            }
    }
    
    func deauthorizeClient(for server: AuthProviderServer) -> Completable {
        self.sessionStorage.clear()
        return .empty()
    }
    
    func useCurrentSession() -> Completable {
        return Completable.create { [weak self] observer in
            guard self?.sessionStorage
                    .tokenExpirationTimestamp ?? 0
                    > Int(Date().timeIntervalSince1970)
            else {
                observer(.error(AuthError.sessionExpired))
                return Disposables.create()
            }
            
            observer(.completed)
            return Disposables.create()
        }
    }
}
