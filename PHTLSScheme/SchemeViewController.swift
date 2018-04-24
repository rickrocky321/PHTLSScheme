//
//  ViewController.swift
//  PHTLSScheme
//
//  Created by Tilon on 21/03/2018.
//  Copyright © 2018 Tilon. All rights reserved.
//

import UIKit

class SchemeViewController: UIViewController {
    
    // View option buttons array
    @IBOutlet var optionButtons: [UIButton]!
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var stepsScrollView: UIScrollView!
    var scheme: SchemeLibrary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Options arn't genretaed when the SchemeLibrary is first accesed
        scheme?.generateOptions()
        updateViewFromModel()
        
        if scheme == nil {
            print("scheme is nil")
        }
    }
    
    @IBAction func optionClicked(_ sender: UIButton) {
        if scheme?.currentCorrectOption == optionButtons.index(of: sender) {
            nextStepInSchemeLibrary()
        }
    }
    
    @IBAction func nextStepButtonClicked(_ sender: UIButton) {
        nextStepInSchemeLibrary()
    }
    
    func nextStepInSchemeLibrary() {
        if let scheme = scheme {
            if scheme.currentStepString != "" {
                var textToAdd = "\(stepsLabel.text!)\n"
                for _ in 0...scheme.currentPlatous {
                    textToAdd += "        "
                }
                textToAdd += "\(scheme.currentStepString)"
                stepsLabel.text = textToAdd
            }
            scheme.nextStep()
            if scheme.isFinished {
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
            button.titleLabel?.textAlignment = NSTextAlignment.center
            button.setTitle(scheme?.currentOptions[index], for: UIControlState.normal)
        }
        self.title = scheme?.currentFatherPlatousString
        changeViewByPlatous(platous: scheme?.currentPlatous)
    }
    
    func changeViewByPlatous(platous: Int?) {
        if let platous = platous {
            switch platous {
            case 0:
                self.view.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
            case 1:
                self.view.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
            default:
                self.view.backgroundColor = #colorLiteral(red: 0.6309476495, green: 0.808812499, blue: 0.8660791516, alpha: 1)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        stepsScrollView.contentOffset = CGPoint(x: stepsScrollView.contentSize.width - stepsScrollView.bounds.width,
                                                y: stepsScrollView.contentSize.height - stepsScrollView.bounds.height)
    }
}
