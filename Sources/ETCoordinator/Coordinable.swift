//
//  Coordinable.swift
//  ExampleApp
//
//  Created by Jiří Zoudun on 12/10/2020.
//  Copyright © 2020 Etnetera a. s. All rights reserved.
//

/// Coordinable protocol is a wrapper protocol for `StoppableCoordinator & IdentifiableCoordinator`.
/// This protocol is implemented by both `BaseCoordinator` and `PushingCoordinator`.
public protocol Coordinable: StoppableCoordinator, IdentifiableCoordinator {
}
