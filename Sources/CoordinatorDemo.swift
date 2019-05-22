//
//  CoordinatorDemo.swift
//
//  Created by Jan Čislinský on 21. 05. 2019.
//  Copyright © 2019 Etnetera a. s. All rights reserved.
//

import Foundation
import UIKit

class HomeCoord: Coordinator {
    private let window = UIWindow()
    private let rootNC = UINavigationController(rootViewController: .init())

    func start() {
        window.backgroundColor = .white
        window.rootViewController = rootNC
        window.makeKeyAndVisible()
    }

    func openDetail() {
        let coord = DetailCoord()
//        addChild(coord)
        coord.start(pushTo: rootNC, animated: true, completion: nil)
    }

    func openAccount() {
        let coord = AccountCoord()
//        addChild(coord)
        coord.start(presentFrom: rootNC, animated: true, completion: nil)
    }

    func openSearch() {
        let coord = SearchCoord()
//        addChild(coord)
        coord.start(presentFrom: rootNC, animated: true, completion: nil)
        coord.start(pushTo: rootNC, animated: true, completion: nil)

    }
}

class DetailCoord: PushingCoordinator, Pushable {
    func makeStartingController() -> UIViewController {
        let detailVC = UIViewController()
        //let detailVM =
        return detailVC
    }

    func openExtraInfo() {
        router.push(UIViewController(), animated: true)
        router.pop(animated: true)
    }

    func openSubscriptionCoord() {
        let coord = SubscriptionCoord()
//        addChild(coord)
        coord.start(pushTo: router.ncForCoordinatorPush(), animated: true, completion: nil)
    }

    func openPlayerCoord() {
        let coord = PlayerCoord()
//        addChild(coord)
        coord.start(presentFrom: router.vcForCoordinatorPresent(), animated: true, completion: nil)
    }
}

class SubscriptionCoord: Coordinator, Pushable {
    func makeStartingController() -> UIViewController {
        return UIViewController()
    }
}

class PlayerCoord: Coordinator, Presentable {
    func makeStartingController() -> UIViewController {
        return UIViewController()
    }

    func onClose() {
        stop(animated: true, completion: nil)
    }
}

class AccountCoord: PushingCoordinator, Presentable {
    func makeStartingController() -> UINavigationController {
        return UINavigationController()
    }

    func openUserInfo() {
        router.push(UIViewController(), animated: true)
        router.pop(animated: true)
    }
}

class SearchCoord: PushingCoordinator, Pushable, Presentable {
    func makeStartingController() -> UINavigationController {
        return UINavigationController()
    }
    func makeStartingController() -> UIViewController {
        return UIViewController()
    }
}

func testCoord() {
    let home = HomeCoord()
    home.start()
}
