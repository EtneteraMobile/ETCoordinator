//
//  Utils.swift
//  ExampleApp
//
//  Created by Jiří Zoudun on 11/10/2020.
//  Copyright © 2020 Etnetera a. s. All rights reserved.
//

import Foundation

class Utils {
    class func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map { _ in letters.randomElement()! }) // swiftlint:disable:this force_unwrapping
    }
}
