//
//  Itineraire.swift
//  Noctambus
//
//  Created by Luca Falvo on 10.02.16.
//  Copyright © 2016 Noctambus. All rights reserved.
//

import Foundation

class Itineraire {
    // MARK: Properties
    var titre: String?
    var instruction: String?
    var departureTime : String?
    var arrivalTime : String?
    var lat : Double?
    var lng : Double?
    var duration : String?
    var vehicleType : String?
    var numStops : Int?
    var line : String?
    
    
    // MARK: Initialization
    
    init(titre: String?, instruction: String?, departureTime: String?, arrivalTime: String?, lat:Double?, lng:Double?, duration: String?, vehicleType: String?, numStops: Int?, line: String?) {
        // Initialize stored properties.
        self.titre = titre
        self.instruction = instruction
        self.departureTime = departureTime
        self.arrivalTime = arrivalTime
        self.lat = lat
        self.lng = lng
        self.duration = duration
        self.vehicleType = vehicleType
        self.numStops = numStops
        self.line = line
        
    }
}
