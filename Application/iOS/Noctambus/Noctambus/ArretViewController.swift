//
//  ViewController.swift
//  SwiftSearch
//
//  Created by Shrikar Archak on 2/16/15.
//  Copyright (c) 2015 Shrikar Archak. All rights reserved.
//

import UIKit

class ArretViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchActive : Bool = false
    var data:[PFObject]!
    var filtered:[PFObject]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Setup delegates */
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        //search()
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        search()
    }
    
    func search(searchText: String? = nil){
        let query = PFQuery(className: "Arrets")
        query.limit = 1000
        query.fromLocalDatastore()
        query.orderByAscending("nomArret")
        if(searchText != nil){
            query.whereKey("nomArret", containsString: searchText)
        }
        query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            self.data = results as [PFObject]?
            self.tableView.reloadData()
        }
        
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
    
}