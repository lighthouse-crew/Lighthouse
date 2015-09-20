//
//  LightView.swift
//  Lighthouse
//
//  Created by Jiahao Li on 19/09/2015.
//  Copyright © 2015 Jiahao Li. All rights reserved.
//

import UIKit
import Foundation

enum LightViewState {
    case Inactive
    case Active
    case InProgress
}

class LightView : UIView {
    
    var state : LightViewState
    
    override init(frame: CGRect) {
        state = .Inactive
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        state = .Inactive
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clearColor()
    }
    
    override func drawRect(rect: CGRect) {
        let w = rect.width
        let h = rect.height
        let color = colorForState(state)
        let path = UIBezierPath(ovalInRect: CGRectMake(0.15 * w, 0.15 * h, 0.7 * w, 0.7 * h))
        color.setFill()
        path.fill()
    }
    
    func colorForState(state : LightViewState) -> UIColor {
        switch (state) {
        case .Inactive:
            return UIColor.grayColor()
        case .Active:
            return UIColor.yellowColor()
        case .InProgress:
            return UIColor.greenColor()
        }
    }
    
}