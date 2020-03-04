//
//  CoordinatorDemo.swift
//
//  Created by Jan Čislinský on 21. 05. 2019.
//  Copyright © 2019 Etnetera a. s. All rights reserved.
//

import Foundation
import UIKit
import ETCoordinator

class HomeCoordDemo: Coordinator {

    private let window = UIWindow()
    private let rootNC = UINavigationController(rootViewController: .init())

    // Custom app specific `start`.
    func start() {
        window.backgroundColor = .white
        window.rootViewController = rootNC
        window.makeKeyAndVisible()
    }

    func openDetail() {
        let coord = DetailCoord()
        // Parent holds reference for its children
        addChild(coord)
        // Every coord has starting functions according to its possibilities
        // DetailCoord is Pushable
        coord.start(pushTo: rootNC, animated: true, completion: nil)
    }

    func openAccount() {
        let coord = AccountCoord()
        // Parent holds reference for its children
        addChild(coord)
        // Every coord has starting functions according to its possibilities
        // AccountCoord is Presentable
        coord.start(presentFrom: rootNC, animated: true, completion: nil)
    }

    func openSearch() {
        let coord = SearchCoord()
        // Parent holds reference for its children
        addChild(coord)
        // Every coord has starting functions according to its possibilities
        // SearchCoord is Pushable & Presentable
        coord.start(presentFrom: rootNC, animated: true, completion: nil)
        coord.start(pushTo: rootNC, animated: true, completion: nil)

    }
}

class DetailCoord: PushingCoordinator, Pushable {
    override func makeStartingController() -> UIViewController {
        // Every coordinator has to implement only this method.
        // Returns controller that has to be shown at start.
        let detailVC = UIViewController()
        return detailVC
    }

    func openExtraInfo() {
        // Horizontal navigation flow is controlled through router's `push` and `pop`.
        router.push(UIViewController(), animated: true)
        router.pop(animated: true)
    }

    func openSubscriptionCoord() {
        let coord = SubscriptionCoord()
        addChild(coord)
        // If you need NavigationController pass it through the router
        coord.start(pushTo: router.ncForCoordinatorPush(), animated: true, completion: nil)
    }

    func openPlayerCoord() {
        let coord = PlayerCoord()
        addChild(coord)
        // If you need ViewController pass it through the router
        coord.start(presentFrom: router.vcForCoordinatorPresent(), animated: true, completion: nil)
    }
}

class SubscriptionCoord: Coordinator, Pushable {
    override func makeStartingController() -> UIViewController {
        return UIViewController()
    }
}

class PlayerCoord: Coordinator, Presentable {
    override func makeStartingController() -> UIViewController {
        return UIViewController()
    }

    func onClose() {
        // If you want to dismiss controllers from navigation flow, you have to call `stop`.
        stop(animated: true, completion: nil)
    }
}

class AccountCoord: PushingCoordinator, Presentable {
    override func makeStartingController() -> UIViewController {
        return UIViewController()
    }

    override func makeNavigationController() -> UINavigationController {
        // You can return custom NavigationController for pushing.
        return UINavigationController()
    }
}

class SearchCoord: PushingCoordinator, Pushable, Presentable {
    override func makeStartingController() -> UIViewController {
        return UIViewController()
    }
}
