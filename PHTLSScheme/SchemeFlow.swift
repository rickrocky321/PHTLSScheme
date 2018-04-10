//
//  SchemeGame.swift
//  PHTLSScheme
//
//  Created by Tilon on 21/03/2018.
//  Copyright © 2018 Tilon. All rights reserved.
//

import Foundation

class SchemeFlow {
    let numOfOptions: Int
    let numOfSteps: Int
    
    var currentStep = 0 {
        didSet {
            currentCorrect = numOfOptions.arc4random
        }
    }
    
    var currentOptions = [Int]()
    lazy var currentCorrect = numOfOptions.arc4random
    
    var isFinished: Bool {
        get {
            return (currentStep>=numOfSteps)
        }
    }
    
    // Initialize with amount of options in view
    init (numOfSteps: Int, numOfOptions: Int) {
        assert(numOfSteps >= numOfOptions, "numOfSteps has to be at least as long as the numOfOptions")
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
                var randomPosition = numOfSteps.arc4random
                while currentOptions.contains(randomPosition) || randomPosition == currentStep {
                    randomPosition = numOfSteps.arc4random
                }
                currentOptions[index] = randomPosition
                //print(currentOptions)
            }
        }
    }
    
    func stepUp() {
        // Increase step and put it in a random option, and generate the other options
        currentStep += 1
        generateOptions()
    }
    
}

//extension Int {
//    var arc4random: Int {
//        if self > 0 {
//            return Int(arc4random_uniform(UInt32(self)))
//        } else if self < 0 {
//            return -Int(arc4random_uniform(UInt32(-self)))
//        } else {
//            return 0
//        }
//    }
//}

