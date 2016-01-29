//
//  Lignes.swift
//  Noctambus
//
//  Created by Luca Falvo on 26.12.15.
//  Copyright © 2015 Noctambus. All rights reserved.
//

import UIKit
import Foundation
import Parse


class Lignes : PFObject, PFSubclassing{
    // MARK: Properties
    @NSManaged var departName: String
    @NSManaged var destinationName: String
    @NSManaged var lineCode: String
    @NSManaged var SequenceArret : [String]
    
    override class func initialize() {
        var onceToken: dispatch_once_t = 0
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    // MARK: Initialization
    init(departName: String, destinationName: String, lineCode: String, SequenceArret: [String]) {
        // Initialize stored properties.
        super.init()
        self.departName = departName
        self.destinationName = destinationName
        self.lineCode = lineCode
        self.SequenceArret = SequenceArret
    }
    
    override class func query() -> PFQuery? {
        let query = PFQuery(className: Lignes.parseClassName()) //1
        return query
    }
    
    class func parseClassName() -> String {
        return "Lignes"
    }
    
    override init() {
        super.init()
    }
}