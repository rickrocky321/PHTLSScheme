//
//  LabelsInScorekeeperBar.swift
//  PHTLSScheme
//
//  Created by Roy Levi on 08/05/2018.
//  Copyright © 2018 Tilon. All rights reserved.
//

import UIKit

class TimeInScorekeeperBar: UILabel {
    
    private var startTime: TimeInterval?
    private weak var textUpdateTimer: Timer?
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        // Start timer if the label is displayed else stop it
        if window != nil {
            startTime = Date.timeIntervalSinceReferenceDate
            textUpdateTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
                if let startTime = self?.startTime {
                    let timeShown = Date.timeIntervalSinceReferenceDate - startTime
                    // Will appear as "12.4"
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

class ScoreInScorekeeperBar: UILabel {
    
    private let maxScoreToAdd = 50.0
    private let maxTimeElapsed = 5.0
    private(set) var score = 0 {
        didSet {
            if score < 0 {
                score = 0
            }
            text = String(score)
        }
    }
    private var scorePenelty = 30
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        if window != nil {
            text = String(score)
        }
    }
    
    func addScore(after timeElapsed: Double) {
        if maxTimeElapsed > timeElapsed {
            score += Int((maxTimeElapsed - timeElapsed) / maxTimeElapsed * maxScoreToAdd)
        }
    }
    
    func penelty() {
        score -= scorePenelty
    }
}
