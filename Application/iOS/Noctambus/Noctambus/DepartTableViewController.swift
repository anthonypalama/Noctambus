//
//  DepartTableViewController.swift
//  Noctambus
//
//  Created by Luca Falvo on 02.12.15.
//  Copyright © 2015 Noctambus. All rights reserved.
//

import UIKit
import KVNProgress

class DepartTableViewController: UITableViewController {
    
    var arret: Arrets?
    var nextDepart = [Depart]()
    var departTemp = [Depart]()

    
    @IBOutlet weak var nomArretNextD: UINavigationItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nomArretNextD.title = arret?.nomArret
        self.refreshControl?.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    
    func noInternetCo(){
        //print("Not connected")
        let alert = UIAlertController(title: "Pas de connexion internet", message: "La connexion internet semble interrompue.", preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(defaultAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func InternetOK(){
        departTemp.removeAll()
        callWebService()
    }
    
    override func viewDidAppear(animated: Bool) {
        let status = Reach().connectionStatus()
        switch status {
        case .Unknown, .Offline:
            noInternetCo()
        case .Online(.WWAN), .Online(.WiFi):
            KVNProgress.showWithStatus("Chargement des données...")
            InternetOK()
        }
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        let status = Reach().connectionStatus()
        switch status {
        case .Unknown, .Offline:
            noInternetCo()
            self.refreshControl!.endRefreshing()
        case .Online(.WWAN), .Online(.WiFi):
            //print("Connected")
            InternetOK()
        }
    }
    
    
    func callWebService(){
        let url = "http://prod.ivtr-od.tpg.ch/v1/GetNextDepartures.json?stopCode="
        let arretSelect = arret!.codeArret
        let key = "&key=5f4382a0-fc2b-11e3-b5a1-0002a5d5c51b"
        
        let urlString = "\(url)\(arretSelect)\(key)"
        //print (urlString)
        
        Alamofire.request(.GET, urlString).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    self.parseJSON(json)
                }
            case .Failure(let error):
                print(error)
                let alert = UIAlertController(title: "Service indisponible", message: "Le service est actuellement indisponible", preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alert.addAction(defaultAction)
                self.presentViewController(alert, animated: true, completion: nil)
            }
            dispatch_async(dispatch_get_main_queue()) {
                KVNProgress.dismiss()
                self.tableView.reloadData()
                self.refreshControl!.endRefreshing()
                
            }
        }
    }
    
    func parseJSON(json: JSON) {
        for result in json["departures"].arrayValue {
            let departureCodeJ = result["departureCode"].stringValue
            let waitingTimeJ = result["waitingTime"].stringValue
            let lineCodeJ = result["line"]["lineCode"].stringValue
            let destinationNameJ = result["line"]["destinationName"].stringValue
            let information = Depart(departureCode: departureCodeJ, waitingTime: waitingTimeJ, lineCode: lineCodeJ, destinationName: destinationNameJ)
            self.departTemp.append(information)
        }
        
        nextDepart = departTemp
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nextDepart.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let depart = nextDepart[indexPath.row]
        let temps = depart.waitingTime
        
        //On choisit le design de la cellule (image ou temps)
        if(temps == "0" || temps == "no more"){
            let cellIdentifier = "departCellLogo"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! DepartTableViewCellLogo
            cell.numLogoImageView.image = UIImage(named: depart.lineCode)
            cell.destinationLabel.text = depart.destinationName
            
            //On charge l'image en fonction si le bus est là ou il n'y en a plus
            if(temps == "0"){
                cell.busImage.image = UIImage(named:"LogoBus")
                cell.accessoryType = .DisclosureIndicator
            }else{
                cell.accessoryType = .None
                cell.busImage.image = UIImage(named:"LogoNOBus")
            }
            
            return cell
            
        }else{
            let cellIdentifier = "departCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! DepartTableViewCell
            cell.numLogoImageView.image = UIImage(named: depart.lineCode)
            cell.destinationLabel.text = depart.destinationName
            
            if(temps == "&gt;1h"){
                cell.timeLabel.text = ">1h"
            }else{
                cell.timeLabel.text = "\(temps)\'"
            }
            
            
            return cell
        }
    }
    
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier ==  "showMap"{
            let mapViewController = segue.destinationViewController as! ArretLocalisationViewController
            
            mapViewController.arretC = arret!.codeArret
            mapViewController.nomArretC = arret!.nomArret
            
        } else if (segue.identifier == "showThermo" || segue.identifier == "showThermoLogo"){
            
            let thermoViewController = segue.destinationViewController as! ThermoTableViewController
            let indexPath = tableView.indexPathForSelectedRow
            let selectedDepart = nextDepart[indexPath!.row]
            thermoViewController.depart = selectedDepart
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "showThermoLogo"{
            let indexPath = tableView.indexPathForSelectedRow
            let selectedDepart = nextDepart[indexPath!.row]
            
            if (selectedDepart.waitingTime == "no more"){
                //alert
                let alert = UIAlertController(title: "Service terminé", message: "Service terminé à cet arrêt pour cette linge et cette destination.", preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alert.addAction(defaultAction)
                self.presentViewController(alert, animated: true, completion: nil)
                //segue
                return false
            }
            else{
                return true
            }
        }
        return true
    }
    
    
    
}
