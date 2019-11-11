//
//  StoppableCoordinator.swift
//  app
//
//  Created by Jan Čislinský on 10. 07. 2019.
//  Copyright © 2019 Etnetera a. s. All rights reserved.
//

import Foundation

public protocol StoppableCoordinator: AnyObject {
    func addDidFinish(completion: @escaping () -> Void)
    func stop(animated: Bool, completion: (() -> Void)?)
    func finished()
}
