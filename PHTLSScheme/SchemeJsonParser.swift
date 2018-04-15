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
    init() {
        var databaseReference: DatabaseReference!
        databaseReference = Database.database().reference()
        let quary = databaseReference.child("PHTLSScheme")
        quary.observeSingleEvent(of: .value) { (snapshot) in
            if let value = snapshot.value as? [String:Any] {
                // Parse the PHTLSScheme key from the firebase database
                self.parser(from: value, inside: self.currentPlatous)
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
    private(set) var sequence: [(Int, Int)] = [(0,0)]
    private var currentPlatous = 0
    
    private func appendLibrary(with stepString: String, at platous: Int) {
        print(stepString)
        print(platous)
        if platous >= 0 {
            if platous == currentPlatous {
                
            }
        }
    }
}

