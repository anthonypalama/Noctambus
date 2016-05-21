//
//  ArretsPhysique.swift
//  Noctambus
//
//  Created by Luca Falvo on 08.03.16.
//  Copyright © 2016 Noctambus. All rights reserved.
//


import UIKit
import Foundation
import Parse

class ArretsPhysique : PFObject, PFSubclassing{
    // MARK: Properties
    @NSManaged var CodeArretC: String
    @NSManaged var CodeArretPhysique: String
    @NSManaged var nomArretP: String
    @NSManaged var Lignes: NSMutableArray
    @NSManaged var Coordonnees : PFGeoPoint
    
    override class func initialize() {
        var onceToken: dispatch_once_t = 0
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    // MARK: Initialization
    init(CodeArretC: String, CodeArretPhysique: String, nomArretP: String, Lignes:NSMutableArray, Coordonnees: PFGeoPoint) {
        // Initialize stored properties.
        super.init()
        self.CodeArretC = CodeArretC
        self.CodeArretPhysique = CodeArretPhysique
        self.nomArretP = nomArretP
        self.Lignes = Lignes
        self.Coordonnees = Coordonnees
    }
    
    override class func query() -> PFQuery? {
        let query = PFQuery(className: ArretsPhysique.parseClassName()) //1
        query.limit = 1000
        return query
    }
    
    class func parseClassName() -> String {
        return "ArretsPhysique"
    }
    
    override init() {
        super.init()
    }
}

