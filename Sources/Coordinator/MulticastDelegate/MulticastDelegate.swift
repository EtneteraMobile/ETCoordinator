//
//  MulticastDelegate.swift
//
//  Created by Jan Čislinský on 15/08/2017.
//  Copyright © 2017 Etnetera, a.s. All rights reserved.
//

import Foundation

open class MulticastDelegate<T: AnyObject>: NSObject {
    // MARK: - Variables
    // MARK: private

    fileprivate var _delegates: [Weak<T>] = []
    var delegates: [Weak<T>] {
        get {
            // Removes dead delegates
            _delegates = _delegates.filter { $0.value != nil }
            return _delegates
        }
        set {
            _delegates = newValue
        }
    }

    // MARK: - Actions
    // MARK: public

    open func add(_ delegate: T) {
        delegates.append(Weak(value: delegate))
    }

    open func remove(_ delegate: T) {
        let weak = Weak(value: delegate)
        if let idx = delegates.firstIndex(of: weak) {
            delegates.remove(at: idx)
        }
    }
}
