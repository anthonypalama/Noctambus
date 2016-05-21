//
//  ArretsViewController.swift
//  Noctambus
//
//  Created by Luca Falvo on 25.11.15.
//  Copyright © 2015 Noctambus. All rights reserved.
//

import UIKit
import Parse

class ArretViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    let refreshControl = UIRefreshControl()
    var searchActive : Bool = false
    var data:[PFObject]!
    
    //var filtered:[PFObject]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 50
        /* Setup delegates */
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        refreshControl.tintColor = UIColor.yellowColor()
        //refreshControl.addTarget(self, action: "handleRefresh:", forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
        search()
    }
    
    func search(searchText: String? = ""){
        let query = Arrets.query()
        query!.fromLocalDatastore()
        query!.orderByAscending("nomArret")
        if(searchText != ""){
            query!.whereKey("nomArret", matchesRegex: searchText!, modifiers: "i")
        }
        query!.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            self.data = results as [PFObject]?
            self.tableView.reloadData()
        }
        
    }
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
        searchBar.showsCancelButton = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
        searchBar.showsCancelButton = false;
        
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
        searchBar.resignFirstResponder()
        searchBar.text = ""
        search("")
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
        searchBar.resignFirstResponder()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        search(searchText)
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.data != nil){
            return self.data.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ArretsCell", forIndexPath: indexPath) as! ArretsTableViewCell
        let obj = self.data[indexPath.row] as! Arrets
        cell.arretNomLabel.text = obj.nomArret
        //let tableLigne = obj["ligneArret"] as! NSArray
        let tableLigne = obj.ligneArret
        
        
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
    
    /*func handleRefresh(refreshControl: UIRefreshControl) {
        let status = Reach().connectionStatus()
        switch status {
        case .Unknown, .Offline:
            noInternetCo()
            refreshControl.endRefreshing()
        case .Online(.WWAN), .Online(.WiFi):
            InternetOK()
        }
    }
    
    func noInternetCo(){
        let alert = UIAlertController(title: "Pas de connexion internet", message: "La connexion internet semble interrompue.", preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(defaultAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func InternetOK(){
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            //Tickets
            do {
                let a = try Arrets.query()!.fromLocalDatastore().findObjects()
                let b = try Arrets.query()!.findObjects()
                
                //UNPIN les object du localstorage
                try PFObject.unpinAll(a, withName: "Arrets")
                //PIn les object du serveur parse
                try PFObject.pinAll(b, withName: "Arrets")
                
            }
            catch{
                print("error")
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.search(self.searchBar.text)
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
 
 */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier ==  "ShowNextDepart"{
            let departDetailViewController = segue.destinationViewController as! DepartTableViewController
            
            // Get the cell that generated this segue.
            if let selectedArretCell = sender as? ArretsTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedArretCell)!
                let selectedDepart = data[indexPath.row]
                departDetailViewController.arret = selectedDepart as? Arrets
                //print(selectedDepart)
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
}