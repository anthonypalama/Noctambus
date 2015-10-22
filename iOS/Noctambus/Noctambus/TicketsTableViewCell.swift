//
//  TicketsTableViewCell.swift
//  Noctambus
//
//  Created by Luca Falvo on 17.10.15.
//  Copyright © 2015 Noctambus. All rights reserved.
//

import UIKit

class TicketsTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    @IBOutlet weak var typeLabel: UILabel!
    
    @IBOutlet weak var logoImageView: UIImageView!
   
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var prixText: UITextField!
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
