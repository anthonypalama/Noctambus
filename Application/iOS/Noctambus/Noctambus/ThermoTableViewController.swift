//
//  ThermoTableViewController.swift
//  Noctambus
//
//  Created by Luca Falvo on 28.01.16.
//  Copyright © 2016 Noctambus. All rights reserved.
//

import UIKit
import KVNProgress

class ThermoTableViewController: UITableViewController {
    //recupere le départ selectionne dans la vue precedente
    var depart: Depart?
    var steps = [ThermoA]()
    var indexSc = 0
    
    @IBOutlet weak var busNavigationItem: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        busNavigationItem.title = "\(depart!.lineCode)\(" → ")\(depart!.destinationName)"
        self.refreshControl?.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func noInternetCo(){
        print("Not connected")
        let alert = UIAlertController(title: "Pas de connexion internet", message: "La connexion internet semble interrompue.", preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(defaultAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func InternetOK(){
        steps.removeAll()
        callWebService()
    }
    
    override func viewDidAppear(animated: Bool) {
        let status = Reach().connectionStatus()
        switch status {
        case .Unknown, .Offline:
            noInternetCo()
        case .Online(.WWAN), .Online(.WiFi):
            print("Connected")
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
            print("Connected")
            InternetOK()
        }
    }
    
    func callWebService(){
        let url = "http://prod.ivtr-od.tpg.ch/v1/GetThermometer.json?departureCode="
        let arretSelect = depart!.departureCode
        let key = "&key=5f4382a0-fc2b-11e3-b5a1-0002a5d5c51b"
        
        let urlString = "\(url)\(arretSelect)\(key)"
        print (urlString)
        
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
                let indexPath = NSIndexPath(forRow: self.indexSc, inSection: 0)
                self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
            }
 
        }
    }
    
    func parseJSON(json: JSON) {
        for result in json["steps"].arrayValue {
            let stopCodeJ = result["stop"]["stopCode"].stringValue
            let stopNameJ = result["stop"]["stopName"].stringValue
            let arrivalTimeJ = result["arrivalTime"].stringValue
            let visibleJ = result["visible"].boolValue
            let information =   ThermoA(stopCode: stopCodeJ, stopName: stopNameJ, arrivalTime: arrivalTimeJ, visible: visibleJ)
            self.steps.append(information)
        }
        //trouver l'indice du premier élément visible dans la tableau
        indexSc = steps.indexOf({$0.visible == true})!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return steps.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let depart = steps[indexPath.row]
        
        let cellIdentifier = "thermoVisibleCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ThermoTableViewCell
        
        if(depart.visible == false){
            cell.backgroundColor = UIColor.grayColor()
        }else{
            cell.backgroundColor = UIColor.clearColor()
        }
        
        cell.thNomArretLabel.text = depart.stopName
        
        let time = depart.arrivalTime
        if time == "00"{
            cell.arrivalTimeLabel.text = "🚍"
        }else if time == ""{
            cell.arrivalTimeLabel.text = ""
        }else{
            cell.arrivalTimeLabel.text = "\(time)\'"
        }
        
        
        
        if (indexPath.row == 0){
            cell.thermoImageView.image = UIImage(named:"thermoD")
        } else if (indexPath.row == steps.count-1){
            cell.thermoImageView.image = UIImage(named:"thermoFin")
        }else{
            cell.thermoImageView.image = UIImage(named:"thermo")
        }
        
        return cell
        
        
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
