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


class ArretsLigne : PFObject, PFSubclassing{
    // MARK: Properties
    @NSManaged var idLignes: String
    @NSManaged var stopName: String
    @NSManaged var coordonnees: PFGeoPoint
    //@NSManaged var horaires: [String]
    @NSManaged var horaires: NSMutableArray
    @NSManaged var sqStartStop: Int

    
    override class func initialize() {
        var onceToken: dispatch_once_t = 0
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    // MARK: Initialization
    init(idLignes: String, stopName: String, coordonnees: PFGeoPoint, horaires: NSMutableArray, sqStartStop: Int) {
        // Initialize stored properties.
        super.init()
        self.idLignes = idLignes
        self.stopName = stopName
        self.coordonnees = coordonnees
        self.horaires = horaires
        self.sqStartStop = sqStartStop

    }
    
    override class func query() -> PFQuery? {
        let query = PFQuery(className: ArretsLigne.parseClassName()) //1
        query.limit = 1000
        return query
    }
    
    class func parseClassName() -> String {
        return "ArretsLigne"
    }
    
    override init() {
        super.init()
    }
}