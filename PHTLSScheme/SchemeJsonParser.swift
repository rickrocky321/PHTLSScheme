//
//  SchemeJsonParser.swift
//  PHTLSScheme
//
//  Created by Roy Levi on 15/04/2018.
//  Copyright © 2018 Tilon. All rights reserved.
//

import Foundation
import FirebaseDatabase

class SchemeJsonParser {
    init(onCompletion: @escaping ((_ library: [[String]],_ sequence: [(Int, Int)])->Void)) {
        var databaseReference: DatabaseReference!
        databaseReference = Database.database().reference()
        let quary = databaseReference.child("PHTLSScheme")
        quary.observeSingleEvent(of: .value) { (snapshot) in
            if let value = snapshot.value as? [String:Any] {
                // Parse the PHTLSScheme key from the firebase database
                self.parser(from: value, inside: 0)
                onCompletion(self.library, self.sequence)
            } else {
                print("error reading form database")
            }
        }
    }
    
    private func parser(from step: [String:Any], inside platous: Int) {
        let stepTitle = (step["title"] ?? "No title found") as! String
        appendLibrary(with: stepTitle, at: platous-1)
        // Devide into individual [String:Any]
        for index in 1..<step.count {
            // If there is another platous in the dictionary then parse it
            if let step = step["\(index)"] as? [String:Any] {
                parser(from: step, inside: platous+1)
            } else {
                // It reached the end state of just an String value
                let stepString = (step["\(index)"] ?? "Failed to parse string") as! String
                appendLibrary(with: stepString, at: platous)
            }
        }
    }
    
    private(set) var library: [[String]] = [[]]
    private(set) var sequence: [(Int, Int)] = []
    private var currentPlatous = 0
    private var amountOfStepsInPlatous = 0
    
    private func appendLibrary(with stepString: String, at platous: Int) {
        if platous >= 0 {
            // Add an element in the library if the platous requires it
            if platous >= library.count {
                library.append([])
            }
            library[platous].append(stepString)
            
            if platous != currentPlatous {
                sequence.append((currentPlatous, amountOfStepsInPlatous))
                amountOfStepsInPlatous = 0
                currentPlatous = platous
            }
            amountOfStepsInPlatous += 1
        }
    }
}


