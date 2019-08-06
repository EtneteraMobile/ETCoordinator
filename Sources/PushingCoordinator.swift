//
//  PushingCoordinator.swift
//
//  Created by Jan Čislinský on 21. 05. 2019.
//  Copyright © 2019 Etnetera a. s. All rights reserved.
//

import Foundation
import UIKit

open class PushingCoordinator: BaseCoordinator<PushingRouter> {
    open func makeNavigationController() -> UINavigationController {
        return UINavigationController()
    }
}
