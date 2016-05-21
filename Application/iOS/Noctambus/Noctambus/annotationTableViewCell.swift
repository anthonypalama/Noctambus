//
//  annotationTableViewCell.swift
//  Noctambus
//
//  Created by Luca Falvo on 16.03.16.
//  Copyright © 2016 Noctambus. All rights reserved.
//

import UIKit

class annotationTableViewCell: UITableViewCell {

    @IBOutlet weak var logoImageView: UIImageView!
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
