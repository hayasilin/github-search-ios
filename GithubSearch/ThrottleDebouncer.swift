//
//  ThrottleDebouncer.swift
//  GithubSearch
//
//  Created by kuanwei on 2021/5/22.
//

import Foundation

class ThrottleDebouncer<T> {
    private(set) var value: T?
    private var valueTimestamp: Date = Date()
    private var interval: TimeInterval
    private var queue: DispatchQueue
    private var callback: ((T) -> Void)?
    private var debounceWorkItem: DispatchWorkItem = DispatchWorkItem {}

    public init(_ interval: TimeInterval, on queue: DispatchQueue = .main) {
        self.interval = interval
        self.queue = queue
    }

    public func receive(_ value: T) {
        self.value = value
        dispatchDebounce()
    }

    public func on(throttled: @escaping (T) -> ()) {
        callback = throttled
    }

    private func dispatchDebounce() {
        self.valueTimestamp = Date()

        self.debounceWorkItem.cancel()
        self.debounceWorkItem = DispatchWorkItem { [weak self] in
            self?.onDebounce()
        }

        queue.asyncAfter(deadline: .now() + interval, execute: debounceWorkItem)
    }

    private func onDebounce() {
        if (Date().timeIntervalSince(self.valueTimestamp) > interval) {
            sendValue()
        }
    }

    private func sendValue() {
        if let value = self.value {
            callback?(value)
        }
    }
}
