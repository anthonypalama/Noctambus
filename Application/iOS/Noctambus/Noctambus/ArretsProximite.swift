//
//  ArretsProximite.swift
//  Noctambus
//
//  Created by Luca Falvo on 15.02.16.
//  Copyright © 2016 Noctambus. All rights reserved.
//

import Foundation

class ArretsProximite {
    // MARK: Properties
    var codeArret: String
    var nomArret: String
    var ligneArret : [String]
    var distanceArret : Double

    // MARK: Initialization
    init(codeArret: String, nomArret: String, ligneArret: [String], distanceArret : Double) {
        // Initialize stored properties.
        self.codeArret = codeArret
        self.nomArret = nomArret
        self.ligneArret = ligneArret
        self.distanceArret = distanceArret
    }

}
