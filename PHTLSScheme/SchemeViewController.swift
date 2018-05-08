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
    
    @IBOutlet weak var hourglass: UIImageView!
    @IBOutlet weak var venflon: UIImageView!
    @IBOutlet weak var timeInScorekeeperBar: TimeInScorekeeperBar!
    @IBOutlet weak var scoreInScorekeeperBar: ScoreInScorekeeperBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Changes what happens if the databse fetch completes to reseting the stepsLabel's text
        scheme?.onDatabaseFetchCompletion = {
            // Has to thread to the main becouse a UI operation accurs here
            DispatchQueue.main.async {
                self.stepsLabel.text = ""
            }
        }
        scheme?.resetSchemeLibrary()
        // Options arn't genretaed when the SchemeLibrary is first accesed
        scheme?.generateOptions()
        updateViewFromSchemeModel()
        
        animateHourglass()
    }
    
    func animateHourglass () {
        UIView.transition(with: hourglass,
                          duration: 1,
                          options: [.transitionFlipFromBottom, .curveEaseInOut],
                          animations: {},
                          completion: { [weak self] finished in self?.animateHourglass() })
    }
    func animateVenflonAddition(amount: Int) {
        for _ in 1...amount {
            
        }
    }
    
    @IBAction func optionClicked(_ sender: UIButton) {
        if scheme?.currentCorrectOption == optionButtons.index(of: sender) {
            scoreInScorekeeperBar.addScore(after: timeInScorekeeperBar.getTimeElapsedAndResetTimer())
            nextStepInSchemeLibrary()
        } else {
            // Incorrect option was clicked
            _ = timeInScorekeeperBar.getTimeElapsedAndResetTimer()
            scoreInScorekeeperBar.penelty()
        }
    }
    
    @IBAction func nextStepButtonClicked(_ sender: UIButton) { // Temporary function
        scoreInScorekeeperBar.addScore(after: timeInScorekeeperBar.getTimeElapsedAndResetTimer())
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
                updateViewFromSchemeModel()
            }
        }
    }
    
    func updateViewFromSchemeModel() {
        for index in optionButtons.indices {
            let button = optionButtons[index]
            // Set title to button from library by using game option number
            button.titleLabel?.textAlignment = NSTextAlignment.center
            button.setTitle(scheme?.currentOptions[index], for: UIControlState.normal)
        }
        self.title = scheme?.currentFatherPlatousString
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Have the scroll view look at the right buttom part of the label whenever the label changes
        stepsScrollView.contentOffset = CGPoint(x: stepsScrollView.contentSize.width - stepsScrollView.bounds.width,
                                                y: stepsScrollView.contentSize.height - stepsScrollView.bounds.height)
    }
}
