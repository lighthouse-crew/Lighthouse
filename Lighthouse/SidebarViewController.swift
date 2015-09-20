//
//  SidebarViewController.swift
//  Lighthouse
//
//  Created by Jiahao Li on 19/09/2015.
//  Copyright © 2015 Jiahao Li. All rights reserved.
//

import UIKit
import Alamofire
import Foundation

class SidebarViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var addPartyButton: UIButton!
    @IBOutlet weak var addHouseButton: UIButton!
    @IBOutlet weak var joinButton: UIButton!
    
    @IBOutlet weak var groupsTableView: UITableView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var dismissButton: UIButton!
    
    var welcomeViewController : WelcomeViewController?
    
    var houseHeaderView : GroupTableHeaderView?
    var partyHeaderView : GroupTableHeaderView?
    
    var groups : [LightGroupType: [AnyObject]]?;
    
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
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
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
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        groupsTableView.delegate = self
        groupsTableView.dataSource = self
        
        nameLabel.text = DataStore.sharedStore.name!
        
        groups = [LightGroupType: [AnyObject]]()
        groups![.LightHouse] = []
        groups![.LightParty] = []
        
        Alamofire.request(.GET, engineURL + "/users/" + String(DataStore.sharedStore.user_id!) + "/light_groups", parameters: [
            "token": DataStore.sharedStore.token!
        ]).responseJSON { (_, _, result) -> Void in
            if (!result.isSuccess) {
                self.showNetworkErrorAlert();
            } else {
                let value = result.value! as! [String: AnyObject]
                
                if (value["success"] as! Int == 1) {
                    self.groups![.LightHouse]!.removeAll()
                    self.groups![.LightParty]!.removeAll()
                
                    for group in value["light_groups"] as! [AnyObject] {
                        if (group["individual"] as! Bool) {
                            self.groups![.LightHouse]!.append(group)
                        } else {
                            self.groups![.LightParty]!.append(group)
                        }
                    }
                    
                    self.groupsTableView!.reloadData()
                } else {
                    self.showAlert("Errors", message: "Error retrieving your light groups. ")
                }
            }
        }
    }
    
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
    
    // UITableViewDelegate
    
    // UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 0:
            return groups![.LightHouse]!.count;
        case 1:
            return groups![.LightParty]!.count;
        default:
            return 0;
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("groupCell")
        
        if (cell == nil) {
            cell = GroupTableCell(reuseIdentifier: "groupCell")
        }
        
        let groupCell = cell as! GroupTableCell
        var type : LightGroupType;
        
        switch (indexPath.section) {
        case 0:
            type = .LightHouse;
        case 1:
            type = .LightParty;
        default:
            type = .LightHouse;
        }
        
        groupCell.nameLabel!.text = groups![type]![indexPath.item]["name"] as! String
        groupCell.lightView!.state = LightView.stateForInteger(groups![type]![indexPath.item]["my_state"] as! Int)
        
        return groupCell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (houseHeaderView == nil) {
            houseHeaderView = GroupTableHeaderView()
            houseHeaderView!.type = .LightHouse
        }
        
        if (partyHeaderView == nil) {
            partyHeaderView = GroupTableHeaderView()
            partyHeaderView!.type = .LightParty
        }
        
        switch (section) {
        case 0:
            return houseHeaderView
        case 1:
            return partyHeaderView
        default:
            return houseHeaderView
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var type : LightGroupType
        
        switch (indexPath.section) {
        case 0:
            type = .LightHouse
        default:
            type = .LightParty
        }

        let id = groups![type]![indexPath.item]["id"] as! Int
        
        welcomeViewController!.setGroupId(id)
        
        dismissSidebar(self)
    }
}