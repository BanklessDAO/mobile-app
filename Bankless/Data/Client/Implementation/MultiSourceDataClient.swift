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

class MultiSourceDataClient: DataClient {
    let discordAPI: DiscordAPIProvider
    let banklessAcademyAPI: BanklessAcademyAPIProvider
    let poapAPI: PoapAPIProvider
    let apollo: ApolloClient
    
    init(
        contentGatewayAPIBaseURL: URL,
        sessionStorage: SessionStorage
    ) {
        self.discordAPI = DiscordAPIProvider(sessionStorage: sessionStorage)
        self.banklessAcademyAPI = BanklessAcademyAPIProvider(sessionStorage: sessionStorage)
        self.poapAPI = PoapAPIProvider(sessionStorage: sessionStorage)
        self.apollo = ApolloClient(url: contentGatewayAPIBaseURL)
    }
}
