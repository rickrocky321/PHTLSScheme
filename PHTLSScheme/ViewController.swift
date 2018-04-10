//
//  ViewController.swift
//  PHTLSScheme
//
//  Created by Tilon on 21/03/2018.
//  Copyright © 2018 Tilon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // View option buttons array
    @IBOutlet var optionButtons: [UIButton]!

    override func viewDidLoad() {
        super.viewDidLoad()
        //todo: add function that accepts a json/xml and outputs the correct format to SchemeLibrary
        
        // Options arn't genretaed when the SchemeLibrary is first accesed
        SchemeLibrary.generateOptions()
        updateViewFromModel()
    }
    
    @IBAction func optionClicked(_ sender: UIButton) {
        if SchemeLibrary.currentCorrectOption == optionButtons.index(of: sender) {
            SchemeLibrary.nextStep()
            if SchemeLibrary.isFinished {
                performSegue(withIdentifier: "showSuccessViewController", sender: self)
            } else {
                updateViewFromModel()
            }
        }

    }
    
    func updateViewFromModel() {
        for index in optionButtons.indices {
            let button = optionButtons[index]
            // Set title to button from library by using game option number
            button.setTitle(SchemeLibrary.currentOptions[index], for: UIControlState.normal)
        }
    }
}
