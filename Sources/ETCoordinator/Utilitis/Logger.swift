//
//  Logger.swift
//  nn2
//
//  Created by Jan Čislinský on 20. 04. 2019.
//  Copyright © 2019 Jan Cislinsky. All rights reserved.
//

import Foundation
import os

private let subsystem = "cz.etnetera.ETCoordinator"

private final class Log: CustomStringConvertible {
    public let icon: String
    public let desc: String
    public let function: String
    public let line: Int
    public let fileName: String

    public init(_ icon: String, _ desc: String, function: String = #function, line: Int = #line, file: String = #file) {
        self.icon = icon
        self.desc = desc
        self.function = function
        self.line = line
        // swiftlint:disable:next force_unwrapping
        self.fileName = file.components(separatedBy: "/").last!.replacingOccurrences(of: ".swift", with: "")
    }

    var description: String {
        return "\(function):\(line) \(icon) \(desc)"
    }
}

final class Logger {
    /// Use this level for frequent and detailed logs when debugging an issue.
    /// This level isn’t meant for production code and will not show in any log
    /// output without a configuration change.
    class func debug(_ message: String, _ file: String = #file, _ function: String = #function, line: Int = #line) {
        let log = Log("✅", message, function: function, line: line, file: file)
        os_log("%@", log: OSLog(subsystem: subsystem, category: log.fileName), type: .debug, log.description)
    }

    /// Use this level for standard log messages. The logging system stores
    /// these logs in memory and moves them to disk when it reaches a limit.
    class func log(_ message: String, _ file: String = #file, _ function: String = #function, line: Int = #line) {
        let log = Log("👉🏻", message, function: function, line: line, file: file)
        os_log("%@", log: OSLog(subsystem: subsystem, category: log.fileName), type: .default, log.description)
    }

    /// Meant for capturing background information that might help during
    /// troubleshooting an issue, this level is not moved to disk immediately.
    /// A Fault-level log will cause Info-level logs to move to disk.
    class func info(_ message: String, _ file: String = #file, _ function: String = #function, line: Int = #line) {
        let log = Log("ℹ️", message, function: function, line: line, file: file)
        os_log("%@", log: OSLog(subsystem: subsystem, category: log.fileName), type: .info, log.description)
    }

    /// You use this level when something goes wrong in your app. The logging
    /// system always saves these logs to disk.
    class func error(_ message: String, _ file: String = #file, _ function: String = #function, line: Int = #line) {
        let log = Log("‼️", message, function: function, line: line, file: file)
        os_log("%@", log: OSLog(subsystem: subsystem, category: log.fileName), type: .error, log.description)
    }

    /// This indicates that something has gone wrong on the system level, such
    /// as a device running out of storage. This level is always saved to disk.
    class func fault(_ message: String, _ file: String = #file, _ function: String = #function, line: Int = #line) {
        let log = Log("🛑", message, function: function, line: line, file: file)
        os_log("%@", log: OSLog(subsystem: subsystem, category: log.fileName), type: .fault, log.description)
    }
}
