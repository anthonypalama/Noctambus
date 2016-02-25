//
//  stepTableViewCell.swift
//  Noctambus
//
//  Created by Luca Falvo on 10.02.16.
//  Copyright © 2016 Noctambus. All rights reserved.
//

import UIKit

class stepTableViewCell: UITableViewCell {
    
    @IBOutlet weak var departTimeLabel: UILabel!
    @IBOutlet weak var arrivalTimeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var numstopLabel: UILabel!
    @IBOutlet weak var stepImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
