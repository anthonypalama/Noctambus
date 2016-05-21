//
//  routeMapsViewController.swift
//  Noctambus
//
//  Created by Luca Falvo on 17.02.16.
//  Copyright © 2016 Noctambus. All rights reserved.
//

import UIKit
import MapKit
import KVNProgress


class routeMapsViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    var points : String!
    var stepsAnnotation = [Itineraire]()
    var mapPolyline: MKPolyline!
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var routeMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        routeMapView.delegate = self
        //empeche l application de crash quand on affiche la carte si pas d itineraire generer
        if (self.points != nil && stepsAnnotation.count > 0){
            loadPoints()
        }else{
            let alert = UIAlertController(title: "", message: "Rechercher un itinéraire pour l'afficher sur la carte", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(defaultAction)
            presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    func loadPoints(){
            self.mapPolyline = self.polyLineWithEncodedString(self.points)
            self.routeMapView.addOverlay(self.mapPolyline)
        for a in stepsAnnotation{
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: a.lat!, longitude: a.lng!)
            annotation.title = a.titre
            annotation.subtitle = a.instruction
            routeMapView.addAnnotation(annotation)
        }
        
        self.routeMapView.showAnnotations(self.routeMapView.annotations, animated: true)

        
       /* let firstPointZoom = stepsAnnotation.first
        let center = CLLocationCoordinate2D(latitude: firstPointZoom!.lat!, longitude: firstPointZoom!.lng!)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.routeMapView.setRegion(region, animated: true)*/
        
        
    }
   
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        //on test si l annotation est user si oui on renvoie la default
        if (annotation is MKUserLocation){
            return nil
        }
        
        var annotationView = self.routeMapView.dequeueReusableAnnotationViewWithIdentifier("Pin")
        
        if annotationView == nil{
            let colorPin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Pin")
            colorPin.pinTintColor = UIColor(red: 10.0/255.0, green: 167.0/255.0, blue: 233.0/255.0, alpha: 1.0)
            annotationView = colorPin
            annotationView?.canShowCallout = true
        }else{
            annotationView?.annotation = annotation
        }
        
        return annotationView

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
    
    @IBAction func locateButton(sender: AnyObject) {
        if CLLocationManager.locationServicesEnabled(){
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
            let authstate = CLLocationManager.authorizationStatus()
            switch authstate {
            case .NotDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .AuthorizedWhenInUse, .AuthorizedAlways:
                KVNProgress.showWithStatus("Localisation en cours")
                locationManager.startUpdatingLocation()
            case .Denied, .Restricted:
                let alertController = UIAlertController(title: "Vous devez autoriser Noctambus à accéder à votre position.", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                let reglageAction = UIAlertAction(title: "Réglages", style: UIAlertActionStyle.Default, handler: {(alert :UIAlertAction!) in
                    UIApplication.sharedApplication().openURL(NSURL(string:UIApplicationOpenSettingsURLString)!);           })
                let annulAction = UIAlertAction(title: "Annuler", style: UIAlertActionStyle.Cancel, handler: {(alert :UIAlertAction!) in   })
                alertController.addAction(reglageAction)
                alertController.addAction(annulAction)
                presentViewController(alertController, animated: true, completion: nil)
            default:
                break
            }
        }else{
            //Service de localisation desactiver
            let alertController = UIAlertController(title: "Activez « service de localisation » pour permettre à « Noctambus » de vous localiser.", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            let settingsAction = UIAlertAction(title: "Réglages", style: UIAlertActionStyle.Default, handler: {(alert :UIAlertAction!) in
                UIApplication.sharedApplication().openURL(NSURL(string:"prefs:root=LOCATION_SERVICES")!)            })
            let cancelAction = UIAlertAction(title: "Annuler", style: UIAlertActionStyle.Cancel, handler: {(alert :UIAlertAction!) in   })
            alertController.addAction(settingsAction)
            alertController.addAction(cancelAction)
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last! as CLLocation
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.routeMapView.setRegion(region, animated: true)
        locationManager.stopUpdatingLocation()
        routeMapView.showsUserLocation = true
        KVNProgress.dismiss()
        
    }
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print("Errors: " + error.localizedDescription)
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status{
        case .AuthorizedWhenInUse, .AuthorizedAlways:
            KVNProgress.showWithStatus("Localisation en cours")
            locationManager.startUpdatingLocation()
            break
        case .Denied, .Restricted, .NotDetermined:
            //l'utisateur a refuser
            break
        default:
            break
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

}
