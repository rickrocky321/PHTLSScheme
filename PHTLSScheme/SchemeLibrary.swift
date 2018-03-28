//
//  File.swift
//  PHTLSScheme
//
//  Created by Tilon on 21/03/2018.
//  Copyright © 2018 Tilon. All rights reserved.
//

import Foundation

struct SchemeLibrary{
    
    // Library array with scheme steps
    let library = ["a",
                   "b",
                   "c",
                   "d"]
//                   "e",
//                   "f",
//                   "g",
//                   "h",
//                   "i",
//                   "j"]
    
    // Get specific step from library
    func getStepInLibrary(number index: Int) -> String {
        return library[index]
    }
}
