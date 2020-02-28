//
//  HomeCoordinator.swift
//  ExampleApp
//
//  Created by Jiří Zoudun on 21/02/2020.
//  Copyright © 2020 Etnetera a. s. All rights reserved.
//

import Foundation
import UIKit
import ETCoordinator

class HomeCoord: PushingCoordinator {

    deinit {
        print("HOMECOORD: Deinit")
    }

    private var rootNC: UINavigationController!

    public override func makeStartingController() -> UIViewController {
        let vc = HomeViewController()
        rootNC = UINavigationController(rootViewController: vc)

        vc.onPushAction = { [unowned self] in
            // NOT IMPLEMENTED
            // self.openAccount()
        }

        vc.onPresentAction = { [unowned self] in
            self.openDetail()
        }

        return rootNC
    }

    // Custom app specific `start`.
    func start() {
    }

    func openDetail() {
        let coord = DetailCoordinator()

        self.addChild(coord)
        if let nc = rootNC {
            coord.start(presentFrom: nc, animated: true, completion: nil)
        }
    }
}
