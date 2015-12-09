//
//  ArretLocalisationViewController.swift
//  Noctambus
//
//  Created by Luca Falvo on 09.12.15.
//  Copyright © 2015 Noctambus. All rights reserved.
//
import MapKit
import UIKit

class ArretLocalisationViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var ArretMapView: MKMapView!
    
    let locationManager = CLLocationManager()

    @IBOutlet weak var maLocalisationButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arretphyiqueparse()
        
        let initialLocation = CLLocation(latitude: 46.204549, longitude: 6.142715)
        
        let regionRadius: CLLocationDistance = 1000
        func centerMapOnLocation(location: CLLocation) {
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                regionRadius * 2.0, regionRadius * 2.0)
            ArretMapView.setRegion(coordinateRegion, animated: true)
        }
        centerMapOnLocation(initialLocation)
        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func MaLocalisation(sender: AnyObject) {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        SwiftSpinner.show("Localisation en cours")
        self.locationManager.startUpdatingLocation()
        self.ArretMapView.showsUserLocation = true
        SwiftSpinner.hide()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func arretphyiqueparse(){
        let query: PFQuery = PFQuery(className: "ArretsPhysique")
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if (error == nil) {
                // shuffle objects here?
                for object in objects!   {
                    print(object["Coordonnees"])
                }
            }
        }
    }

}
