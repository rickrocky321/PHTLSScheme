//
//  SchemeMenuViewController.swift
//  PHTLSScheme
//
//  Created by Roy Levi on 24/04/2018.
//  Copyright © 2018 Tilon. All rights reserved.
//

import UIKit

class SchemeMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scheme?.fatherPlatousSrings.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if scheme != nil {
            print("scheme isn't nil in the \(self.title ?? "(no title for this view controller was found)") while trying to load the TableView cells")
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "FatherPlatousStepCell", for: indexPath)
        if let fatherPlatousStepCell = cell as? FatherPlatousStepsTableViewCell {
            fatherPlatousStepCell.fatherPlatousStepLabel.text = scheme?.fatherPlatousSrings[indexPath.row] ?? ""
        }
        return cell
    }
    
    @IBOutlet weak var fatherPlatousStepsTableView: UITableView!
    
    var scheme: SchemeLibrary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fatherPlatousStepsTableView.delegate = self
        fatherPlatousStepsTableView.dataSource = self
        scheme = SchemeLibrary { [weak self] in 
            self?.fatherPlatousStepsTableView.reloadData()
            
        }
        if scheme != nil {
            print("scheme isn't nil in the \(self.title ?? "(no title for this view controller was found)")")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fatherPlatousStepsTableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let schemeVC = segue.destination as? SchemeViewController {
            schemeVC.scheme = scheme
        }
    }
}
