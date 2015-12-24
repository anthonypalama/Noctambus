//
//  Depart.swift
//  Noctambus
//
//  Created by Luca Falvo on 09.12.15.
//  Copyright © 2015 Noctambus. All rights reserved.
//

import Foundation

class Depart {
    // MARK: Properties
    
    var departureCode: String
    var waitingTime: String
    var lineCode: String
    var destinationName: String
    
    // MARK: Initialization
    
    init(departureCode: String, waitingTime: String, lineCode: String, destinationName: String) {
        // Initialize stored properties.
        self.departureCode = departureCode
        self.waitingTime = waitingTime
        self.lineCode = lineCode
        self.destinationName = destinationName
    }
    
}