//
//  BaseCoordinator.swift
//
//  Created by Jan Čislinský on 21. 05. 2019.
//  Copyright © 2019 Etnetera a. s. All rights reserved.
//

import Foundation
import UIKit

open class BaseCoordinator<RouterType: Router>: IdentifiableCoordinator {
    // MARK: - Properties
    // MARK: public

    public let identity: String = UUID().uuidString
    public var isFinished: Bool = false
    public var children: [BaseCoordinator] = []
    public let router = RouterType()

    // MARK: private

    /// Switch that determines that coordinator was already stopped.
    ///
    /// It protects from multiple `stop` calls (like from `didFinish` in
    /// subcoordinator – self triggers `stop` and call `stop` on all subcoordinators,
    /// but someone has in didFinish [supercoordinator stop])
    private var isStopped: Bool = false

    private var didFinishCompletions: [(BaseCoordinator) -> Void] = []

    // MARK: - Initialization

    public init() {
        router.starter.didFinishWithGesture = { [weak self] in
            self?.finished()
        }
    }

    // MARK: - Actions
    // MARK: public

    public func stop(animated: Bool, completion: (() -> Void)?) {
        dispatchPrecondition(condition: .onQueue(DispatchQueue.main))
        guard isStopped == false else {
            assertionFailure("Unable to stop alredy stopped coordinator (\(self.identification))")
            Logger.warning("Unable to stop alredy stopped coordinator (\(self.identification))")
            return
        }
        Logger.verbose("stop \(self.identification)")
        isStopped = true
        if router.isStarted {
            Logger.verbose("router is started, \(self.identification)")
            router.stop(animated: animated) {
                // Retains strongly otherwise is self nil and `finished` is never called
                self.finished()
                // … and release self
                completion?()
            }
        } else {
            Logger.verbose("router is NOT started, \(self.identification)")
            finished()
            completion?()
        }
    }

    public func stopChildren(animated: Bool, completion: @escaping () -> Void) {
        guard children.isEmpty == false else {
            completion()
            return
        }
        Logger.verbose("stopChildren of:\n\(self.description)")
        let group = DispatchGroup()
        children
            .reversed()
            .forEach { coord in
                group.enter()
                coord.stop(animated: animated) {
                    group.leave()
                }
            }
        Dispatcher().background.async.run {
            _ = group.wait(timeout: .now() + 0.3)
            Dispatcher().main.sync.run {
                completion()
            }
        }
    }

    public func addChild(_ coord: BaseCoordinator) {
        dispatchPrecondition(condition: .onQueue(DispatchQueue.main))

        guard children.contains(coord) == false else {
            assertionFailure("Unable to addChild that is alredy added. New child: (\(coord.identification))")
            Logger.warning("Unable to addChild that is alredy added. New child: (\(coord.identification))")
            return
        }

        Logger.verbose("addChild \(coord.identification)")
        children.append(coord)

        coord.addDidFinish { [weak self] finishedCoord in
            if let sSelf = self {
                Logger.verbose("removeChild \(finishedCoord.identification)")
                sSelf.children.remove(coord: finishedCoord)
                Logger.verbose("Children remove from:\n\(sSelf.description)")
            }
        }

        Logger.verbose("Children added to:\n\(self.description)")
    }

    public func finished() {
        dispatchPrecondition(condition: .onQueue(DispatchQueue.main))
        Logger.verbose("Finished \(self.identification)")

        guard isFinished == false else {
            assertionFailure("Unable to finish alredy finished coordinator (\(self.identification))")
            Logger.warning("Unable to finish alredy finished coordinator (\(self.identification))")
            return
        }

        isFinished = true
        stopChildren()
    }

    /// Registers didFinish block to coordinator. There can be multiple didFinish blocks.
    public func addDidFinish(completion: @escaping (BaseCoordinator) -> Void) {
        dispatchPrecondition(condition: .onQueue(DispatchQueue.main))
        Logger.verbose("addDidFinish \(self.identification)")
        didFinishCompletions.append(completion)
    }

    // MARK: private

    private func stopChildren() {
        guard children.isEmpty == false else {
            notifyFinishListeners()
            return
        }

        Logger.verbose("stopChildren of \(self.identification)")

        let group = DispatchGroup()
        children.forEach { coord in
            coord.router.starter.didFinishWithGesture = nil
            group.enter()
            coord.addDidFinish { _ in
                group.leave()
            }
            if router.isStarted {
                // Calls only finished, because `self.stop` hides all VCs controlled by subcoordinators
                // but only if self `isStarted`
                coord.finished()
            } else {
                // If self isn't started stops all subcoordinator
                coord.stop(animated: true, completion: nil)
            }
        }

        // Waits for all coordinators to did finish
        group.notify(queue: .main) { [weak self] in
            if let sSelf = self {
                Logger.verbose("children stopped \(sSelf.identification)")
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

        Logger.verbose("notifyFinishListeners of \(self.identification)")
        completions.forEach { didFinish in
            didFinish(self)
        }
    }
}

// MARK: - Helpers

extension BaseCoordinator: CustomStringConvertible {
    /// Identification of self. Returns `type(of: self)` with `identity`.
    var identification: String {
        return "\(type(of: self)), identity: \(identity)"
    }

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

private extension Array where Element: IdentifiableCoordinator {
    func contains(_ coord: IdentifiableCoordinator) -> Bool {
        return contains(where: { $0.identity == coord.identity })
    }

    mutating func remove(coord: IdentifiableCoordinator) {
        if let idx = firstIndex(where: { $0.identity == coord.identity }) {
            remove(at: idx)
        }
        assert(contains(coord) == false, "Contains coordinator after removal.")
    }
}
