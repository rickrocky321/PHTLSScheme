//
//  TimeInScorekeeperBar.swift
//  PHTLSScheme
//
//  Created by Roy Levi on 07/05/2018.
//  Copyright © 2018 Tilon. All rights reserved.
//

import UIKit

class TimeInScorekeeperBar: UILabel {
    
    private var startTime: TimeInterval?
    private weak var textUpdateTimer: Timer?
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        if window != nil {
            startTime = Date.timeIntervalSinceReferenceDate
            textUpdateTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
                if let startTime = self?.startTime {
                    let timeShown = Date.timeIntervalSinceReferenceDate - startTime
                    self?.text = String(Double(Int(timeShown*10))/10)
                }
            }
        } else {
            textUpdateTimer?.invalidate()
        }
    }
    
    func getTimeElapsedAndResetTimer() -> Double {
        startTime = Date.timeIntervalSinceReferenceDate
        return Double(text ?? "0") ?? 0
    }
}
