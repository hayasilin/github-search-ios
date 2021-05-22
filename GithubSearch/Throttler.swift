//
//  Throttler.swift
//  GithubSearch
//
//  Created by kuanwei on 2021/5/22.
//

import Foundation

class Throttler<T> {
    private(set) var value: T? = nil
    private var valueTimestamp: Date? = nil
    private var interval: TimeInterval
    private var queue: DispatchQueue
    private var callback: ((T) -> Void)?

    init(_ interval: TimeInterval, on queue: DispatchQueue = .main) {
        self.interval = interval
        self.queue = queue
    }

    func receive(_ value: T) {
        self.value = value

        guard valueTimestamp == nil else {
            return
        }

        valueTimestamp = Date()
        queue.asyncAfter(deadline: .now() + interval) {
            self.onDispatch()
        }
    }

    func on(throttled: @escaping (T) -> ()) {
        callback = throttled
    }

    private func onDispatch() {
        self.valueTimestamp = nil
        if let value = self.value {
            callback?(value)
        }
    }
}
