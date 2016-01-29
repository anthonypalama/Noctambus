//
//  ThermoA.swift
//  Noctambus
//
//  Created by Luca Falvo on 28.01.16.
//  Copyright © 2016 Noctambus. All rights reserved.
//

import Foundation

class ThermoA {
    // MARK: Properties
    
    var stopCode: String
    var stopName: String
    var arrivalTime: String
    var visible: Bool
    
    // MARK: Initialization
    
    init(stopCode: String, stopName: String, arrivalTime: String, visible: Bool) {
        // Initialize stored properties.
        self.stopCode = stopCode
        self.stopName = stopName
        self.arrivalTime = arrivalTime
        self.visible = visible
    }
    
}