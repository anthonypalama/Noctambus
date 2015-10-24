//
//  TicketsViewController.swift
//  Noctambus
//
//  Created by Luca Falvo on 18.10.15.
//  Copyright © 2015 Noctambus. All rights reserved.
//

import UIKit

class TicketsViewController: UIViewController {
    
    var compteur = 0
    
    @IBOutlet weak var logoImageView: UIImageView!

    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var nomLabel: UILabel!
    var ticket: Tickets?
    
    @IBOutlet weak var prixButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadButton()
        
        if let ticket = ticket {
            descriptionLabel.text = ticket.description
            logoImageView.image = ticket.logo
            nomLabel.text = ticket.name
            prixButton.setTitle("\(ticket.prix)0 CHF", forState: .Normal)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadButton() {
        prixButton.layer.cornerRadius = 5.0
        prixButton.layer.borderWidth = 1.5
        prixButton.layer.borderColor = UIColor(red: 10/255, green: 167/255, blue: 233/255, alpha: 1.0).CGColor
    }
    
    @IBAction func prixButton(sender: AnyObject) {
        compteur++
        
        if (compteur <= 1) {
            prixButton.setTitle("Acheter", forState: .Normal)
            prixButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            prixButton.backgroundColor = UIColor(red: 10/255, green: 167/255, blue: 233/255, alpha: 1.0)
        } else  {
            UIApplication.sharedApplication().openURL(NSURL(string: "http://maps.apple.com/?q=Mexican+Restaurant")!)
        }

        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
