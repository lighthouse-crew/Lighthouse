//
//  WelcomeViewController.swift
//  Lighthouse
//
//  Created by Jiahao Li on 19/09/2015.
//  Copyright © 2015 Jiahao Li. All rights reserved.
//

import Foundation
import UIKit

class WelcomeViewController : UIViewController {
    
    @IBAction func showSidebar(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sidebarViewController = storyboard.instantiateViewControllerWithIdentifier("sidebar")
        sidebarViewController.modalPresentationStyle = .OverCurrentContext
        
        self.presentViewController(sidebarViewController, animated: false, completion: nil)
    }
}
