//
//  DetailViewController.swift
//  Lighthouse
//
//  Created by Mitchell Gu on 9/20/15.
//  Copyright © 2015 Jiahao Li. All rights reserved.
//

import Alamofire
import Foundation
import UIKit

class DetailViewController : UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var detailTitle: UINavigationItem!
    @IBOutlet weak var statusSelector: UISegmentedControl!
    @IBOutlet weak var detailsTableView: UITableView!
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    var group_id : Int?;
    
    var details : [[String : AnyObject]]?
    
    var STATUS_IMAGES = [
        UIImage(named: "grayLogo.png"),
        UIImage(named: "yellowLogo.png"),
        UIImage(named: "greenLogo.png")]
    
    override func viewDidLoad() {
        detailsTableView.dataSource = self
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
                        self.detailTitle.title = value["name"] as! String
                        self.details = value["members"] as! [[String: AnyObject]]
                        self.detailsTableView.reloadData()
                        let myState = self.details![0]["state"] as! Int
                        self.prepareStateButtons(LightView.stateForInteger(myState))
                        self.statusSelector.selectedSegmentIndex = myState
                        self.statusImage.image = self.STATUS_IMAGES[myState]
                    } else {
                        self.showAlert("Error", message: "Error reloading light house/light party details. ")
                    }
                }
        }
    }
    
    func setGroupId(id: Int?) {
        group_id = id
        //userLabel.text = "Hi" //DataStore.sharedStore.name!
        retrieveDetails()
    }
    
    func prepareStateButtons(currentState : LightViewState) {
        switch (currentState) {
        case .Inactive:
            statusSelector.setEnabled(true, forSegmentAtIndex: 0)
            statusSelector.setEnabled(true, forSegmentAtIndex: 1)
            statusSelector.setEnabled(false, forSegmentAtIndex: 2)
        case .Searching:
            statusSelector.setEnabled(true, forSegmentAtIndex: 0)
            statusSelector.setEnabled(true, forSegmentAtIndex: 1)
            statusSelector.setEnabled(true, forSegmentAtIndex: 2)
        case .Active:
            statusSelector.setEnabled(true, forSegmentAtIndex: 0)
            statusSelector.setEnabled(false, forSegmentAtIndex: 1)
            statusSelector.setEnabled(true, forSegmentAtIndex: 2)
        }
    }
    
    func updateLight(status: Int, label:String = "") {
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
    
    @IBAction func backButtonPressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    @IBAction func statusPressed(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0,2:
            updateLight(sender.selectedSegmentIndex)
        case 1:
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
        default:
            NSLog("invalid segmented button press")
        }
        retrieveDetails()
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
        case .Searching:
            cell!.imageView!.image = UIImage(named: "Active")
        case .Active:
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