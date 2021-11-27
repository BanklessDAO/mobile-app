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

final class NetworkIdentityService: IdentityService {
    private let discordClient: DiscordClient
    private var recentIdentityResponse: UserIdentityResponse?
    
    init(
        discordClient: DiscordClient
    ) {
        self.discordClient = discordClient
    }
    
    func getUserIdentity() -> Observable<UserIdentityResponse> {
        let recent: Observable<UserIdentityResponse> = recentIdentityResponse != nil
            ? .just(recentIdentityResponse!)
            : .empty()
        
        let fresh = discordClient.getCurrentUser()
            .map({ UserIdentityResponse(discordUser: $0) })
            .catchAndReturn(.init(discordUser: nil))
            .do(onNext: { [weak self] response in self?.recentIdentityResponse = response })
        
        return recent.concat(fresh)
    }
}
