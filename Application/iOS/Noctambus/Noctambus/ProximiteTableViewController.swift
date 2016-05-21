//
//  ProximiteTableViewController.swift
//  Noctambus
//
//  Created by Luca Falvo on 29.01.16.
//  Copyright © 2016 Noctambus. All rights reserved.
//

import UIKit
import Parse
import KVNProgress


class ProximiteTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    @IBOutlet var proximitetableView: UITableView!
    let locationManager = CLLocationManager()
    var arrP = [ArretsProximite]()
    var locationFound = false
    var arretMap:[PFObject]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl?.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        checkStatutsLocalisation(true)
        
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    func checkStatutsLocalisation(startOuMaj : Bool){
        if CLLocationManager.locationServicesEnabled(){
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
            let authstate = CLLocationManager.authorizationStatus()
            switch authstate {
            case .NotDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .AuthorizedWhenInUse, .AuthorizedAlways:
                if (startOuMaj == true){KVNProgress.showWithStatus("Localisation en cours")}
                locationManager.startUpdatingLocation()
            case .Denied, .Restricted:
                let alertController = UIAlertController(title: "Vous devez autoriser Noctambus à accéder à votre position.", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                let reglageAction = UIAlertAction(title: "Réglages", style: UIAlertActionStyle.Default, handler: {(alert :UIAlertAction!) in
                    UIApplication.sharedApplication().openURL(NSURL(string:UIApplicationOpenSettingsURLString)!);           })
                let annulAction = UIAlertAction(title: "Annuler", style: UIAlertActionStyle.Cancel, handler: {(alert :UIAlertAction!) in
                    self.refreshControl!.endRefreshing()
                })
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
            let cancelAction = UIAlertAction(title: "Annuler", style: UIAlertActionStyle.Cancel, handler: {(alert :UIAlertAction!) in
                self.refreshControl!.endRefreshing()
            })
            alertController.addAction(settingsAction)
            alertController.addAction(cancelAction)
            presentViewController(alertController, animated: true, completion: nil)
        }
        
    }
    
    func search(location : CLLocation){
        let geoPoint = PFGeoPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let query = ArretsPhysique.query()
        query!.whereKey("Coordonnees", nearGeoPoint: geoPoint, withinKilometers: 0.6)
        query!.fromLocalDatastore()
        query!.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if (error == nil) {
                self.arrP.removeAll()
                self.arretMap = objects as [PFObject]?
                //print(objects)
                for object in objects!  {
                    var exist = false
                    let place = object["Coordonnees"] as! PFGeoPoint
                    let placeDistance = geoPoint.distanceInKilometersTo(place)
                    for var i = 0; i < self.arrP.count; i++ {
                        //il est deja dans mon tableau alors remplacer les metres
                        if (self.arrP[i].codeArret == object["CodeArretC"] as! String){
                            //self.arrP[i].distanceArret = placeDistance
                            var line = Set<String>(self.arrP[i].ligneArret)
                            for o in object["Lignes"] as! NSArray{
                                line.insert(o.objectForKey("lineCode") as! String)
                            }
                            let arr = Array(line)
                            self.arrP[i].ligneArret = arr
                            exist = true
                        }
                    }
                    if (exist == false){
                        
                        let code = object["CodeArretC"] as! String
                        let nom = object["nomArretP"] as! String
                        var line = Set<String>()
                        for o in object["Lignes"] as! NSArray{
                            line.insert(o.objectForKey("lineCode") as! String)
                        }
                        let arr = Array(line)
                        let unArret = ArretsProximite(codeArret: code, nomArret: nom, ligneArret: arr, distanceArret: placeDistance)
                        self.arrP.append(unArret)
                    }
                }
            }else{
                print(error)
            }
            //LA
            dispatch_async(dispatch_get_main_queue()) {
                self.refreshControl!.endRefreshing()
                self.proximitetableView.reloadData()
                KVNProgress.dismiss()
                
            }
        }
        
        
        
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if locationFound == false{
            let location = locations.last
            self.locationManager.stopUpdatingLocation()
            locationFound = true
            search(location!)
        }
        
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Tble view data source
    
    
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrP.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellProximite", forIndexPath: indexPath) as! ProximiteTableViewCell
        //print(indexPath)
        let arretProx = arrP[indexPath.row]
        cell.nomArretLabel.text = arretProx.nomArret
        cell.distanceLabel.text = "\("~")\(Int(round(arretProx.distanceArret*1000)))\("m")"
        
        let tableLigne = arretProx.ligneArret.sort()
        //print(tableLigne)
        
        switch (tableLigne.count){
        case 1:
            cell.logoIV1.image = UIImage(named: tableLigne[0])
            break
        case 2:
            cell.logoIV1.image = UIImage(named: tableLigne[0]); cell.logoIV2.image = UIImage(named: tableLigne[1] )
            break
        case 3:
            cell.logoIV1.image = UIImage(named: tableLigne[1]); cell.logoIV2.image = UIImage(named: tableLigne[2]); cell.logoIV3.image = UIImage(named: tableLigne[0])
            break
        case 4:
            cell.logoIV1.image = UIImage(named: tableLigne[1]); cell.logoIV2.image = UIImage(named: tableLigne[3])
            cell.logoIV3.image = UIImage(named: tableLigne[0]); cell.logoIV4.image = UIImage(named: tableLigne[2])
            break
        case 5:
            cell.logoIV1.image = UIImage(named: tableLigne[2]); cell.logoIV2.image = UIImage(named: tableLigne[4]); cell.logoIV3.image = UIImage(named: tableLigne[1])
            cell.logoIV4.image = UIImage(named: tableLigne[3]); cell.logoIV5.image = UIImage(named: tableLigne[0])
            break
        case _ where tableLigne.count > 5:
            cell.logoIV1.image = UIImage(named: tableLigne[2]); cell.logoIV2.image = UIImage(named: tableLigne[5]); cell.logoIV3.image = UIImage(named: tableLigne[1])
            cell.logoIV4.image = UIImage(named: tableLigne[4]); cell.logoIV5.image = UIImage(named: tableLigne[0]); cell.logoIV6.image = UIImage(named: tableLigne[3])
            break
        default:
            break
        }
        
        return cell
        
    }
    
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        locationFound = false
        checkStatutsLocalisation(false)
        //locationManager.startUpdatingLocation()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier ==  "ShowNextDepartP"{
            let departDetailViewController = segue.destinationViewController as! DepartTableViewController
            // Get the cell that generated this segue.
            if let selectedArretCell = sender as? ProximiteTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedArretCell)!
                let selectedA = arrP[indexPath.row]
                let arretSegue = Arrets(codeArret: selectedA.codeArret, nomArret: selectedA.nomArret, ligneArret: selectedA.ligneArret)
                departDetailViewController.arret = arretSegue
            }
        } else if segue.identifier == "showArretsMap"{
            let proximiteMapViewController = segue.destinationViewController as! ProximiteMapViewController
            proximiteMapViewController.arretAPlacer = arretMap
            
        }
        
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
