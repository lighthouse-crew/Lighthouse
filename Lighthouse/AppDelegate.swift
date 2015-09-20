//
//  AppDelegate.swift
//  Lighthouse
//
//  Created by Jiahao Li on 19/09/2015.
//  Copyright © 2015 Jiahao Li. All rights reserved.
//

import Alamofire
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

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

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let token = deviceToken.description.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "<>"))
        let actualToken = token.stringByReplacingOccurrencesOfString(" ", withString: "")
        
        NSLog(actualToken)
        
        Alamofire.request(.POST, engineURL + "/users/" + String(DataStore.sharedStore.user_id!) + "/submit_token", parameters: [
            "token": DataStore.sharedStore.token!,
            "device_token": actualToken
        ]).responseJSON { (_, _, result) -> Void in
            if (!result.isSuccess) {
                self.showNetworkErrorAlert()
            } else {
                let value = result.value!
                
                if (value["success"] as! Int != 1) {
                    self.showAlert("Error", message: "Error subscribing for push notifications. ")
                }
            }
        }
    }


}

