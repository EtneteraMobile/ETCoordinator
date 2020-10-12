//
//  Router.swift
//
//  Created by Jan Čislinský on 21. 05. 2019.
//  Copyright © 2019 Etnetera a. s. All rights reserved.
//

import Foundation
import UIKit

open class Router: NSObject, Initializable {
    public var isStarted: Bool {
        return starter.isStarted
    }
    public var starter = Starter()

    public required override init() {}

    open func vcForCoordinatorPresent() -> UIViewController {
        assert(starter.firstController != nil, "Router wasn't started yet. Start router and then you can call this.")
        return starter.firstController! // swiftlint:disable:this force_unwrapping
    }

    open func stop(animated: Bool, completion: (() -> Void)?) {
        // Dismisses all VC that was presented over `firstController`
        if let presentingViewController = starter.firstController?.presentingViewController {
            presentingViewController.dismiss(animated: animated, completion: completion)
        } else {
            // In rare cases when the Coordinator wasn't started as a presentedViewController. We need to call completion either way.
            Logger.info("No presenting ViewController found to be stopped. Calling completion.")
            completion?()
        }
    }
}
