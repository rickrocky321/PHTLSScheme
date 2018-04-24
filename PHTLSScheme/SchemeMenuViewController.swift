//
//  SchemeMenuViewController.swift
//  PHTLSScheme
//
//  Created by Roy Levi on 24/04/2018.
//  Copyright © 2018 Tilon. All rights reserved.
//

import UIKit

class SchemeMenuViewController: UIViewController {
    
    var scheme: SchemeLibrary?
    override func viewDidLoad() {
        super.viewDidLoad()
        scheme = SchemeLibrary()
        if scheme != nil {
            print("scheme isnt nil")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let schemeVC = segue.destination as? SchemeViewController {
            schemeVC.scheme = scheme
        }
    }
}
