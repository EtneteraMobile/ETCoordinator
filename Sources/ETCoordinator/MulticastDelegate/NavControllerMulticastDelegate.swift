//
//  NavControllerMulticastDelegate.swift
//
//  Created by Jan Čislinský on 15/08/2017.
//  Copyright © 2017 Etnetera, a.s. All rights reserved.
//

import Foundation
import UIKit

open class NavControllerMulticastDelegate: MulticastDelegate<UINavigationControllerDelegate>, UINavigationControllerDelegate {

    // MARK: - Variables

    /// Source delegate
    final let source: Weak<UINavigationControllerDelegate>?

    // MARK: - Initialization

    /// Initializes multicast delegate for NavigationController that has one optional source delegate for functions
    /// that have return value and others delegates that are called at time of delegate is triggered.
    ///
    ///  If source delegate is nil, the first other delegate is used as source.
    ///
    /// - Note: Delegates are triggered in order in which they are added.
    /// - Note: Source delegate is trigger for all functions.
    ///
    public init(source: UINavigationControllerDelegate?, others: [UINavigationControllerDelegate]) {
        self.source = source != nil ? Weak(value: source!) : nil // swiftlint:disable:this force_unwrapping
        super.init()
        if let source = source {
            add(source)
        }
        others.forEach { self.add($0) }
    }

    // MARK: - Delegate implementation

    open func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController,
        animated: Bool
    ) {
        for delegate in delegates {
            delegate.value?.navigationController?(navigationController,
                                                  willShow: viewController,
                                                  animated: animated)
        }
    }

    open func navigationController(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController,
        animated: Bool
    ) {
        for delegate in delegates {
            delegate.value?.navigationController?(navigationController,
                                                  didShow: viewController,
                                                  animated: animated)
        }
    }

    open func navigationControllerSupportedInterfaceOrientations(
        _ navigationController: UINavigationController
    ) -> UIInterfaceOrientationMask {
        return perform(defaultValue: .all) {
            $0.navigationControllerSupportedInterfaceOrientations?(navigationController)
        }
    }

    open func navigationControllerPreferredInterfaceOrientationForPresentation(
        _ navigationController: UINavigationController
    ) -> UIInterfaceOrientation {
        return perform(defaultValue: .portrait) {
            $0.navigationControllerPreferredInterfaceOrientationForPresentation?(navigationController)
        }
    }

    open func navigationController(
        _ navigationController: UINavigationController,
        interactionControllerFor animationController: UIViewControllerAnimatedTransitioning
    ) -> UIViewControllerInteractiveTransitioning? {
        return perform(defaultValue: nil) {
            $0.navigationController?(navigationController, interactionControllerFor: animationController)
        }
    }

    open func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return perform(defaultValue: nil) {
            $0.navigationController?(navigationController, animationControllerFor: operation, from: fromVC, to: toVC)
        }
    }

    // MARK: private

    fileprivate func perform<R>(defaultValue: R, execute: (UINavigationControllerDelegate) -> R?) -> R {
        let value: UINavigationControllerDelegate?
        if let sourceDelegateValue = source?.value {
            value = sourceDelegateValue
        } else if let firstOtherDelegateValue = delegates.first?.value {
            value = firstOtherDelegateValue
        } else {
            value = nil
        }

        guard let val = value else {
            return defaultValue
        }
        return execute(val) ?? defaultValue
    }
}
