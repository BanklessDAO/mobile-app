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
import Moya
import RxSwift

class BaseNetworkProvider<Method>: MoyaProvider<Method>, NetworkProvider where Method: TargetType {
    static func generateTokenInjector(with sessionStorage: SessionStorage) -> AccessTokenPlugin {
        return AccessTokenPlugin { _ in
            return sessionStorage.token ?? ""
        }
    }
    
    static func url(route: Method) -> String {
        return route.baseURL.appendingPathComponent(route.path).absoluteString
    }
    
    let scheduler = ConcurrentDispatchQueueScheduler(
        qos: DispatchQoS(qosClass: DispatchQoS.QoSClass.background, relativePriority: 1)
    )
    
    let sessionStorage: SessionStorage
    
    init(
        endpointClosure: @escaping MoyaProvider<Target>.EndpointClosure,
        plugins: [PluginType],
        sessionStorage: SessionStorage
    ) {
        self.sessionStorage = sessionStorage
        
        super.init(
            endpointClosure: endpointClosure,
            plugins: plugins
        )
    }
    
    func request(_ target: Method) -> Single<Response> {
        return rx.request(target).observe(on: scheduler)
            .filterSuccessfulStatusCodes()
            .do(onSuccess: { [weak self] response in
                self?.cache(response: response, for: target)
            })
    }
}

extension BaseNetworkProvider {
    private func configureCache() {
        let cacheSizeMemory = 100 * 1024 * 1024
        let cacheSizeDisk = 500 * 1024 * 1024
        
        URLCache.shared = URLCache(
            memoryCapacity: cacheSizeMemory,
            diskCapacity: cacheSizeDisk,
            diskPath: "NetworkCaches"
        )
    }
    
    private func cache(response moyaResponse: Response, for target: Method) {
        guard target.method == .get else { return }
        
        let endpoint = endpointClosure(target)
        
        guard let request = try? endpoint.urlRequest(),
              let httpResponse = moyaResponse.response else {
                  return
              }
        
        let cachedResponse = CachedURLResponse(
            response: httpResponse,
            data: moyaResponse.data
        )
        
        URLCache.shared.storeCachedResponse(cachedResponse, for: request)
    }
    
    private func cachedResponse(for target: Method) -> Single<Response>? {
        guard target.method == .get else { return nil }
        
        let endpoint = endpointClosure(target)
        
        guard let request = try? endpoint.urlRequest(),
              let cachedResponse = URLCache.shared.cachedResponse(for: request),
              let httpResponse = cachedResponse.response as? HTTPURLResponse else {
                  return nil
              }
        
        let moyaResponse = Response(
            statusCode: httpResponse.statusCode,
            data: cachedResponse.data,
            request: request,
            response: httpResponse
        )
        
        return .just(moyaResponse)
    }
}
