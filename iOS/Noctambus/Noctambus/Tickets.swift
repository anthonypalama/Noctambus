//
//  Tickets.swift
//  Noctambus
//
//  Created by Luca Falvo on 17.10.15.
//  Copyright © 2015 Noctambus. All rights reserved.
//

import UIKit

class Tickets {
    // MARK: Properties
    
    var code: String
    var name: String
    var description : String
    var prix : Double
    var logo: UIImage?
  
    
    // MARK: Initialization
    
    init?(code: String, name: String, description: String, prix: Double, logo: UIImage?) {
        // Initialize stored properties.
        self.code = code
        self.name = name
        self.description = description
        self.prix = prix
        self.logo = logo
       
        // Initialization should fail if there is no name or if the rating is negative.
        if name.isEmpty {
            return nil
        }
    }
    
}

