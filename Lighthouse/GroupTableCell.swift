//
//  GroupTableCell.swift
//  Lighthouse
//
//  Created by Jiahao Li on 19/09/2015.
//  Copyright © 2015 Jiahao Li. All rights reserved.
//

import UIKit
import Foundation

class GroupTableCell : UITableViewCell {
    
    var nameLabel : UILabel?
    var lightView : LightView?
    
    init(reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .None
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        self.backgroundColor = UIColor.clearColor()
        
        nameLabel = UILabel()
        nameLabel!.textColor = UIColor.whiteColor()
        nameLabel!.backgroundColor = UIColor.clearColor()
        
        lightView = LightView()
        lightView!.state = .Active
        
        self.contentView.addSubview(nameLabel!)
        self.contentView.addSubview(lightView!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        NSLog("Relayouting happening")
        nameLabel!.frame = CGRectMake(0.3 * self.frame.width, 0, 0.7 * self.frame.width, self.frame.height)
        lightView!.frame = CGRectMake(0.25 * self.frame.width - self.frame.height, 0, self.frame.height, self.frame.height)
    }
    
}