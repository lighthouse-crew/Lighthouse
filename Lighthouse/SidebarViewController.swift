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