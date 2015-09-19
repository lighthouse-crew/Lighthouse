//
//  DataStore.swift
//  Lighthouse
//
//  Created by Jiahao Li on 19/09/2015.
//  Copyright © 2015 Jiahao Li. All rights reserved.
//

import Foundation

class DataStore {
    static let sharedStore = DataStore()
    
    let tokenDefaultsKey = "token"
    
    var token : String? {
        get {
            let defaults = NSUserDefaults.standardUserDefaults()
            let token = defaults.objectForKey(tokenDefaultsKey)
            return (token == nil ? nil : (token as! String))
        }
        
        set {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(newValue, forKey: tokenDefaultsKey)
        }
    }
}