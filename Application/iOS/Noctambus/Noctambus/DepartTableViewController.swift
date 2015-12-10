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
    
    
    @IBOutlet weak var nomArretNextD: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nomArretNextD.title = arret?.nomArret
        
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
            let departureCode = result["departureCode"].stringValue
            let waitingTime = result["waitingTime"].stringValue
            
            let linecode = result["line"]["lineCode"].stringValue           
            
            print(linecode)
            
            
            
            //for item in sigs! {
            //    let id = item["lineCode"].intValue
            //   let name = item["destinationName"].stringValue
            //
            //     print(id)
            //    print(name)
            
            //}
            
            
            //objects.append(obj)
        }
        
        //print(objects)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
    
    // Configure the cell...
    
    return cell
    }
    */
    
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
