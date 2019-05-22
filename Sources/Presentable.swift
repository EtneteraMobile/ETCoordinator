//
//  Presentable.swift
//
//  Created by Jan Čislinský on 21. 05. 2019.
//  Copyright © 2019 Etnetera a. s. All rights reserved.
//

import Foundation
import UIKit

public protocol Presentable {}

public extension Presentable where Self: Coordinator {
    func makeStartingController() -> UIViewController {
        fatalError("Implement `makeStartingController() -> UIViewController` in your child.")
    }
    func start(presentFrom: UIViewController, animated: Bool, completion: (() -> Void)?) {
        router.starter.start(vc: makeStartingController(), presentFrom: presentFrom, animated: animated, completion: completion)
    }
}

public extension Presentable where Self: PushingCoordinator {
    func makeStartingController() -> UINavigationController {
        fatalError("Implement `makeStartingController() -> UINavigationController` in your child.")
    }
    func start(presentFrom: UIViewController, animated: Bool, completion: (() -> Void)?) {
        router.starter.start(nc: makeStartingController(), presentFrom: presentFrom, animated: animated, completion: completion)
    }
}
