//
//  AppDelegate.swift
//  Example
//
//  Created by Jiří Zoudun on 21/02/2020.
//  Copyright © 2020 Etnetera a. s. All rights reserved.
//

import LifetimeTracker
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var homeCoord = HomeCoordinator()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)

        window.rootViewController = homeCoord.makeStartingController()

        self.window = window
        window.makeKeyAndVisible()

        setupLifetimeTracker()

        homeCoord.start()

        return true
    }

    private func setupLifetimeTracker() {
        LifetimeTracker.setup(onUpdate: LifetimeTrackerDashboardIntegration(visibility: .alwaysVisible, style: .circular).refreshUI)
    }
}
