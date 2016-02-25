//
//  SettingsTableViewController.swift
//  Noctambus
//
//  Created by Luca Falvo on 26.12.15.
//  Copyright © 2015 Noctambus. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 50
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    /* override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return 0
    }*/
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UITableViewHeaderFooterView
        headerView.textLabel!.textColor = UIColor(red: 10.0/255, green: 167.0/255, blue: 233.0/255, alpha: 1)
        //let font = UIFont(name: "Arial", size: 15.0)
        //headerView.textLabel!.font = font!
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier ==  "showUrbain"{
            let planViewController = segue.destinationViewController as! PlansViewController
            planViewController.nameTitle = "Plan noctambus urbain"
            planViewController.nameImage = "planUrbain"
            
        } else if segue.identifier ==  "showPeriurbain" {
            let planViewController = segue.destinationViewController as! PlansViewController
            planViewController.nameTitle = "Plan noctambus périurbain"
            planViewController.nameImage = "planPeriurbain"
        } else if segue.identifier == "showTarifs"{
            let planViewController = segue.destinationViewController as! PlansViewController
            planViewController.nameTitle = "Plan de zones tarifaires"
            planViewController.nameImage = "planTarifs"
        }
    }
}
