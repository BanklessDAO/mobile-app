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

class MockConfigurator: Configurator {
    func configure() -> DependencyContainer {
        let container = SimpleDependencyContainer()
        
        let userSettingsService = MockUserSettingsService()
        container.register { (object: inout UserSettingsServiceDependency) in
            object.userSettingsService = userSettingsService
        }
        
        let authService = MockAuthService()
        container.register { (object: inout AuthServiceDependency) in
            object.authService = authService
        }
        
        let identityService = MockIdentityService()
        container.register { (object: inout IdentityServiceDependency) in
            object.identityService = identityService
        }
        
        let banklessService = MockBanklessService()
        container.register { (object: inout BanklessServiceDependency) in
            object.banklessService = banklessService
        }
        
        let achievementsService = MockAchievementsService()
        container.register { (object: inout AchievementsServiceDependency) in
            object.achievementsService = achievementsService
        }
        
        let timelineService = MockTimelineService()
        container.register { (object: inout TimelineServiceDependency) in
            object.timelineService = timelineService
        }
        
        let newsService = MockNewsService()
        container.register { (object: inout NewsServiceDependency) in
            object.newsService = newsService
        }
        
        let bountyBoardService = MockBountyBoardService()
        container.register { (object: inout BountyBoardServiceDependency) in
            object.bountyBoardService = bountyBoardService
        }
        
        let academyService = MockAcademyService()
        container.register { (object: inout AcademyServiceDependency) in
            object.academyService = academyService
        }
        
        return container
    }
}
