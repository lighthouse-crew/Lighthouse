//
//  SidebarViewController.swift
//  Lighthouse
//
//  Created by Jiahao Li on 19/09/2015.
//  Copyright © 2015 Jiahao Li. All rights reserved.
//

import UIKit
import Foundation

class SidebarViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var groupsTableView: UITableView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var houseHeaderView : GroupTableHeaderView?
    var partyHeaderView : GroupTableHeaderView?
    
    override func viewDidLoad() {
        groupsTableView.delegate = self
        groupsTableView.dataSource = self
        
        nameLabel.text = DataStore.sharedStore.name!
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
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("groupCell")
        
        if (cell == nil) {
            cell = GroupTableCell(reuseIdentifier: "groupCell")
        }
        
        let groupCell = cell as! GroupTableCell
        
        if (indexPath.item == 0) {
            groupCell.nameLabel!.text = "Wanna grab tea? "
        } else if (indexPath.item == 1) {
            groupCell.nameLabel!.text = "I have a car"
        } else {
            groupCell.nameLabel!.text = "A taste of 6.046"
        }
        
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
}