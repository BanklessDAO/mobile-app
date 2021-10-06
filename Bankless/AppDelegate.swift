//
//  Created with ♥ by BanklessDAO contributors on 2021-09-29.
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

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var applicationCoordinator: ApplicationCoordinator!
    
    // MARK: - App lifecycle -
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = .black
        self.window = window
        ApplicationAppearance.apply(window: window)
        
#if TEST
        let appConfiguration = ApplicationConfigurator.Configuration.test
#elseif PROD
        let appConfiguration = ApplicationConfigurator.Configuration.prod
#else
        let appConfiguration = ApplicationConfigurator.Configuration.mock
#endif
        
        let configurator = ApplicationConfigurator(configuration: appConfiguration)
        let container = configurator.configure()
        
        applicationCoordinator = ApplicationCoordinator(
            appDelegate: self,
            window: window,
            container: container
        )
        container.resolve(applicationCoordinator)
        
        applicationCoordinator.start()
        
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    func application(
        _ application: UIApplication,
        performFetchWithCompletionHandler
        completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        
    }
}
