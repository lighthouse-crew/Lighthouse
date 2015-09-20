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
    let nameDefaultsKey = "name"
    let userIdDefaultsKey = "user_id"
    
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
    
    var name : String? {
        get {
            let defaults = NSUserDefaults.standardUserDefaults()
            let name = defaults.objectForKey(nameDefaultsKey)
            return (name == nil ? nil : (name as! String))
        }
        
        set {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(newValue, forKey: nameDefaultsKey)
        }
    }
    
    var user_id : Int? {
        get {
            let defaults = NSUserDefaults.standardUserDefaults()
            let user_id = defaults.objectForKey(userIdDefaultsKey)
            return (user_id == nil ? nil : (user_id as! Int))
        }
        
        set {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(newValue, forKey: userIdDefaultsKey)
        }
    }
}