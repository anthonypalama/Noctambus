//
//  LignesViewController.swift
//  Noctambus
//
//  Created by Luca Falvo on 19.04.16.
//  Copyright © 2016 Noctambus. All rights reserved.
//

import UIKit
import Parse

class LignesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var lignesSegmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var lignesR:[Lignes] = []
    var lignesU:[Lignes] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getLignes()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getLignes (){
        let query = PFQuery(className: "Lignes")
        query.orderByAscending("lineCode")
        query.fromLocalDatastore()
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            for object in objects! {
                let id = object["idLignes"] as! String
                let origine = object["originName"] as! String
                let destination = object["destinationName"] as! String
                let lineCode = object["lineCode"] as! String
                let type = object["Type"] as! Bool
                let uneLigne = Lignes(idLignes: id, originName: origine, destinationName: destination, lineCode: lineCode, Type: type)
                
                if(type == true){
                    self.lignesR.append(uneLigne)
                }else{
                    self.lignesU.append(uneLigne)
                }
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
                
            }
        }
    }
   
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellLigne", forIndexPath: indexPath) as! LignesTableViewCell
        
        switch(lignesSegmentedControl.selectedSegmentIndex)
        {
        case 0:
            let regio = lignesR[indexPath.row] as Lignes
            cell.logoImageView.image = UIImage(named: regio.lineCode)
            cell.destinationLabel.text = regio.destinationName
            cell.origineLabel.text = regio.originName
            break
        case 1:
            let urba = lignesU[indexPath.row] as Lignes
            cell.logoImageView.image = UIImage(named: urba.lineCode)
            cell.destinationLabel.text = urba.destinationName
            cell.origineLabel.text = urba.originName
            break
         default:
            break
            
        }
        
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var returnValue = 0
        switch(lignesSegmentedControl.selectedSegmentIndex)
        {
        case 0:
            returnValue = lignesR.count
            break
        case 1:
            returnValue = lignesU.count
            break
        default:
            break
            
        }
        return returnValue
        
    }

    @IBAction func refreshLignes(sender: AnyObject) {
        tableView.reloadData()
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier ==  "showArretL"{
            let arretLigneViewController = segue.destinationViewController as! AccordionMenuTableViewController
            // Get the cell that generated this segue.
            if let selectedArretCell = sender as? LignesTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedArretCell)!
                
                switch(lignesSegmentedControl.selectedSegmentIndex)
                {
                case 0:
                    let selectLigne = lignesR[indexPath.row]
                    arretLigneViewController.ligne = selectLigne
                    break
                case 1:
                    let selectLigne = lignesU[indexPath.row]
                    arretLigneViewController.ligne = selectLigne
                    break
                default:
                    break
                    
                }

                
            }

        }
    }
    

}
