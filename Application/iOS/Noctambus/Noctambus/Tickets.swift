//
//  Tickets.swift
//  Noctambus
//
//  Created by Luca Falvo on 17.10.15.
//  Copyright © 2015 Noctambus. All rights reserved.
//

import UIKit
import Foundation

class Tickets : PFObject, PFSubclassing{
    // MARK: Properties
   @NSManaged var code: String
    @NSManaged var name: String
    @NSManaged var descriptionT : String
    @NSManaged var prix : Double
    @NSManaged var namelogo: String
    
    static let numTelSMS = "788"
  
    
    override class func initialize() {
        var onceToken: dispatch_once_t = 0
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    // MARK: Initialization
    init(code: String, name: String, descriptionT: String, prix: Double, namelogo: String) {
        // Initialize stored properties.
        super.init()
        self.code = code
        self.name = name
        self.descriptionT = descriptionT
        self.prix = prix
        self.namelogo = namelogo
       
    }
    
    override class func query() -> PFQuery? {
        let query = PFQuery(className: Tickets.parseClassName()) //1
        return query
    }
    
    class func parseClassName() -> String {
        return "Tickets"
    }
    
    override init() {
        super.init()
    }
}

