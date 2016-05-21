//
//  LignesTableViewCell.swift
//  Noctambus
//
//  Created by Luca Falvo on 19.04.16.
//  Copyright © 2016 Noctambus. All rights reserved.
//

import UIKit

class LignesTableViewCell: UITableViewCell {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var origineLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
