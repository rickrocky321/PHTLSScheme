//
//  ViewController.swift
//  PHTLSScheme
//
//  Created by Tilon on 21/03/2018.
//  Copyright © 2018 Tilon. All rights reserved.
//

import UIKit

class SchemeViewController: UIViewController, UIDynamicAnimatorDelegate {
    
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animateHourglass()
        venflonAnimator.delegate = self
    }
    
    func animateHourglass () {
        // the hourglass image will rotate once a second
        UIView.transition(with: hourglass,
                          duration: 1,
                          options: [.transitionFlipFromBottom, .curveEaseInOut],
                          animations: {},
                          completion: { [weak self] finished in self?.animateHourglass() })
    }

    lazy var venflonAnimator = UIDynamicAnimator(referenceView: view)
    var venflonImagesForAnimation: [UIImageView] = []
    var snapToVenflonImage: UISnapBehavior!
    
    func animateVenflonAddition(amount: Int, from sender: UIView) {
        // Translates the senders frame to the right random x and y point from the views refrence
        let senderFrame = view.convert(sender.frame, from: sender.superview)
        var randomXPositionFromSenderFrame: CGFloat {
            return senderFrame.origin.x + CGFloat(Int(senderFrame.width).arc4random)
        }
        var randomYPositionFromSenderFrame: CGFloat {
            return senderFrame.origin.y + CGFloat(Int(senderFrame.height).arc4random)
        }
        
        // Takes the amount of venflons images from a given button center and snap animates them the the venflon score image
        for _ in 0..<amount {
            let venflonImage = UIImageView(image: venflon.image)
            // Random  starting place within the button
            venflonImage.frame = CGRect(x: randomXPositionFromSenderFrame - (venflon.frame.width / 2),
                                        y: randomYPositionFromSenderFrame - (venflon.frame.height / 2),
                                        width: venflon.frame.width, height: venflon.frame.height)
            venflonImage.contentMode = .scaleAspectFit
            venflonImagesForAnimation.append(venflonImage)
            view.addSubview(venflonImage)
            snapToVenflonImage = UISnapBehavior.init(item: venflonImage, snapTo: view.convert(venflon.center, from: venflon.superview))
            snapToVenflonImage.damping = 1.5
            venflonAnimator.addBehavior(snapToVenflonImage)
        }
    }
    func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) {
        // Remove finished behaviors and the unnecessary venflon images from view and resets the venflonImagesForAnimation array
        animator.removeAllBehaviors()
        venflonImagesForAnimation.forEach { venflonImage in
            venflonImage.removeFromSuperview()
        }
        venflonImagesForAnimation = []
    }
    
    @IBAction func optionClicked(_ sender: UIButton) {
        if scheme?.currentCorrectOption == optionButtons.index(of: sender) {
            let scoreAdded = scoreInScorekeeperBar.addScore(after: timeInScorekeeperBar.getTimeElapsedAndResetTimer())
            animateVenflonAddition(amount: scoreAdded, from: sender)
            nextStepInSchemeLibrary()
        } else {
            // Incorrect option was clicked
            _ = timeInScorekeeperBar.getTimeElapsedAndResetTimer()
            scoreInScorekeeperBar.penelty()
        }
    }
    
    @IBAction func nextStepButtonClicked(_ sender: UIButton) { // Temporary function
        let scoreAdded = scoreInScorekeeperBar.addScore(after: timeInScorekeeperBar.getTimeElapsedAndResetTimer())
        animateVenflonAddition(amount: scoreAdded, from: sender)
        nextStepInSchemeLibrary()
        print(venflonAnimator.isRunning)
        print(venflonAnimator.behaviors)
        print(venflonImagesForAnimation)
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

extension CGFloat {
    var arc4random: CGFloat {
        return self * (CGFloat(arc4random_uniform(UInt32.max))/CGFloat(UInt32.max))
    }
}
