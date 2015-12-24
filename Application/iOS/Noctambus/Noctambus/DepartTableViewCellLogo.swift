//
//  DepartTableViewCellLogo.swift
//  Noctambus
//
//  Created by Luca Falvo on 09.12.15.
//  Copyright © 2015 Noctambus. All rights reserved.
//

import UIKit

class DepartTableViewCellLogo: UITableViewCell {
    
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var busImage: UIImageView!
    @IBOutlet weak var numLogoImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
