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
    
    let versionNoctambus = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
    var versionDataLocal : Double!
    
    var versionAppIosParse : String!
    var versionDataParse : Double!
    
    
    @IBOutlet weak var loadIndicatorView: UIActivityIndicatorView!
    let messageNoInternet = "Impossible de se connecter au serveur Noctambus. Vous devez être connecté pour le 1er lancement de l'application. Veuillez vérifier vos réglages."
    let messageNewVersion = "Une nouvelle version de l'application est disponible sur l'App Store"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadIndicatorView.startAnimating()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        // L'application a deja été lancée les données sont déjà dans l'appareil mise à jour asynch
        if(NSUserDefaults.standardUserDefaults().boolForKey("HasLaunchedOnce"))
        {
            dataSync()
        }
        else
        {
            // 1er lancement de l'application on recupere les donnees avant de lancer l'application
            checkInternetFirstLaunch()
        }
    }
    
    //permet de base à la vue suivante tabbarcontroller
    func startApplication(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = storyboard.instantiateViewControllerWithIdentifier("tabBarControllerID") as! UITabBarController
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.rootViewController = tabBarController
    }
    
    
    func checkInternetFirstLaunch(){
        let status = Reach().connectionStatus()
        switch status {
        case .Unknown, .Offline:
            loadIndicatorView.startAnimating()
            let alertController = UIAlertController(title: "Pas de connexion internet", message: messageNoInternet, preferredStyle: UIAlertControllerStyle.Alert)
            let deleteAction = UIAlertAction(title: "Réessayer", style: UIAlertActionStyle.Default, handler: {(alert :UIAlertAction!) in
                self.loadIndicatorView.startAnimating()
                self.checkInternetFirstLaunch()
            })
            alertController.addAction(deleteAction)
            presentViewController(alertController, animated: true, completion: nil)
        case .Online(.WWAN), .Online(.WiFi):
            firstDataLaunch()
        }
        
        
    }
    
    //Recueration des donnees pour le 1er lancement de l'application
    func firstDataLaunch(){
        print("1er lacnement donnee")
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            
            self.pinAll()
            
            
            
                        dispatch_async(dispatch_get_main_queue()) {
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "HasLaunchedOnce")
                NSUserDefaults.standardUserDefaults().synchronize()
                self.startApplication()
                
            }
        }
    }
    
    func pinAll(){
        do {
            //arrets commericaux
            let resultArrets = try Arrets.query()!.findObjects()
            try PFObject.pinAll(resultArrets, withName: "Arrets")
            //ticket
            let resultTickets = try Tickets.query()!.findObjects()
            try PFObject.pinAll(resultTickets, withName: "Tickets")
            //arrets physiques
            let resultPhyisque = try ArretsPhysique.query()!.findObjects()
            try PFObject.pinAll(resultPhyisque, withName: "ArretsPhysique")
            //lignes
            let resultLignes = try Lignes.query()!.findObjects()
            try PFObject.pinAll(resultLignes, withName: "Lignes")
            //arets Lignes
            let resultArrLignes = try ArretsLigne.query()!.findObjects()
            try PFObject.pinAll(resultArrLignes, withName: "ArretsLigne")
            //Maj
            let resultMaj = try Maj.query()!.findObjects()
            try PFObject.pinAll(resultMaj, withName: "Maj")
        }
        catch{
            print("error")
        }

    }
    
    
    
    func dataSync(){
        let status = Reach().connectionStatus()
        switch status {
        case .Unknown, .Offline:
            self.startApplication()
        case .Online(.WWAN), .Online(.WiFi):
            checkVersion()
        }
        
        
        
    }
    
    func checkVersion(){
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            
            
            let queryMajLocal: PFQuery = PFQuery(className: "Maj")
            queryMajLocal.fromLocalDatastore()
            
            let queryMaj: PFQuery = PFQuery(className: "Maj")
            
            do {
                //MAJ LOCAL
                let resultLocal = try queryMajLocal.getFirstObject()
                self.versionDataLocal = resultLocal.objectForKey("versionData") as! Double
                
                //MAJ PARSE
                let resultParse = try queryMaj.getFirstObject()
                self.versionAppIosParse = resultParse.objectForKey("versionIOS") as! String
                self.versionDataParse = resultParse.objectForKey("versionData") as! Double
            }
            catch{
                print("error")
            }
            dispatch_async(dispatch_get_main_queue()) {
                if (self.versionNoctambus == self.versionAppIosParse){
                    //c'est la meme version check si les données sont à jour
                    print("tu as la derniere version de l'application")
                    
                    if(self.versionDataLocal == self.versionDataParse){
                        print("tu as la derniere version des donnees")
                        self.startApplication()
                    }else{
                        print("tu n'as pas la derniere version des données")
                        self.unPinAllData()
                    }
                    
                }else{
                    print("tu n'as pas la derniere version de l'application")
                    let alertController = UIAlertController(title: "Nouvelle version", message: self.messageNewVersion, preferredStyle: UIAlertControllerStyle.Alert)
                    let deleteAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(alert :UIAlertAction!) in
                        self.startApplication()
                    })
                    alertController.addAction(deleteAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }
        }
        
    }
    
    func unPinAllData(){
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            do {
                //arrets commericaux
                let a = try Arrets.query()!.fromLocalDatastore().findObjects()
                try PFObject.unpinAll(a, withName: "Arrets")
                //ticket
                let b = try Tickets.query()!.fromLocalDatastore().findObjects()
                try PFObject.unpinAll(b, withName: "Tickets")
                //arrets physiques
                let c = try ArretsPhysique.query()!.fromLocalDatastore().findObjects()
                try PFObject.unpinAll(c, withName: "ArretsPhysique")
                //lignes
                let d = try Lignes.query()!.fromLocalDatastore().findObjects()
                try PFObject.unpinAll(d, withName: "Lignes")
                //arets Lignes
                let e = try ArretsLigne.query()!.fromLocalDatastore().findObjects()
                try PFObject.unpinAll(e, withName: "ArretsLigne")
                //Maj
                let f = try Maj.query()!.fromLocalDatastore().findObjects()
                try PFObject.unpinAll(f, withName: "Maj")

                print("fin unpinage")
                
            }
            catch{
                print("error")
            }
            
            self.pinAll()
            
            dispatch_async(dispatch_get_main_queue()) {

                self.startApplication()
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
