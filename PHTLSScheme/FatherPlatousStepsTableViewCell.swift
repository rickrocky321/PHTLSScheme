//
//  FatherPlatousStepsTableViewCell.swift
//  PHTLSScheme
//
//  Created by Roy Levi on 25/04/2018.
//  Copyright © 2018 Tilon. All rights reserved.
//

import UIKit

class FatherPlatousStepsTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    @IBOutlet weak var fatherPlatousStepLabel: UILabel!
    @IBOutlet weak var fatherPlatousStepSwitch: UISwitch!
}
