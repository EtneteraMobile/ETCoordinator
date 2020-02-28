//
//  DetailCoordinator.swift
//  ExampleApp
//
//  Created by Jiří Zoudun on 21/02/2020.
//  Copyright © 2020 Etnetera a. s. All rights reserved.
//

import UIKit
import ETCoordinator

class DetailCoordinator: PushingCoordinator, Presentable, Pushable {
    override func makeStartingController() -> UIViewController {
        let vc = DetailViewController()

        vc.onCloseAction = { [unowned self] in
            self.stop(animated: true, completion: nil)
        }

        return vc
    }
}
