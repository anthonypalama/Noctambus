//
//  TicketsTableViewController.swift
//  Noctambus
//
//  Created by Luca Falvo on 17.10.15.
//  Copyright © 2015 Noctambus. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import MessageUI

class TicketsTableViewController: PFQueryTableViewController, MFMessageComposeViewControllerDelegate{
    
  
    // MARK: Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .SingleLine
        //self.refreshControl?.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
    }
    
   
    //1
    override func viewWillAppear(animated: Bool) {
        loadObjects()
    }
    
    //2
    override func queryForTable() -> PFQuery {
        let query = Tickets.query()
        query?.fromLocalDatastore()
        return query!
    }
    
    //3
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject!) -> PFTableViewCell? {
        //4
        let cell = tableView.dequeueReusableCellWithIdentifier("TicketsCell", forIndexPath: indexPath) as! TicketsTableViewCell
        //5
        let ticket = object as! Tickets        
        //6
        let photo = UIImage(named: ticket.namelogo)
        cell.descriptionLabel.text = ticket.descriptionT
        cell.typeLabel.text = ticket.name
        cell.prixText.text = "\(ticket.prix)0 CHF"
        cell.logoImageView.image = photo
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if MFMessageComposeViewController.canSendText(){
            let ticketSelect = self.objects![indexPath.row] as! Tickets
            let messageConfirmation = "\(ticketSelect.descriptionT), \(ticketSelect.prix)0 CHF"
            
            let alertController = UIAlertController(title: "Confirmer ?", message: messageConfirmation, preferredStyle: UIAlertControllerStyle.Alert)
            
            let buyAction = UIAlertAction(title: "Oui", style: UIAlertActionStyle.Destructive, handler: {(alert :UIAlertAction!) in
                //print("OK button tapped")
                let messageVC = MFMessageComposeViewController()
                
                messageVC.body = ticketSelect.code;
                messageVC.recipients = [Tickets.numTelSMS]
                messageVC.messageComposeDelegate = self;
                
                self.presentViewController(messageVC, animated: true, completion: nil)
                
            })
            alertController.addAction(buyAction)
            
            let cancelAction = UIAlertAction(title: "Annuler", style: UIAlertActionStyle.Cancel, handler: {(alert :UIAlertAction!) in
                //print("Delete button tapped")
            })
            
            alertController.addAction(cancelAction)
            

            
            presentViewController(alertController, animated: true, completion: nil)
        }else{        
            // create the alert
            let alert = UIAlertController(title: "Erreur", message: "Vous ne pouvez pas envoyer de SMS", preferredStyle: UIAlertControllerStyle.Alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            // show the alert
            self.presentViewController(alert, animated: true, completion: nil)
        }
       

        
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult){
        switch (result.rawValue) {
        case MessageComposeResultCancelled.rawValue:
            //print("Message was cancelled")
            self.dismissViewControllerAnimated(true, completion: nil)
        case MessageComposeResultFailed.rawValue:
            //print("Message failed")
            self.dismissViewControllerAnimated(true, completion: nil)
        case MessageComposeResultSent.rawValue:
            //print("Message was sent")
            self.dismissViewControllerAnimated(true, completion: nil)
        default:
            break;
        }
    }
    
    /*func handleRefresh(refreshControl: UIRefreshControl) {
        let status = Reach().connectionStatus()
        switch status {
        case .Unknown, .Offline:
            noInternetCo()
            self.refreshControl!.endRefreshing()
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
            let queryTickets = Tickets.query()
            do {
                let a = try queryTickets?.fromLocalDatastore().findObjects()
                let b = try Tickets.query()!.findObjects()
                
                //UNPIN les object du localstorage
                try PFObject.unpinAll(a, withName: "Tickets")
                //PIn les object du serveur parse
                try PFObject.pinAll(b, withName: "Tickets")
                
            }
            catch{
                print("error")
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                self.loadObjects()
    
            }
        }
    } */
    
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

    
    // MARK: - Navigation

     

}
