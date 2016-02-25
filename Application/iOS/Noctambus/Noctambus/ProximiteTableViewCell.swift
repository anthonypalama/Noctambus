//
//  ProximiteTableViewCell.swift
//  Noctambus
//
//  Created by Luca Falvo on 16.02.16.
//  Copyright © 2016 Noctambus. All rights reserved.
//

import UIKit

class ProximiteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var nomArretLabel: UILabel!
    @IBOutlet weak var logoIV1: UIImageView!
    @IBOutlet weak var logoIV2: UIImageView!
    @IBOutlet weak var logoIV3: UIImageView!
    @IBOutlet weak var logoIV4: UIImageView!
    @IBOutlet weak var logoIV5: UIImageView!
    @IBOutlet weak var logoIV6: UIImageView!    
    
    override func awakeFromNib() {

        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        logoIV1.image = nil
        logoIV2.image = nil
        logoIV3.image = nil
        logoIV4.image = nil
        logoIV5.image = nil
        logoIV6.image = nil
    }


}
