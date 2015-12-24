//
//  ArretsPhyisque.swift
//  Noctambus
//
//  Created by Luca Falvo on 09.12.15.
//  Copyright © 2015 Noctambus. All rights reserved.
//

import UIKit
import Foundation
import Parse

class Lignes{
    // MARK: Properties
    
    var lineCode: String
    var destinationName: String
    var destinationCode: String
    
    // MARK: Initialization
    
    init(lineCode: String, destinationName: String, destinationCode: String) {
        // Initialize stored properties.
        self.lineCode = lineCode
        self.destinationName = destinationName
        self.destinationCode = destinationCode

        
    }
}
