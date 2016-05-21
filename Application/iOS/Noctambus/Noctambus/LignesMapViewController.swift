//
//  LignesMapViewController.swift
//  Noctambus
//
//  Created by Luca Falvo on 09.05.16.
//  Copyright © 2016 Noctambus. All rights reserved.
//

import MapKit
import UIKit
import Parse
import KVNProgress

class LignesMapViewController: UIViewController, MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    var detailLigne : [PFObject]!
    var arretL = [ArretsLigne]()
    var test = NSMutableArray()
    var mesAnnot = [ArretsAnnotation]()
    let locationManager = CLLocationManager()



   
    @IBOutlet weak var arretsLignesMapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        arretsLignesMapView.delegate = self
        placerArret(detailLigne)
    }

    
    func placerArret(arret : [PFObject]){
        for object in arret   {
            let place = object["coordonnees"] as! PFGeoPoint
            let horaires = object["horaires"] as! NSMutableArray
            let stopName = object["stopName"] as! String
            let idLignes = object["idLignes"] as! String
            let sqStartStop = object["sqStartStop"] as! Int
            
            let unArretL = ArretsLigne(idLignes: idLignes, stopName: stopName, coordonnees: place, horaires: horaires, sqStartStop: sqStartStop)
            self.arretL.append(unArretL)
            
            let haut = (horaires.count+1)*25
            
            let tableView =   UITableView()
            //tableView = UITableView(frame: UIScreen.mainScreen().bounds, style: UITableViewStyle.Plain)
            tableView.frame = CGRect(x: 0, y: 0, width: 100, height: haut)
            tableView.dataSource = self
            tableView.delegate = self
            tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
            tableView.separatorStyle = .None
            tableView.scrollEnabled = false
            tableView.allowsSelection = false
            tableView.rowHeight = 25

            //creer une annotation avec les points gps pour chaque arrets
            let cc = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
            let anotation = ArretsAnnotation(coordinate: cc, lignes: horaires, tbv: tableView)
            anotation.title = stopName
            mesAnnot.append(anotation)
            self.arretsLignesMapView.addAnnotation(anotation)
        }
        
        var points: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
        
        for annotation in mesAnnot {
            points.append(annotation.coordinate)
        }
        
        let polyline = MKPolyline(coordinates: &points, count: points.count)
        arretsLignesMapView.addOverlay(polyline)
        self.arretsLignesMapView.showAnnotations(self.arretsLignesMapView.annotations, animated: true)

        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        // If annotation is not of type RestaurantAnnotation (MKUserLocation types for instance), return nil
        if !(annotation is ArretsAnnotation){
            return nil
        }
        
        var annotationView = self.arretsLignesMapView.dequeueReusableAnnotationViewWithIdentifier("Pin")
        
        if annotationView == nil{
            let colorPin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Pin")
            colorPin.pinTintColor = UIColor(red: 10.0/255.0, green: 167.0/255.0, blue: 233.0/255.0, alpha: 1.0)
            annotationView = colorPin
            annotationView?.canShowCallout = true
        }else{
            annotationView?.annotation = annotation
        }
        
        let arretAnnotation = annotation as! ArretsAnnotation
        
        let tbvA = arretAnnotation.tbv
        
        let hauteur = ((arretAnnotation.lignes.count+1) * 25)
        let visualH = "V:[snapshotView(\(hauteur))]"
        let snapshotView = UIView()
        let views = ["snapshotView": snapshotView]
        //largeur
        snapshotView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[snapshotView(100)]", options: [], metrics: nil, views: views))
        //hauteur
        snapshotView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(visualH, options: [], metrics: nil, views: views))
        
        tbvA.reloadData()
        
        snapshotView.addSubview(tbvA)
        
        annotationView?.detailCalloutAccessoryView = snapshotView
        return annotationView
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell    {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel!.text = test[indexPath.row] as? String
        cell.textLabel?.textAlignment = .Center        
        return cell
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        if let annotation = view.annotation as? ArretsAnnotation {
            test = annotation.lignes
            annotation.tbv.reloadData()
        }
        
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        polylineRenderer.strokeColor = UIColor(red: 23.0/255.0, green: 79.0/255.0, blue: 174.0/255.0, alpha: 1.0)
            polylineRenderer.lineWidth = 4
            return polylineRenderer
        
    }
    
    
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return test.count
    }
    
    @IBAction func maPosition(sender: AnyObject) {
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
        self.arretsLignesMapView.setRegion(region, animated: true)
        locationManager.stopUpdatingLocation()
        
        arretsLignesMapView.showsUserLocation = true
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
