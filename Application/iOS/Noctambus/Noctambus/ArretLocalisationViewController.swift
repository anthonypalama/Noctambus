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

class ArretLocalisationViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var ArretMapView: MKMapView!
    @IBOutlet weak var maLocalisationButtonItem: UIBarButtonItem!
    @IBOutlet weak var nomArretLocaNavigationItem: UINavigationItem!
    
    let locationManager = CLLocationManager()
    var arretC = String()
    var nomArretC = String()
    var arretP = [ArretsPhysique]()
    var test = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        ArretMapView.delegate = self
        nomArretLocaNavigationItem.title = nomArretC
        arretphyiqueparse()        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func MaLocalisation(sender: AnyObject) {
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
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        // If annotation is not of type RestaurantAnnotation (MKUserLocation types for instance), return nil
        if !(annotation is ArretsAnnotation){
            return nil
        }
        
        var annotationView = self.ArretMapView.dequeueReusableAnnotationViewWithIdentifier("Pin")
                
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
        //print(hauteur)
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
        let location = locations.last! as CLLocation
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.ArretMapView.setRegion(region, animated: true)
            locationManager.stopUpdatingLocation()

        ArretMapView.showsUserLocation = true
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
   
    
    
    
    func arretphyiqueparse(){
        let query: PFQuery = PFQuery(className: "ArretsPhysique")
        query.whereKey("CodeArretC", equalTo: arretC)
        query.fromLocalDatastore()
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if (error == nil) {
                // shuffle objects here?
                for object in objects!   {
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
                    
                    let cc = CLLocationCoordinate2D(latitude: place.latitude,longitude: place.longitude)
                    let anotation = ArretsAnnotation(coordinate: cc, lignes: lignes,tbv: tableView)
                    anotation.title = nomArretP
                    self.ArretMapView.addAnnotation(anotation)
                }
            }
            dispatch_async(dispatch_get_main_queue()) {
                if (self.arretP.count > 0){
                    let arrBegin = self.arretP.first
                    let location = CLLocation(latitude: arrBegin!.Coordonnees.latitude, longitude: arrBegin!.Coordonnees.longitude)
                    let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                    let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                    self.ArretMapView.setRegion(region, animated: true)
                }
                
                
                
            }
            
            
            
        }
    }
    
}
