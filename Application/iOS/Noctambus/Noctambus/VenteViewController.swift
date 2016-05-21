//
//  VenteViewController.swift
//  Noctambus
//
//  Created by Luca Falvo on 12.04.16.
//  Copyright © 2016 Noctambus. All rights reserved.
//

import UIKit

class VenteViewController: UIViewController {

    @IBOutlet weak var venteWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let localfilePath = NSBundle.mainBundle().URLForResource("vente", withExtension: "html");
        let myRequest = NSURLRequest(URL: localfilePath!);
        venteWebView.loadRequest(myRequest);
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
