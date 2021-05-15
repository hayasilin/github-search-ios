//
//  Logger.swift
//  GithubSearch
//
//  Created by kuanwei on 2021/5/15.
//

import Foundation

struct Logger {
    enum LogLevel: String {
        case error = "‼️" // error events that might still allow the application to continue running.
        case info = "ℹ️" // informational messages that highlight the progress of the application at coarse-grained level.
        case debug = "💬" // fine-grained informational events that are most useful to debug an application.
        case verbose = "🔬" // finer-grained informational events than the DEBUG.
        case warn = "⚠️" // potentially harmful situations.
        case severe = "🔥" // very severe error events that will presumably lead the application to abort.
    }

    static func log(_ message: @autoclosure () -> String, level: LogLevel) {
        #if DEBUG || targetEnvironment(simulator)
        debugPrint("\(level.rawValue) -> \(message())")
        #endif
    }
}
