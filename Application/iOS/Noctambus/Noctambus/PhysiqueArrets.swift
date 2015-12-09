//
//  ArretsPhyisque.swift
//  Noctambus
//
//  Created by Luca Falvo on 09.12.15.
//  Copyright © 2015 Noctambus. All rights reserved.
//

import UIKit
import Foundation

class PhyisqueArrets : PFObject, PFSubclassing{
    // MARK: Properties
    @NSManaged var codeArretC: String
    @NSManaged var CodeArretPhyisque: String
    
    override class func initialize() {
        var onceToken: dispatch_once_t = 0
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    // MARK: Initialization
    init(codeArretC: String, CodeArretPhyisque: String) {
        // Initialize stored properties.
        super.init()
        self.codeArretC = codeArretC
        self.CodeArretPhyisque = CodeArretPhyisque
    }
    
    override class func query() -> PFQuery? {
        let query = PFQuery(className: PhyisqueArrets.parseClassName()) //1
        return query
    }
    
    class func parseClassName() -> String {
        return "ArretsPhysique"
    }
    
    override init() {
        super.init()
    }
}
