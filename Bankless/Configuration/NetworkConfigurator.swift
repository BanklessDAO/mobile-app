//
//  Created with ♥ by BanklessDAO contributors on 2021-10-05.
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

class NetworkConfigurator: Configurator {
    private static let cgGraphQLAPIEndpoint: URL = .init(string: Environment.graphQLAPIEndpoint)!
    private static let ensGraphQLAPIEndpoint: URL = .init(string: Environment.ensSubgraphAPIURL)!
    private static let bankGraphQLAPIEndpoint: URL = .init(
        string: Environment.bankTokenSubgraphAPIURL
    )!
    
    func configure() -> DependencyContainer {
        let container = SimpleDependencyContainer()
        
        let appLevelSettingsStorage = AppLevelPersistentSettingsStorage()
        
        let keychainSessionStorage = KeychainBasedSessionStorage()
        
        let discordAuthProvider = OAuth2AuthProvider(
            server: .discord,
            sessionStorage: keychainSessionStorage
        )
        
        let dataClient = MultiSourceDataClient(
            contentGatewayAPIURL: NetworkConfigurator.cgGraphQLAPIEndpoint,
            ensAPIURL: NetworkConfigurator.ensGraphQLAPIEndpoint,
            bankTokenAPIURL: NetworkConfigurator.bankGraphQLAPIEndpoint,
            sessionStorage: keychainSessionStorage
        )
        
        let userSettingsService = DefaultUserSettingsService(
            settingsStorage: appLevelSettingsStorage,
            ensClient: dataClient
        )
        container.register { (object: inout UserSettingsServiceDependency) in
            object.userSettingsService = userSettingsService
        }
        
        let authService = NetworkAuthService(authProvider: discordAuthProvider)
        container.register { (object: inout AuthServiceDependency) in
            object.authService = authService
        }
        
        let identityService = NetworkIdentityService(discordClient: dataClient)
        container.register { (object: inout IdentityServiceDependency) in
            object.identityService = identityService
        }
        
        let banklessService = NetworkBanklessService(banklessClient: dataClient)
        container.register { (object: inout BanklessServiceDependency) in
            object.banklessService = banklessService
        }
        
        let achievementsService = NetworkAchievementsService(poapClient: dataClient)
        container.register { (object: inout AchievementsServiceDependency) in
            object.achievementsService = achievementsService
        }
        
        let timelineService = NetworkTimelineService(
            youtubeClient: dataClient, academyClient: dataClient
        )
        container.register { (object: inout TimelineServiceDependency) in
            object.timelineService = timelineService
        }
        
        let newsService = NetworkNewsService(youtubeClient: dataClient)
        container.register { (object: inout NewsServiceDependency) in
            object.newsService = newsService
        }
        
        let bountyBoardService = MockBountyBoardService()
        container.register { (object: inout BountyBoardServiceDependency) in
            object.bountyBoardService = bountyBoardService
        }
        
        let academyService = NetworkAcademyService(
            banklessAcademyClient: dataClient
        )
        container.register { (object: inout AcademyServiceDependency) in
            object.academyService = academyService
        }
        
        return container
    }
}
