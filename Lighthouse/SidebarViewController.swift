//
//  SidebarViewController.swift
//  Lighthouse
//
//  Created by Jiahao Li on 19/09/2015.
//  Copyright © 2015 Jiahao Li. All rights reserved.
//

import UIKit
import Foundation

class SidebarViewController : UIViewController {
    
    override func viewWillAppear(animated: Bool) {
        let slidein = CATransition()
        
        slidein.delegate = self
        slidein.type = kCATransitionPush
        slidein.subtype = kCATransitionFromLeft
        slidein.duration = 0.5
        slidein.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    
        self.view.layer.addAnimation(slidein, forKey: kCATransition)
    }
    
    @IBAction func dismissSidebar(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
}