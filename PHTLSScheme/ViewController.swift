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
    let library = SchemeLibrary()
    lazy var game = SchemeGame(numOfSteps: library.library.count, numOfOptions: optionButtons.count)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        updateViewFromModel()
    }
    
    @IBAction func optionClicked(_ sender: UIButton) {
        // If correct option was clicked
        if game.currentCorrect == optionButtons.index(of: sender) {
            game.stepUp()
            if game.isFinished {
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
            button.setTitle(library.getStepInLibrary(number: game.currentOptions[index]), for: UIControlState.normal)
        }
    }
    
}
