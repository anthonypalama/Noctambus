//
//  firstLastStepTableViewCell.swift
//  Noctambus
//
//  Created by Luca Falvo on 10.02.16.
//  Copyright © 2016 Noctambus. All rights reserved.
//

import UIKit

class firstLastStepTableViewCell: UITableViewCell {

    @IBOutlet weak var departTimeLabel: UILabel!
    @IBOutlet weak var startFinishImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
