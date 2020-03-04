//
//  Starter.swift
//
//  Created by Jan Čislinský on 21. 05. 2019.
//  Copyright © 2019 Etnetera a. s. All rights reserved.
//

import Foundation
import UIKit

open class Starter: NSObject {

    public var isStarted: Bool {
        return firstController != nil
    }
    public var didFinishWithGesture: (() -> Void)?

    internal var firstController: UIViewController!

    internal var navController: UINavigationController! {
        didSet {
            injectDelegate(to: navController)
        }
    }
    /// The view controller that is topViewController at initialization time.
    internal weak var topViewControllerOnStart: UIViewController?
    fileprivate var multicastDelegate: NavControllerMulticastDelegate? // swiftlint:disable:this weak_delegate
    internal var didStartCompletion: (vc: UIViewController, action: () -> Void)?
    internal var didStopCompletion: (() -> Void)?

    internal var isDismissing = false

    deinit {
        if navController != nil {
            extractDelegate(from: navController)
        }
    }

    open func start(vc: UIViewController, presentFrom fromController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        assert(isStarted == false, "Already started")
        dispatchPrecondition(condition: .onQueue(DispatchQueue.main))

        firstController = vc
        fromController.presentationController?.delegate = self
        fromController.present(vc, animated: animated, completion: completion)
    }

    open func start(nc: UINavigationController, presentFrom fromController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        assert(isStarted == false, "Already started")
        dispatchPrecondition(condition: .onQueue(DispatchQueue.main))

        firstController = nc
        navController = nc
        fromController.presentationController?.delegate = self
        fromController.present(nc, animated: animated, completion: completion)
    }

    open func start(vc: UIViewController, pushTo fromController: UINavigationController, animated: Bool, completion: (() -> Void)?) {
        assert(isStarted == false, "Already started")
        dispatchPrecondition(condition: .onQueue(DispatchQueue.main))

        firstController = vc
        navController = fromController
        // We need to check topViewControllerOnStart only in case of setting up a new coordinator.
        // This coordinator should be started via Starter object.
        // If we push new VC into navigation stack it should be done via Router object and not with this method.
        topViewControllerOnStart = navController.topViewController
        didStartCompletion = (vc: vc, action: {
            completion?()
        })
        fromController.pushViewController(vc, animated: animated)
    }
}

// MARK: - Navigation Controller Delegate + Injection

extension Starter: UIAdaptivePresentationControllerDelegate {
    public func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        isDismissing = true
    }

    public func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        isDismissing = false
    }


    public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        guard isStarted else {
            return
        }

        didStopWithGestureVC()
        isDismissing = false
    }
}

extension Starter: UINavigationControllerDelegate {
    @objc public func navigationController(_ nc: UINavigationController, didShow vc: UIViewController, animated: Bool) {
        guard isStarted && !isDismissing else {
            return
        }
        if let didStartCompletion = didStartCompletion, didStartCompletion.vc === vc {
            didStartCompletion.action()
            self.didStartCompletion = nil
        }
        // This is called when stoping (poping) pushed coordinator.
        if let topVC = topViewControllerOnStart, topVC === vc {
            didStopWithGestureVC()
        }
    }

    private func injectDelegate(to nc: UINavigationController) {
        if let existingDelegate = nc.delegate {
            multicastDelegate = NavControllerMulticastDelegate(source: existingDelegate, others: [self])
            nc.delegate = multicastDelegate
        } else {
            nc.delegate = self
            nc.presentationController?.delegate = self
        }
    }

    private func extractDelegate(from nc: UINavigationController) {
        if let delegate = multicastDelegate, let source = delegate.source?.value {
            nc.delegate = source
        } else {
            nc.delegate = nil
        }
    }

    private func didStopWithGestureVC() {
        didStopCompletion?()
        didFinishWithGesture?()

        // Releases escaped closures
        didStopCompletion = nil
        didFinishWithGesture = nil
    }
}
