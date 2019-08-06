//
//  Pushable.swift
//
//  Created by Jan Čislinský on 21. 05. 2019.
//  Copyright © 2019 Etnetera a. s. All rights reserved.
//

import Foundation
import UIKit

public protocol Pushable {
    func start(pushTo: UINavigationController, animated: Bool, completion: (() -> Void)?)
}

public extension Pushable where Self: Coordinator {
    func start(pushTo: UINavigationController, animated: Bool, completion: (() -> Void)?) {
        router.starter.start(vc: makeStartingController(), pushTo: pushTo, animated: animated, completion: completion)
    }
}

public extension Pushable where Self: PushingCoordinator {
    func start(pushTo: UINavigationController, animated: Bool, completion: (() -> Void)?) {
        router.starter.start(vc: makeStartingController(), pushTo: pushTo, animated: animated, completion: completion)
    }
}
