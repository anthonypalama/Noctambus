//
//  ConditionsViewController.swift
//  Noctambus
//
//  Created by Luca Falvo on 09.03.16.
//  Copyright © 2016 Noctambus. All rights reserved.
//

import UIKit
import KVNProgress

class ConditionsViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var titleViewNavigationItem: UINavigationItem!
    
    @IBOutlet weak var conditionsWebView: UIWebView!
    
    var nameTitle = String()
    var viewToLoad = Int()
    var start = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        conditionsWebView.delegate = self
        titleViewNavigationItem.title = nameTitle

        
        switch viewToLoad {
        case 0:
            loadNoctambus()
        case 1:
           loadConditionsPDF()
        case 2:
            conditionsWebView.scalesPageToFit = false
            loadMentions()
        case 3:
            conditionsWebView.scalesPageToFit = false
            conditionsWebView.backgroundColor = UIColor(red: 55.0/255.0, green: 103.0/255.0, blue: 184.0/255.0, alpha: 1.0)
            loadContact()
        default:
            break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadConditionsPDF(){
        let localfilePath = NSBundle.mainBundle().URLForResource("cond", withExtension: "pdf");
        let myRequest = NSURLRequest(URL: localfilePath!);
        conditionsWebView.loadRequest(myRequest);
    }
    
    func loadNoctambus(){
        let url = NSURL (string: "http://noctambus.ch/association-noctambus/lassociation-actualites/")
        let requestObj = NSURLRequest(URL: url!)
        conditionsWebView.loadRequest(requestObj)
    }
    
    func loadMentions(){
        let localfilePath = NSBundle.mainBundle().URLForResource("mentions", withExtension: "html");
        let myRequest = NSURLRequest(URL: localfilePath!);
        conditionsWebView.loadRequest(myRequest);
    }
    
    func loadContact(){
        let localfilePath = NSBundle.mainBundle().URLForResource("contact", withExtension: "html");
        let myRequest = NSURLRequest(URL: localfilePath!);
        conditionsWebView.loadRequest(myRequest);
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        if start == false{
            KVNProgress.show()
        }
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        if start == false{
            start = true
            KVNProgress.dismiss()
            
        }
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        print(error)
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
