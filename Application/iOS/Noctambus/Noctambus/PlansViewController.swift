//
//  PlansViewController.swift
//  Noctambus
//
//  Created by Luca Falvo on 26.12.15.
//  Copyright © 2015 Noctambus. All rights reserved.
//

import UIKit

class PlansViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var planImageView: UIImageView!
    @IBOutlet weak var titlePlanNavigationItem: UINavigationItem!
    
    var nameTitle = String()
    var nameImage = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titlePlanNavigationItem.title = nameTitle
        planImageView.image = UIImage(named: nameImage)
        
        self.scrollView.minimumZoomScale = 0.5
        self.scrollView.maximumZoomScale  = 1.7
        self.scrollView.zoomScale = 0.5

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.planImageView
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
