//
//  CustomCoordinator.swift
//  ExampleApp
//
//  Created by Jiří Zoudun on 11/10/2020.
//  Copyright © 2020 Etnetera a. s. All rights reserved.
//

import ETCoordinator
import LifetimeTracker
import UIKit

class CustomCoordinator: PushingCoordinator, Presentable, Pushable, LifetimeTrackable {
    class var lifetimeConfiguration: LifetimeConfiguration {
        return LifetimeConfiguration(maxCount: 1, groupName: "CustomCoordinator")
    }

    override init() {
        super.init()

        trackLifetime()
    }

    override func makeStartingController() -> UIViewController {
        let detailCoordinator = DetailCoordinator()
        let vc = detailCoordinator.makeStartingController()

        addChild(detailCoordinator)

        detailCoordinator.addDidFinish { [unowned self] in
            self.stop(animated: true, completion: nil)
        }

        detailCoordinator.startedManually(with: vc)

        return vc
    }

}
