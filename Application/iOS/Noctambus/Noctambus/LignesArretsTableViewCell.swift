//
//  LignesArretsTableViewCell.swift
//  Noctambus
//
//  Created by Luca Falvo on 19.04.16.
//  Copyright © 2016 Noctambus. All rights reserved.
//

import UIKit

class LignesArretsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var stepsImageView: UIImageView!
    
    @IBOutlet weak var arretLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
