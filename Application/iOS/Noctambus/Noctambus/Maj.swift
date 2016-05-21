//
//  Maj.swift
//  Noctambus
//
//  Created by Luca Falvo on 17.05.16.
//  Copyright © 2016 Noctambus. All rights reserved.
//
import UIKit
import Foundation
import Parse

class Maj : PFObject, PFSubclassing{
    // MARK: Properties
    @NSManaged var versionData : Double
    @NSManaged var versionIOS: String
    
    override class func initialize() {
        var onceToken: dispatch_once_t = 0
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    // MARK: Initialization
    init(versionData: Double, versionIOS: String) {
        // Initialize stored properties.
        super.init()
        self.versionData = versionData
        self.versionIOS = versionIOS
    }
    
    override class func query() -> PFQuery? {
        let query = PFQuery(className: Maj.parseClassName()) //1
        return query
    }
    
    class func parseClassName() -> String {
        return "Maj"
    }
    
    override init() {
        super.init()
    }
}
