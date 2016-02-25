//
//  LignesTableViewController.swift
//  Noctambus
//
//  Created by Luca Falvo on 26.12.15.
//  Copyright © 2015 Noctambus. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class LignesTableViewController: PFQueryTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 60
        tableView.separatorStyle = .SingleLine
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //1
    override func viewWillAppear(animated: Bool) {
        loadObjects()
    }
    
    //2
    override func queryForTable() -> PFQuery {
        let query = Lignes.query()
        //query?.fromLocalDatastore()
        return query!
    }
    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    
    //3
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject!) -> PFTableViewCell? {
        //4
        let cell = tableView.dequeueReusableCellWithIdentifier("LignesCell", forIndexPath: indexPath) as! LignesTableViewCell
        //5
        let ligne = object as! Lignes
        
       // print(ligne)
        //6
        
        cell.logoLigneImageView.image = UIImage(named: ligne.lineCode)
        cell.departLabel.text = ligne.originName
        cell.destinationLabel.text = ligne.destinationName

        return cell
    }
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier ==  "showArretsLigne"{
            let ligneDetailViewController = segue.destinationViewController as! LigneArretsTableViewController
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                ligneDetailViewController.ligne = self.objects![indexPath.row] as! Lignes
            }            
//            if let selectedLignesCell = sender as? LignesTableViewCell {
//                let indexPath = tableView.indexPathForCell(selectedLignesCell)!
//                let ligneSelect = self.objects![indexPath.row] as! Lignes
//                ligneDetailViewController.ligne = ligneSelect as Lignes
//                print(ligneSelect)
//            }
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



}
