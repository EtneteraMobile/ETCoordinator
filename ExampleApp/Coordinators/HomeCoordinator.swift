//
//  HomeCoordinator.swift
//  ExampleApp
//
//  Created by Jiří Zoudun on 21/02/2020.
//  Copyright © 2020 Etnetera a. s. All rights reserved.
//

import ETCoordinator
import Foundation
import UIKit

class HomeCoord: PushingCoordinator {

    deinit {
        print("HOMECOORD: Deinit")
    }

    private var rootNC: UINavigationController?

    public override func makeStartingController() -> UIViewController {
        let vc = HomeViewController()
        let nc = UINavigationController(rootViewController: vc)
        rootNC = nc

        vc.onPushAction = { [unowned self] in
            self.pushDetail()
        }

        vc.onPresentAction = { [unowned self] in
            self.presentDetail()
        }

        return nc
    }

    // Custom app specific `start`.
    func start() {
    }

    func presentDetail() {
        let coord = DetailCoordinator()

        self.addChild(coord)
        if let nc = rootNC {
            coord.start(presentFrom: nc, animated: true) {
                print("present completion")
            }
        }
    }

    func pushDetail() {
        let coord = DetailCoordinator()

        self.addChild(coord)
        if let nc = rootNC {
            coord.start(pushTo: nc, animated: true) {
                print("push completion")
            }
        }
    }
}
