//
//  Created with ♥ by AuthDAO contributors on 2021-11-05.
//  Copyright (C) 2021 AuthDAO.

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

final class NetworkAuthService: AuthService {
    private let authProvider: AuthProvider
    
    init(
        authProvider: AuthProvider
    ) {
        self.authProvider = authProvider
    }
    
    func getDiscordAccess() -> Completable {
        return authProvider.authorizeClient(with: .discord)
    }
    
    func terminateDiscordAccess() -> Completable {
        return authProvider.deauthorizeClient(for: .discord)
    }
}
