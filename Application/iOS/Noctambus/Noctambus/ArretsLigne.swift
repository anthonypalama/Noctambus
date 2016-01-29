//
//  ArretsPhyisque.swift
//  Noctambus
//
//  Created by Luca Falvo on 09.12.15.
//  Copyright © 2015 Noctambus. All rights reserved.
//

import UIKit
import Foundation

class ArretsLigne {
    // MARK: Properties
    
    var codeArretP: String
    var stopName: String
    var latitude : Double
    var longitude : Double
    
    // MARK: Initialization
    
    init(codeArretP: String, stopName: String, latitude: Double, longitude: Double) {
        // Initialize stored properties.
        self.codeArretP = codeArretP
        self.stopName = stopName
        self.latitude = latitude
        self.longitude = longitude

    }
}
