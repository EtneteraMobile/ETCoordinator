//
//  BaseCoordinator.swift
//
//  Created by Jan Čislinský on 21. 05. 2019.
//  Copyright © 2019 Etnetera a. s. All rights reserved.
//

import Foundation
import UIKit

open class BaseCoordinator<RouterType: Router>: StoppableCoordinator, IdentifiableCoordinator {
    // MARK: - Properties
    // MARK: public

    public let identity: String = UUID().uuidString
    public var isFinished: Bool = false
    public var children: [StoppableCoordinator & IdentifiableCoordinator] = []
    public let router = RouterType()

    // MARK: private

    /// Switch that determines that coordinator was already stopped.
    ///
    /// It protects from multiple `stop` calls (like from `didFinish` in
    /// subcoordinator – self triggers `stop` and call `stop` on all subcoordinators,
    /// but someone has in didFinish [supercoordinator stop])
    private var isStopped: Bool = false

    private var didFinishCompletions: [() -> Void] = []

    // MARK: - Initialization

    public init() {
        router.starter.didFinishWithGesture = { [weak self] in
            self?.finished()
        }
    }

    // MARK: - Actions
    // MARK: public

    open func makeStartingController() -> UIViewController {
        fatalError("Implement `makeStartingController()` in child.")
    }

    open func stop(animated: Bool, completion: (() -> Void)?) {
        dispatchPrecondition(condition: .onQueue(DispatchQueue.main))
        guard isStopped == false else {
            assertionFailure("Unable to stop alredy stopped coordinator (\(self.identification))")
            Logger.info("Unable to stop alredy stopped coordinator (\(self.identification))")
            return
        }
        Logger.log("stop \(self.identification)")
        isStopped = true
        router.starter.didFinishWithGesture = nil
        if router.isStarted {
            Logger.log("router is started, \(self.identification)")
            router.stop(animated: animated) {
                // Retains strongly otherwise is self nil and `finished` is never called
                self.finished()
                // … and release self
                completion?()
            }
        } else {
            Logger.log("router is NOT started, \(self.identification)")
            finished()
            completion?()
        }
    }

    open func stopChildren(animated: Bool, completion: @escaping () -> Void) {
        guard children.isEmpty == false else {
            completion()
            return
        }
        Logger.log("stopChildren of:\n\(self.description)")
        let group = DispatchGroup()
        children
            .reversed()
            .forEach { coord in
                group.enter()
                coord.stop(animated: animated) {
                    group.leave()
                }
            }
        DispatchQueue.global().async {
            _ = group.wait(timeout: .now() + 0.3)
            DispatchQueue.main.sync {
                completion()
            }
        }
    }

    open func addChild(_ coord: StoppableCoordinator & IdentifiableCoordinator) {
        dispatchPrecondition(condition: .onQueue(DispatchQueue.main))

        guard contains(array: children, element: coord) == false else {
            assertionFailure("Unable to addChild that is alredy added. New child: (\(coord.identification))")
            Logger.info("Unable to addChild that is alredy added. New child: (\(coord.identification))")
            return
        }

        Logger.log("addChild \(coord.identification)")
        children.append(coord)

        coord.addDidFinish { [weak self, unowned finishedCoord = coord] in
            self?.removeChild(finishedCoord)
        }

        Logger.log("Children added to:\n\(self.description)")
    }

    private func removeChild(_ coord: StoppableCoordinator & IdentifiableCoordinator) {
        let childIdentification = coord.identification
        Logger.log("removeChild \(childIdentification)")
        remove(element: coord, from: &children)
        Logger.log("Children remove from:\n\(self.description)")
    }

    open func finished() {
        dispatchPrecondition(condition: .onQueue(DispatchQueue.main))
        Logger.log("Finished \(self.identification)")

        guard isFinished == false else {
            assertionFailure("Unable to finish alredy finished coordinator (\(self.identification))")
            Logger.info("Unable to finish alredy finished coordinator (\(self.identification))")
            return
        }

        isFinished = true
        stopChildren()
    }

    /// Registers didFinish block to coordinator. There can be multiple didFinish blocks.
    open func addDidFinish(completion: @escaping () -> Void) {
        dispatchPrecondition(condition: .onQueue(DispatchQueue.main))
        Logger.log("addDidFinish \(self.identification)")
        didFinishCompletions.append(completion)
    }

    // MARK: private

    private func stopChildren() {
        guard children.isEmpty == false else {
            notifyFinishListeners()
            return
        }
        Logger.log("stopChildren of \(self.identification)")

        let group = DispatchGroup()
        children.forEach { coord in
            group.enter()
            if router.isStarted {
                // Calls only finished, because `self.stop` hides all VCs controlled by subcoordinators
                // but only if self `isStarted`
                coord.finished()
                group.leave()
            } else {
                // If self isn't started stops all subcoordinator
                coord.stop(animated: true) {
                    group.leave()
                }
            }
        }

        // Waits for all coordinators to did finish
        group.notify(queue: .main) { [weak self] in
            if let sSelf = self {
                Logger.log("children stopped \(sSelf.identification)")
                sSelf.notifyFinishListeners()
            }
        }
    }

    private func notifyFinishListeners() {
        guard didFinishCompletions.isEmpty == false else {
            return
        }
        let completions = didFinishCompletions
        // Removes didFinish block to prevent future repeated calls
        didFinishCompletions = []

        Logger.log("notifyFinishListeners of \(self.identification)")
        completions.forEach { didFinish in
            didFinish()
        }
    }
}

// MARK: - Helpers

extension IdentifiableCoordinator {
    /// Identification of self. Returns `type(of: self)` with `identity`.
    public var identification: String {
        return "\(String(reflecting: type(of: self))), identity: \(identity)"
    }
}

extension BaseCoordinator: CustomStringConvertible {
    public var description: String {
        return """
        == \(self.identification) ==
        isStopped: \(isStopped), isFinished: \(isFinished)
        presenter: \(router)
        children:
        \(children.map { $0.identification }.joined(separator: "\n"))
        ====
        """
    }
}

// MARK: - Helpers

private func contains(array: [StoppableCoordinator & IdentifiableCoordinator], element coord: IdentifiableCoordinator) -> Bool {
    return array.contains(where: { $0.identity == coord.identity })
}

private func remove(element coord: IdentifiableCoordinator, from: inout [StoppableCoordinator & IdentifiableCoordinator]) {
    if let idx = from.firstIndex(where: { $0.identity == coord.identity }) {
        from.remove(at: idx)
    }
    assert(contains(array: from, element: coord) == false, "Contains coordinator after removal.")
}
