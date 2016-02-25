//
//  ArretLocalisationViewController.swift
//  Noctambus
//
//  Created by Luca Falvo on 09.12.15.
//  Copyright © 2015 Noctambus. All rights reserved.
//
import MapKit
import UIKit
import Parse
import KVNProgress

class ArretLocalisationViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var ArretMapView: MKMapView!
    @IBOutlet weak var maLocalisationButtonItem: UIBarButtonItem!
    @IBOutlet weak var nomArretLocaNavigationItem: UINavigationItem!
    
    let locationManager = CLLocationManager()
    var arretC = String()
    var nomArretC = String()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nomArretLocaNavigationItem.title = nomArretC
       nomArretLocaNavigationItem.leftBarButtonItem?.title = "salut"
        
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
        if CLLocationManager.locationServicesEnabled(){
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestWhenInUseAuthorization()
            //SwiftSpinner.show("Localisation en cours")
            KVNProgress.showWithStatus("Localisation en cours")
            self.locationManager.startUpdatingLocation()
            self.ArretMapView.showsUserLocation = true
            KVNProgress.dismiss()
        
        }else{
           print("activer service de loca")
        }

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        
        let regionRadius: CLLocationDistance = 1000
        func centerMapOnLocation(location: CLLocation) {
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                regionRadius * 2.0, regionRadius * 2.0)
            ArretMapView.setRegion(coordinateRegion, animated: true)
        }
        centerMapOnLocation(location!)
        
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print("Errors: " + error.localizedDescription)
    }
    
    func arretphyiqueparse(){
        let query: PFQuery = PFQuery(className: "ArretsPhysique")
        query.whereKey("CodeArretC", equalTo: arretC)
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if (error == nil) {
                // shuffle objects here?
                for object in objects!   {
                    let place = object["Coordonnees"] as! PFGeoPoint
                    print(place)
                    let lignes = object["Lignes"] as! NSArray
                    print(lignes[0]["lineCode"])

                    
                    let anotation = MKPointAnnotation()
                    anotation.coordinate = CLLocationCoordinate2DMake(place.latitude,place.longitude)
                    anotation.title = "The Location"
                    anotation.subtitle = "This is the location !!!"
                    self.ArretMapView.addAnnotation(anotation)
                }
            }
        }
    }

}
