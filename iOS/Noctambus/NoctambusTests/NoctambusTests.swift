//
//  NoctambusTests.swift
//  NoctambusTests
//
//  Created by Luca Falvo on 17.10.15.
//  Copyright © 2015 Noctambus. All rights reserved.
//

import XCTest
@testable import Noctambus

class NoctambusTests: XCTestCase {
    
    func testTicketsInitialization() {
        // Success case.
        
        let photo6 = UIImage(named: "tpg1")
        let potentialItem = Tickets(code: "tpg1", name: "Billet", description: "Plein tarif, 60', Tout Genève, zone 10", prix: 3.00, logo: photo6)!
        XCTAssertNotNil(potentialItem)
        

    }
    
    
    
}
