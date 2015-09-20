//
//  GroupTableHeaderView.swift
//  Lighthouse
//
//  Created by Jiahao Li on 19/09/2015.
//  Copyright © 2015 Jiahao Li. All rights reserved.
//

import UIKit
import Foundation

enum LightGroupType {
    case LightHouse
    case LightParty
}

class GroupTableHeaderView : UIView {
    
    var imageView : UIImageView?
    var typeLabel : UILabel?
    
    var type : LightGroupType {
        didSet {
            switch (type) {
            case .LightHouse:
                imageView!.image = UIImage(named: "Light House")
                typeLabel!.text = "Light Houses"
            case .LightParty:
                imageView!.image = UIImage(named: "Light Party")
                typeLabel!.text = "Light Parties"
            }
        }
    }
    
    override init(frame: CGRect) {
        imageView = UIImageView()
        typeLabel = UILabel()
        typeLabel!.textColor = UIColor.whiteColor()
        typeLabel!.backgroundColor = UIColor.clearColor()
        type = .LightHouse
        super.init(frame: frame)
        self.addSubview(imageView!)
        self.addSubview(typeLabel!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        type = .LightHouse
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        let imageSize = 0.15 * self.frame.width
        
        imageView!.frame = CGRectMake(0.23 * self.frame.width - imageSize, 0.5 * (self.frame.height - imageSize), imageSize, imageSize)
        typeLabel!.frame = CGRectMake(0.3 * self.frame.width, 0, 0.6 * self.frame.width, self.frame.height)
    }
    
}
