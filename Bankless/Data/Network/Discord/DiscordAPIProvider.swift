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

final class DiscordAPIProvider: BaseNetworkProvider<DiscordAPIMethod> {
    private static let endpointGenerator = { (target: DiscordAPIMethod) -> Endpoint in
        let sampleResponseClosure = {
            return EndpointSampleResponse.networkResponse(200, target.sampleData)
        }
        
        let endpoint = Endpoint(
            url: url(route: target),
            sampleResponseClosure: sampleResponseClosure,
            method: target.method,
            task: target.task,
            httpHeaderFields: target.headers
        )
        
        return endpoint.adding(newHTTPHeaderFields: target.headers ?? [:])
    }
    
    convenience init(
        sessionStorage: SessionStorage
    ) {
        self.init(
            endpointClosure: DiscordAPIProvider.endpointGenerator,
            plugins: [
                BaseNetworkProvider<DiscordAPIMethod>.generateTokenInjector(with: sessionStorage),
                CachePolicyPlugin(),
            ],
            sessionStorage: sessionStorage
        )
    }
}
