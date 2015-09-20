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

class WelcomeViewController : UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var inactiveButton: UIButton!
    @IBOutlet weak var activeButton: UIButton!
    @IBOutlet weak var inProgressButton: UIButton!
    @IBOutlet weak var detailsTableView: UITableView!
    
    var group_id : Int?;
    
    var details : [[String : AnyObject]]?
    
    @IBAction func showSidebar(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sidebarViewController = storyboard.instantiateViewControllerWithIdentifier("sidebar") as! SidebarViewController
        sidebarViewController.welcomeViewController = self
        sidebarViewController.modalPresentationStyle = .OverCurrentContext
        
        self.presentViewController(sidebarViewController, animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        detailsTableView.dataSource = self
    }
    
    override func viewDidAppear(animated: Bool) {
        UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Alert, categories: nil))
        UIApplication.sharedApplication().registerForRemoteNotifications()
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
    
    func retrieveDetails() {
        Alamofire.request(.GET, engineURL + "/light_groups/" + String(group_id!), parameters: [
            "token": DataStore.sharedStore.token!,
        ]).responseJSON { (_, _, result) -> Void in
            if (!result.isSuccess) {
                self.showNetworkErrorAlert()
            } else {
                let value = result.value!
                NSLog(String(value))
                
                if (value["success"] as! Int == 1) {
                    self.details = value["members"] as! [[String: AnyObject]]
                    self.detailsTableView.reloadData()
                    self.prepareStateButtons(LightView.stateForInteger(self.details![0]["state"] as! Int))
                } else {
                    self.showAlert("Error", message: "Error reloading light house/light party details. ")
                }
            }
        }
    }
    
    func setGroupId(id: Int?) {
        group_id = id
    
        if (id == nil) {
            inactiveButton.hidden = true
            activeButton.hidden = true
            inProgressButton.hidden = true
            detailsTableView.hidden = true
        } else {
            inactiveButton.hidden = false
            activeButton.hidden = false
            inProgressButton.hidden = false
            detailsTableView.hidden = false
            
            retrieveDetails()
        }
    }
    
    func prepareStateButtons(currentState : LightViewState) {
        inactiveButton.enabled = false
        activeButton.enabled = false
        inProgressButton.enabled = false
        
        switch (currentState) {
        case .Inactive:
            activeButton.enabled = true
        case .Active:
            inProgressButton.enabled = true
            inactiveButton.enabled = true
        case .InProgress:
            inactiveButton.enabled = true
        }
    }
    
    func updateLight(status: Int, label:String = "") {
        
        inactiveButton.enabled = false
        activeButton.enabled = false
        inProgressButton.enabled = false
        
        Alamofire.request(.POST, engineURL + "/light_groups/" + String(group_id!) + "/update_light", parameters: [
            "state": status,
            "label": label,
            "token": DataStore.sharedStore.token!
        ]).responseJSON { (_, _, result) -> Void in
            if (!result.isSuccess) {
                self.showNetworkErrorAlert()
            } else {
                let value = result.value!
                
                if (value["success"] as! Int == 1) {
                    self.showAlert("Success", message: "You've successfully changed your light status. ")
                    self.retrieveDetails()
                    self.prepareStateButtons(LightView.stateForInteger(status))
                } else {
                    self.showAlert("Error", message: "Error changing light status. ")
                }
            }
        }
    }
    

    
    
    @IBAction func inactivePressed(sender: AnyObject) {
        updateLight(0)
    }
    
    @IBAction func activePressed(sender: AnyObject) {
        //do the alert, in callback function update the light.
        let alertController = UIAlertController(title: "Set Label", message: "Label your activity." , preferredStyle: .Alert)
        
        let setLabelAction = UIAlertAction(title: "Set Label", style: .Default) { (_) -> Void in
            let label = alertController.textFields![0]
            self.updateLight(1, label: label.text!)
        }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Label"
        }
        
        alertController.addAction(setLabelAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func inProgressPressed(sender: AnyObject) {
        updateLight(2)
    }
    
    // Data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return details == nil ? 0 : details!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("detail")
        
        if (cell == nil) {
            cell = UITableViewCell(style: .Value1, reuseIdentifier: "detail")
        }
        
        let state = details![indexPath.item]["state"] as! Int
        
        switch (LightView.stateForInteger(state)) {
        case .Inactive:
            cell!.imageView!.image = UIImage(named: "Inactive")
        case .Active:
            cell!.imageView!.image = UIImage(named: "Active")
        case .InProgress:
            cell!.imageView!.image = UIImage(named: "InProgress")
        }
        cell!.textLabel!.text = details![indexPath.item]["user_name"] as! String
        var label = details![indexPath.item]["label"] as? String
        if (label == nil) {
            label = ""
        }
        cell!.detailTextLabel!.text = label
        
        return cell!
    }
}
