//
//  ArretsTableViewController.swift
//  Noctambus
//
//  Created by Luca Falvo on 25.11.15.
//  Copyright © 2015 Noctambus. All rights reserved.
//

import UIKit

class ArretsTableViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchActive : Bool = false
    var data:[PFObject]!
    var filtered:[PFObject]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        search()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func search(searchText: String? = nil){
        let query = PFQuery(className: "Arrets")
        query.limit = 1000
        if(searchText != nil){
            query.whereKey("nomArret", containsString: searchText)
        }
        query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            self.data = results as [PFObject]?
            self.tableView.reloadData()
        }
        
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.data != nil){
            return self.data.count
        }
        return 0
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ArretsCell", forIndexPath: indexPath) as! ArretsTableViewCell
        let obj = self.data[indexPath.row]
        cell.nomArretLabel.text = obj["nomArret"] as? String
        return cell
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
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

}
