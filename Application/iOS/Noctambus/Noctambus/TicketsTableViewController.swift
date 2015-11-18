//
//  TicketsTableViewController.swift
//  Noctambus
//
//  Created by Luca Falvo on 17.10.15.
//  Copyright © 2015 Noctambus. All rights reserved.
//

import UIKit

class TicketsTableViewController: UITableViewController {
    
    // MARK: Properties
    var tickets = [Tickets]()
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        loadTickets()
    }
    
    func loadTickets() {
        
        let photo1 = UIImage(named: "tpg1")!
        let ticket1 = Tickets(code: "tpg1", name: "Billet", description: "Plein tarif, 60', Tout Genève, zone 10", prix: 3.00, logo: photo1)!
        
        let photo2 = UIImage(named: "tpg2")!
        let ticket2 = Tickets(code: "tpg2", name: "Billet", description: "Tarif réduit, 60', Tout Genève, zone 10", prix: 2.0, logo: photo2)!
        
        let photo3 = UIImage(named: "cj1")!
        let ticket3 = Tickets(code: "tpg1", name: "Carte journ.", description: "Plein tarif, Tout Genève, zone 10", prix: 10.0, logo: photo3)!
        
        let photo4 = UIImage(named: "cj2")!
        let ticket4 = Tickets(code: "tpg2", name: "Carte journ.", description: "Tarif réduit, Tout Genève, zone 10", prix: 7.3, logo: photo4)!
        
        let photo5 = UIImage(named: "cj91")!
        let ticket5 = Tickets(code: "tpg1", name: "Carte journ. 9h", description: "Plein tarif, 60', Tout Genève, zone 10", prix: 8.0, logo: photo5)!
        
        let photo6 = UIImage(named: "cj92")!
        let ticket6 = Tickets(code: "tpg2", name: "Carte journ. 9h", description: "Tarif réduit, Tout Genève, zone 10", prix: 5.6, logo: photo6)!
        
        tickets += [ticket1, ticket2, ticket3, ticket4, ticket5, ticket6]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tickets.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "TicketsTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! TicketsTableViewCell
        let ticket = tickets[indexPath.row]
        
        cell.descriptionLabel.text = ticket.description
        cell.logoImageView.image = ticket.logo
        cell.prixText.text = "\(ticket.prix)0 CHF"
        //cell.prixLabel.text =         
        cell.typeLabel.text = ticket.name
        
        return cell
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

    
    // MARK: - Navigation

    //In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail" {
            let ticketDetailViewController = segue.destinationViewController as! TicketsViewController
            
            // Get the cell that generated this segue.
            if let selectedTicketCell = sender as? TicketsTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedTicketCell)!
                let selectedTicket = tickets[indexPath.row]
                ticketDetailViewController.ticket = selectedTicket
            }
        }
        else if segue.identifier == "Conditions" {
            print("Conditions")
        }
    }
    

}
