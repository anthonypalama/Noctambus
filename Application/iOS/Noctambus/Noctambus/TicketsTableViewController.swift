//
//  TicketsTableViewController.swift
//  Noctambus
//
//  Created by Luca Falvo on 17.10.15.
//  Copyright © 2015 Noctambus. All rights reserved.
//

import UIKit
import MessageUI

class TicketsTableViewController: PFQueryTableViewController, MFMessageComposeViewControllerDelegate{
    
  
    // MARK: Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()        
    }
    
   
    //1
    override func viewWillAppear(animated: Bool) {
        loadObjects()
    }
    
    //2
    override func queryForTable() -> PFQuery {
        let query = Tickets.query()
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
       
        let ticketSelect = self.objects![indexPath.row] as! Tickets
        let messageConfirmation = "\(ticketSelect.descriptionT), \(ticketSelect.prix)0 CHF"
        
        let alertController = UIAlertController(title: "Confirmer ?", message: messageConfirmation, preferredStyle: UIAlertControllerStyle.Alert)
        
        let deleteAction = UIAlertAction(title: "Annuler", style: UIAlertActionStyle.Destructive, handler: {(alert :UIAlertAction!) in
            print("Delete button tapped")
        })
        alertController.addAction(deleteAction)
        
        let okAction = UIAlertAction(title: "Oui", style: UIAlertActionStyle.Default, handler: {(alert :UIAlertAction!) in
            print("OK button tapped")
            let messageVC = MFMessageComposeViewController()
            
            messageVC.body = ticketSelect.code;
            messageVC.recipients = [Tickets.numTelSMS]
            messageVC.messageComposeDelegate = self;
            
            self.presentViewController(messageVC, animated: true, completion: nil)
            
        })
        alertController.addAction(okAction)
        
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult){
        switch (result.rawValue) {
        case MessageComposeResultCancelled.rawValue:
            print("Message was cancelled")
            self.dismissViewControllerAnimated(true, completion: nil)
        case MessageComposeResultFailed.rawValue:
            print("Message failed")
            self.dismissViewControllerAnimated(true, completion: nil)
        case MessageComposeResultSent.rawValue:
            print("Message was sent")
            self.dismissViewControllerAnimated(true, completion: nil)
        default:
            break;
        }    }
    
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
