//
//  DepartTableViewController.swift
//  Noctambus
//
//  Created by Luca Falvo on 02.12.15.
//  Copyright © 2015 Noctambus. All rights reserved.
//

import UIKit


class DepartTableViewController: UITableViewController {
    
    var arret: Arrets?
    var nextDepart = [Depart]()
    
    @IBOutlet weak var nomArretNextD: UINavigationItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nomArretNextD.title = arret?.nomArret
        self.refreshControl?.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    override func viewWillAppear(animated: Bool) {
        SwiftSpinner.show("Chargement des données...")
        callWebService()
        SwiftSpinner.hide()        
    }
    
    
    func callWebService(){
        let url = "http://prod.ivtr-od.tpg.ch/v1/GetNextDepartures.json?stopCode="
        let arretSelect = arret!.codeArret
        let key = "&key=5f4382a0-fc2b-11e3-b5a1-0002a5d5c51b"
        
        let urlString = "\(url)\(arretSelect)\(key)"
        print (urlString)
        
        if let url = NSURL(string: urlString) {
            if let data = try? NSData(contentsOfURL: url, options: []) {
                let json = JSON(data: data)
                parseJSON(json)
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
            
            self.nextDepart.append(information)
            
            //for item in sigs! {
            //    let id = item["lineCode"].intValue
            //   let name = item["destinationName"].stringValue
            //}
            
            
        }
        
        //tableView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    /*override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 0
    }*/
    
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
            }else{
                cell.busImage.image = UIImage(named:"LogoBus")
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
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        nextDepart.removeAll()
        callWebService()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
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
