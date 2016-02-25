//
//  routeMapsViewController.swift
//  Noctambus
//
//  Created by Luca Falvo on 17.02.16.
//  Copyright © 2016 Noctambus. All rights reserved.
//

import UIKit
import MapKit

class routeMapsViewController: UIViewController, MKMapViewDelegate {
    
    var points : String!
    var stepsAnnotation = [Itineraire]()
    var mapPolyline: MKPolyline!
    //let locationManager = CLLocationManager()
    
    @IBOutlet weak var routeMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        routeMapView.delegate = self
        
        let initialLocation = CLLocation(latitude: 46.204549, longitude: 6.142715)
        let regionRadius: CLLocationDistance = 1000
        func centerMapOnLocation(location: CLLocation) {
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
            routeMapView.setRegion(coordinateRegion, animated: true)
        }
        centerMapOnLocation(initialLocation)
        
        loadPoints()
        
        
        
    }
    
    func loadPoints(){
            print(self.points)
            self.mapPolyline = self.polyLineWithEncodedString(self.points)
            print(self.mapPolyline)
            self.routeMapView.addOverlay(self.mapPolyline)
                
        for a in stepsAnnotation{
            let anotation = MKPointAnnotation()
            anotation.coordinate = CLLocationCoordinate2D(latitude: a.lat!, longitude: a.lng!)
            anotation.title = a.titre
            anotation.subtitle = a.instruction
            routeMapView.addAnnotation(anotation)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let routeLineRenderer = MKPolylineRenderer(polyline: mapPolyline)
        routeLineRenderer.strokeColor = UIColor(red: 23.0/255.0, green: 79.0/255.0, blue: 174.0/255.0, alpha: 1.0)
        routeLineRenderer.lineWidth = 4
        return routeLineRenderer
    }
    
    func polyLineWithEncodedString(encodedString: String) -> MKPolyline{
        let coordinates: [CLLocationCoordinate2D]? = decodePolyline(encodedString)
        let pointer: UnsafeMutablePointer<CLLocationCoordinate2D> = UnsafeMutablePointer(coordinates!)
        //let arrary = Array(UnsafeBufferPointer(start: pointer, count: initalArray.count))
        let polyline = MKPolyline(coordinates: pointer, count: coordinates!.count)
        return polyline
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
