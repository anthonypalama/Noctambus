//
//  Arrets.swift
//  Noctambus
//
//  Created by Luca Falvo on 25.11.15.
//  Copyright © 2015 Noctambus. All rights reserved.
//

import UIKit
import Foundation
import Parse

class Arrets : PFObject, PFSubclassing{
    // MARK: Properties
    @NSManaged var codeArret: String
    @NSManaged var nomArret: String
    @NSManaged var ligneArret : [String]
    
    override class func initialize() {
        var onceToken: dispatch_once_t = 0
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    // MARK: Initialization
    init(codeArret: String, nomArret: String, ligneArret: [String]) {
        // Initialize stored properties.
        super.init()
        self.codeArret = codeArret
        self.nomArret = nomArret
        self.ligneArret = ligneArret
    }
    
    override class func query() -> PFQuery? {
        let query = PFQuery(className: Arrets.parseClassName()) //1
        query.limit = 1000
        return query
    }
    
    class func parseClassName() -> String {
        return "Arrets"
    }
    
    override init() {
        super.init()
    }
}

