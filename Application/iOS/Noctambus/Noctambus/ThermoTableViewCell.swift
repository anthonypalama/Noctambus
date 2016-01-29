//
//  ThermoTableViewCell.swift
//  Noctambus
//
//  Created by Luca Falvo on 28.01.16.
//  Copyright © 2016 Noctambus. All rights reserved.
//

import UIKit

class ThermoTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var thermoImageView: UIImageView!
    @IBOutlet weak var thNomArretLabel: UILabel!
    @IBOutlet weak var arrivalTimeLabel: UILabel!

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
