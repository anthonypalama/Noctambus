//
//  ArretsAnnotation.swift
//  Noctambus
//
//  Created by Luca Falvo on 11.03.16.
//  Copyright © 2016 Noctambus. All rights reserved.
//

import UIKit
import MapKit

class ArretsAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var lignes : NSMutableArray
    var tbv : UITableView
    
    init(coordinate: CLLocationCoordinate2D, lignes : NSMutableArray, tbv : UITableView) {
        self.coordinate = coordinate
        self.lignes = lignes
        self.tbv = tbv

    }
}