//
//  ProximiteMapViewController.swift
//  Noctambus
//
//  Created by Luca Falvo on 23.04.16.
//  Copyright © 2016 Noctambus. All rights reserved.
//
import MapKit
import UIKit
import Parse
import KVNProgress

class ProximiteMapViewController: UIViewController, MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate,  CLLocationManagerDelegate {
    
    @IBOutlet weak var arretMapView: MKMapView!
    var arretAPlacer:[PFObject]!
    var arretP = [ArretsPhysique]()
    var test = NSMutableArray()
    let locationManager = CLLocationManager()
    var locationFound = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        arretMapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if arretAPlacer != nil{
            locationFound = true
            locationManager.startUpdatingLocation()
            placerArret(arretAPlacer)
        }else{
            checklocalisation()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func findMyPos(sender: AnyObject) {
        locationFound = false
        checklocalisation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        //print("didupadate")
        let location = locations.last! as CLLocation
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015))
        self.arretMapView.setRegion(region, animated: true)
        locationManager.stopUpdatingLocation()
        arretMapView.showsUserLocation = true
        
        if locationFound == false{
            KVNProgress.showWithStatus("Localisation en cours")
            searchArret(location)
        }
    }
    
    
    func checklocalisation(){
        if CLLocationManager.locationServicesEnabled(){
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
    
    func placerArret(arret : [PFObject]){
        
        for object in arret   {
            let place = object["Coordonnees"] as! PFGeoPoint
            let lignes = object["Lignes"] as! NSMutableArray
            let codeC = object["CodeArretC"] as! String
            let codeP = object["CodeArretPhysique"] as! String
            let nomArretP = object["nomArretP"] as! String
            
            let unArret = ArretsPhysique(CodeArretC: codeC, CodeArretPhysique: codeP, nomArretP: nomArretP, Lignes: lignes, Coordonnees: place)
            self.arretP.append(unArret)
            
            let haut = (lignes.count+1)*40
            
            let tableView =   UITableView()
            //tableView = UITableView(frame: UIScreen.mainScreen().bounds, style: UITableViewStyle.Plain)
            tableView.frame = CGRect(x: 0, y: 0, width: 250, height: haut)
            tableView.dataSource = self
            tableView.delegate = self
            tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
            tableView.separatorStyle = .None
            tableView.scrollEnabled = false
            tableView.allowsSelection = false
            tableView.rowHeight = 40
            let nib = UINib(nibName: "annotationTableViewCell", bundle: nil)
            tableView.registerNib(nib, forCellReuseIdentifier: "cell")
            
            //creer une annotation avec les points gps pour chaque arrets
            let cc = CLLocationCoordinate2D(latitude: place.latitude,longitude: place.longitude)
            let anotation = ArretsAnnotation(coordinate: cc, lignes: lignes,tbv: tableView)
            anotation.title = nomArretP
            self.arretMapView.addAnnotation(anotation)
        }
        
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        // If annotation is not of type RestaurantAnnotation (MKUserLocation types for instance), return nil
        if !(annotation is ArretsAnnotation){
            return nil
        }
        
        var annotationView = self.arretMapView.dequeueReusableAnnotationViewWithIdentifier("Pin")
        
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
        
        let hauteur = ((arretAnnotation.lignes.count+1) * 40)
        let visualH = "V:[snapshotView(\(hauteur))]"
        let snapshotView = UIView()
        let views = ["snapshotView": snapshotView]
        //largeur
        snapshotView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[snapshotView(250)]", options: [], metrics: nil, views: views))
        //hauteur
        snapshotView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(visualH, options: [], metrics: nil, views: views))
        
        tbvA.reloadData()
        
        snapshotView.addSubview(tbvA)
        
        annotationView?.detailCalloutAccessoryView = snapshotView
        
        return annotationView
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell    {
        let cell:annotationTableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! annotationTableViewCell
        cell.destinationLabel.text = test[indexPath.row].objectForKey("destinationName") as? String
        cell.logoImageView.image = UIImage(named: test[indexPath.row].objectForKey("lineCode") as! String)
        
        return cell;
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        if let annotation = view.annotation as? ArretsAnnotation {
            test = annotation.lignes
            annotation.tbv.reloadData()
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return test.count
    }
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print("Errors: " + error.localizedDescription)
    }
    
    func searchArret(location : CLLocation){
        //on supprime les annotations existante pour placer les nouvelles
        self.arretMapView.removeAnnotations(self.arretMapView.annotations)
        let geoPoint = PFGeoPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let query: PFQuery = PFQuery(className: "ArretsPhysique")
        query.whereKey("Coordonnees", nearGeoPoint: geoPoint, withinKilometers: 0.6)
        query.fromLocalDatastore()
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if (error == nil) {
                self.placerArret(objects!)
            }else{
                print(error)
            }
            //LA
            dispatch_async(dispatch_get_main_queue()) {
                KVNProgress.dismiss()
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status{
        case .AuthorizedWhenInUse, .AuthorizedAlways:
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
