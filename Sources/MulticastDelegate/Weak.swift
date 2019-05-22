//
//  Weak.swift
//
//  Created by Jan Čislinský on 15/08/2017.
//  Copyright © 2017 Etnetera, a.s. All rights reserved.
//

import Foundation

open class Weak<T: AnyObject>: Equatable {
    open weak var value: T?

    public init(value: T) {
        self.value = value
    }
}

public func == <T>(lhs: Weak<T>, rhs: Weak<T>) -> Bool {
    return lhs.value === rhs.value
}
