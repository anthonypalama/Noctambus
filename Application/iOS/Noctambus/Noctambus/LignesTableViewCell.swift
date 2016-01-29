//
//  LignesTableViewCell.swift
//  Noctambus
//
//  Created by Luca Falvo on 26.12.15.
//  Copyright © 2015 Noctambus. All rights reserved.
//

import UIKit
import ParseUI

class LignesTableViewCell: PFTableViewCell {
    
    @IBOutlet weak var logoLigneImageView: UIImageView!
    @IBOutlet weak var departLabel: UILabel!
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
