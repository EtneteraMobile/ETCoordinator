//
//  PushingRouter.swift
//
//  Created by Jan Čislinský on 21. 05. 2019.
//  Copyright © 2019 Etnetera a. s. All rights reserved.
//

import Foundation
import UIKit

open class PushingRouter: Router {
    open func ncForCoordinatorPush() -> UINavigationController {
        assert(starter.navController != nil, "navController is nil. Start router and then you can call this.")
        return starter.navController!                                           // swiftlint:disable:this force_unwrapping
    }

    open override func stop(animated: Bool, completion: (() -> Void)?) {
        starter.didFinishWithGesture = nil
        if starter.firstController.presentingViewController != nil {
            // Dismisses all VC that was presented over `firstController`
            starter.firstController.presentingViewController?.dismiss(animated: animated, completion: completion)
        } else {
            starter.didStopCompletion = completion
            if let vc = starter.topViewControllerOnStart {
                starter.navController.popToViewController(vc, animated: animated)
            } else {
                assertionFailure("Router wasn't started or navControlled didn't contain topViewController on start.")
            }
        }
    }

    open func push(_ vc: UIViewController, animated: Bool) {
        assert(starter.navController != nil, "navController is nil. Start router and then you can call this.")
        starter.navController.pushViewController(vc, animated: animated)
    }

    open func pop(animated: Bool) {
        assert(starter.navController != nil, "navController is nil. Start router and then you can call this.")
        starter.navController.popViewController(animated: animated)
    }
}
