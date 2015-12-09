//
//  ArretsViewController.swift
//  Noctambus
//
//  Created by Luca Falvo on 25.11.15.
//  Copyright © 2015 Noctambus. All rights reserved.
//

import UIKit

class ArretViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchActive : Bool = false
    //var data = ["San Francisco","New York","San Jose","Chicago","Los Angeles","Austin","Seattle"]
    //var filtered:[String] = []
    var data:[PFObject]!
    var filtered:[PFObject]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Setup delegates */
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        search()
        
    }
    
    func search(searchText: String? = ""){
        let query = PFQuery(className: "Arrets")
        query.limit = 1000
        query.fromLocalDatastore()
        query.orderByAscending("nomArret")
        if(searchText != ""){
            query.whereKey("nomArret", matchesRegex: searchText!, modifiers: "i")
    }
        query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
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
        let obj = self.data[indexPath.row]
        cell.arretNomLabel.text = obj["nomArret"] as? String
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier ==  "ShowNextDepart"{
            let mealDetailViewController = segue.destinationViewController as! DepartTableViewController
            
            // Get the cell that generated this segue.
            if let selectedArretCell = sender as? ArretsTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedArretCell)!
                let selectedMeal = data[indexPath.row]
                mealDetailViewController.arret = selectedMeal as! Arrets
            }
        }
    }

        
    
    
    
    
    
    
    
    
}