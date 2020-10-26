//
//  TimerController.swift
//  Insights
//
//  Created by Vladislav Fitc on 16/12/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

final class TimerController {

    var delay: TimeInterval {
        didSet {
            guard delay != oldValue, isActive else {
                return
            }
            setup()
        }
    }

    var isActive: Bool {
        return timer != nil
    }

    var action: (() -> Void)?

    private var timer: Timer?

    init(delay: TimeInterval, action: (() -> Void)? = .none) {
        self.delay = delay
        self.action = action
    }

    func setup() {
        self.timer?.invalidate()
        let timer = Timer.scheduledTimer(timeInterval: delay,
                                         target: self,
                                         selector: #selector(flushAction),
                                         userInfo: nil,
                                         repeats: true)
        RunLoop.main.add(timer, forMode: .default)
        self.timer = timer
    }

    func fire() {
        timer?.fire()
    }

    func invalidate() {
        timer?.invalidate()
        timer = nil
    }

    @objc private func flushAction() {
        action?()
    }

    deinit {
        timer?.invalidate()
    }

}
