//
//  WelcomeViewController.swift
//  Lighthouse
//
//  Created by Jiahao Li on 19/09/2015.
//  Copyright © 2015 Jiahao Li. All rights reserved.
//

import Alamofire
import Foundation
import UIKit

class WelcomeViewController : UIViewController {
    
    @IBOutlet weak var addPartyButton: UIButton!
    @IBOutlet weak var addHouseButton: UIButton!
    @IBOutlet weak var joinButton: UIButton!
    
    @IBAction func showSidebar(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sidebarViewController = storyboard.instantiateViewControllerWithIdentifier("sidebar")
        sidebarViewController.modalPresentationStyle = .OverCurrentContext
        
        self.presentViewController(sidebarViewController, animated: false, completion: nil)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertView()
        alert.title = title
        alert.message = message
        alert.addButtonWithTitle("OK")
        alert.show()
    }
    
    func showNetworkErrorAlert() {
        showAlert("Network Error", message: "Please try again later. ")
    }
    
    func processAddLightGroup(type: LightGroupType, name: String) {
        var individual : Int
        
        switch (type) {
        case .LightHouse:
            individual = 1
        case .LightParty:
            individual = 0
        }
        
        addHouseButton.enabled = false
        addPartyButton.enabled = false
        joinButton.enabled = false
        
        Alamofire.request(.POST, engineURL + "/light_groups/", parameters: [
            "name": name,
            "individual": individual,
            "listed": 1,
            "token": DataStore.sharedStore.token!
        ]).responseJSON { (_, _, result) -> Void in
            if (!result.isSuccess) {
                self.showNetworkErrorAlert()
            } else {
                let value = result.value!
                
                if (value["success"] as! Int == 0) {
                    self.showAlert("Error", message: (value["errors"] as! [String]).joinWithSeparator("\n"))
                } else {
                    self.showAlert("Success", message: "Successfully created the light house/light party. ")
                }
            }
            
            self.addHouseButton.enabled = true
            self.addPartyButton.enabled = true
            self.joinButton.enabled = true
        }
    }
    
    func processJoin(name: String) {
        addHouseButton.enabled = false
        addPartyButton.enabled = false
        joinButton.enabled = false

        Alamofire.request(.POST, engineURL + "/light_groups/find_and_join", parameters: [
            "token": DataStore.sharedStore.token!,
            "name": name
        ]).responseJSON { (_, _, result) -> Void in
            if (!result.isSuccess) {
                self.showNetworkErrorAlert()
            } else {
                let value = result.value!
                
                if (value["success"] as! Int == 1) {
                    self.showAlert("Success", message: "You have successfully joined the group. ")
                } else {
                    self.showAlert("Error", message: "Error joining the group. The group might not exist. ")
                }
            }
            
            self.addHouseButton.enabled = true
            self.addPartyButton.enabled = true
            self.joinButton.enabled = true
        }
    }
    
    func addLightGroup(type : LightGroupType) {
        var message : String
        
        switch (type) {
        case .LightHouse:
            message = "Create a new light house. "
        case .LightParty:
            message = "Create a new light party. "
        }
        
        let alertController = UIAlertController(title: "Create", message: message, preferredStyle: .Alert)
        
        let addAction = UIAlertAction(title: "Create", style: .Default) { (_) -> Void in
            let name = alertController.textFields![0] 
            self.processAddLightGroup(type, name: name.text!)
        }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Name"
        }
        
        alertController.addAction(addAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func addHousePressed(sender: AnyObject) {
        addLightGroup(LightGroupType.LightHouse)
    }
    
    @IBAction func addPartyPressed(sender: AnyObject) {
        addLightGroup(LightGroupType.LightParty)
    }
    
    @IBAction func joinPartyPressed(sender: AnyObject) {
        let alertController = UIAlertController(title: "Join", message: "Join an existing light house/light party. ", preferredStyle: .Alert)
        
        let joinAction = UIAlertAction(title: "Join", style: .Default) { (_) -> Void in
            let name = alertController.textFields![0]
            self.processJoin(name.text!)
        }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Name"
        }
        
        alertController.addAction(joinAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
