//
//  StartViewController.swift
//  Noctambus
//
//  Created by Luca Falvo on 03.02.16.
//  Copyright © 2016 Noctambus. All rights reserved.
//

import UIKit
import Parse

class StartViewController: UIViewController {
    @IBOutlet weak var loadIndicatorView: UIActivityIndicatorView!
    let messageNoInternet = "Impossible de se connecter au serveur Noctambus. Vous devez être connecté pour le 1er lancement de l'application. Veuillez vérifier vos réglages."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadIndicatorView.startAnimating()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        // L'application a deja été lancée les données sont déjà dans l'appareil mise à jour asynch
        if(NSUserDefaults.standardUserDefaults().boolForKey("HasLaunchedOnce"))
        {
            dataSync()
            self.startApplication()
        }
        else
        {
            // 1er lancement de l'application on recupere les donnees avant de lancer l'application
            checkInternet()
        }
    }
    
    //permet de base à la vue suivante tabbarcontroller
    func startApplication(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = storyboard.instantiateViewControllerWithIdentifier("tabBarControllerID") as! UITabBarController
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.rootViewController = tabBarController
    }
    
    
    func checkInternet(){
        let status = Reach().connectionStatus()
        switch status {
        case .Unknown, .Offline:
            loadIndicatorView.startAnimating()
            let alertController = UIAlertController(title: "Pas de connexion internet", message: messageNoInternet, preferredStyle: UIAlertControllerStyle.Alert)
            let deleteAction = UIAlertAction(title: "Réessayer", style: UIAlertActionStyle.Default, handler: {(alert :UIAlertAction!) in
                self.loadIndicatorView.startAnimating()
                self.checkInternet()
            })
            alertController.addAction(deleteAction)
            presentViewController(alertController, animated: true, completion: nil)
        case .Online(.WWAN), .Online(.WiFi):
            firstDataLaunch()
        }
        
        
    }
    
    //Recueration des donnees pour le 1er lancement de l'application
    func firstDataLaunch(){
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            //Arrêts
            let queryArrets = Arrets.query()
            queryArrets!.limit = 700
            //Tickets
            let queryTickets = Tickets.query()
            
            
            do {
                let resultArrets = try queryArrets!.findObjects()
                try PFObject.pinAll(resultArrets, withName: "Arrets")
                
                let resultTickets = try queryTickets!.findObjects()
                try PFObject.pinAll(resultTickets, withName: "Tickets")
            }
            catch{
                print("error")
            }
            dispatch_async(dispatch_get_main_queue()) {
                print("FIN")
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "HasLaunchedOnce")
                NSUserDefaults.standardUserDefaults().synchronize()
                self.startApplication()
                
            }
        }
    }
    
    func dataSync(){
        
        //LocalStorage ARRETS
        let queryArrets = Arrets.query()
        queryArrets!.limit = 700
        queryArrets!.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if (error == nil) {
                // shuffle objects here?
                PFObject.pinAllInBackground(objects, withName:"Arrets", block: nil)
            }
        }
        
        //LocalStorage TICKETS
        let query = Tickets.query()
        query!.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            
            if (error == nil) {
                // shuffle objects here?
                PFObject.pinAllInBackground(objects, withName:"Tickets", block: nil)
                
            }
        }
        
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
