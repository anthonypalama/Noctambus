//
//  ArretsTableViewCell.swift
//  Noctambus
//
//  Created by Luca Falvo on 25.11.15.
//  Copyright © 2015 Noctambus. All rights reserved.
//

import UIKit

class ArretsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var arretNomLabel: UILabel!
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
