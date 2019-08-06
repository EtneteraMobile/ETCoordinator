//
//  Presentable.swift
//
//  Created by Jan Čislinský on 21. 05. 2019.
//  Copyright © 2019 Etnetera a. s. All rights reserved.
//

import Foundation
import UIKit

public protocol Presentable {
    func start(presentFrom: UIViewController, animated: Bool, completion: (() -> Void)?)
}

public extension Presentable where Self: Coordinator {
    func start(presentFrom: UIViewController, animated: Bool, completion: (() -> Void)?) {
        router.starter.start(vc: makeStartingController(), presentFrom: presentFrom, animated: animated, completion: completion)
    }
}

public extension Presentable where Self: PushingCoordinator {
    func start(presentFrom: UIViewController, animated: Bool, completion: (() -> Void)?) {
        let nc = makeNavigationController()
        nc.viewControllers = [makeStartingController()]
        router.starter.start(nc: nc, presentFrom: presentFrom, animated: animated, completion: completion)
    }
}
