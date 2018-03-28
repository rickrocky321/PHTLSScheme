//
//  SchemeGame.swift
//  PHTLSScheme
//
//  Created by Tilon on 21/03/2018.
//  Copyright © 2018 Tilon. All rights reserved.
//

import Foundation

class SchemeGame {
    let numOfOptions: Int
    let numOfSteps: Int
    
    var currentStep = 0 {
        didSet {
            currentCorrect = Int(arc4random_uniform(UInt32(numOfOptions)))
        }
    }
    
    var currentOptions = [Int]()
    lazy var currentCorrect = Int(arc4random_uniform(UInt32(numOfOptions)))
    
    var isFinished: Bool {
        get {
            return (currentStep>=numOfSteps)
        }
    }
    
    // Initialize with amount of options in view
    init (numOfSteps: Int, numOfOptions: Int) {
        self.numOfOptions = numOfOptions
        self.numOfSteps = numOfSteps
        // Initalize currectOptions content
        generateOptions()
    }
    
    // Generate right amount of options to currentOption array with the correct step in the array
    func generateOptions() {
        currentOptions = Array(repeating: currentStep, count: numOfOptions)
        for index in 0..<numOfOptions {
            if index != currentCorrect {
                // TODO add while loop so that it won't add multiplicities, and the currentCorrect twice
                var randomPosition = Int(arc4random_uniform(UInt32(numOfSteps)))
                while currentOptions.contains(randomPosition) || randomPosition == currentStep {
                    randomPosition = Int(arc4random_uniform(UInt32(numOfSteps)))
                }
                currentOptions[index] = randomPosition
                print(currentOptions)
            }
        }
    }
    
    func stepUp() {
        // Increase step and put it in a random option, and generate the other options
        currentStep += 1
        generateOptions()
    }
    
}
