//
//  DetailCoordinator.swift
//  ExampleApp
//
//  Created by Jiří Zoudun on 21/02/2020.
//  Copyright © 2020 Etnetera a. s. All rights reserved.
//

import ETCoordinator
import LifetimeTracker
import UIKit

class DetailCoordinator: PushingCoordinator, Presentable, Pushable, LifetimeTrackable {
    class var lifetimeConfiguration: LifetimeConfiguration {
        return LifetimeConfiguration(maxCount: 1, groupName: "DetailCoordinator")
    }

    override func makeStartingController() -> UIViewController {
        let vc = DetailViewController()

        vc.onCloseAction = { [unowned self] in
            self.stop(animated: true, completion: nil)
        }

        vc.onPushAction = { [unowned self] in
            let vc = DetailViewController()

            vc.onCloseAction = { [weak self] in
                self?.router.pop(animated: true)
            }

            self.router.push(vc, animated: true)
        }

        vc.onPushNewCoordAction = { [unowned self] in
            let coord = DetailCoordinator()

            self.addChild(coord)

            coord.start(pushTo: self.router.ncForCoordinatorPush(), animated: true, completion: nil)
        }

        return vc
    }
}
