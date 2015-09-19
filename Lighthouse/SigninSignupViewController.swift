//
//  ViewController.swift
//  Lighthouse
//
//  Created by Jiahao Li on 19/09/2015.
//  Copyright © 2015 Jiahao Li. All rights reserved.
//

import UIKit
import Alamofire

class SigninSignupViewController: UIViewController, UITextFieldDelegate {
    
    var isSignin : Bool;
    
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var switchButton: UIButton!
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var logoView: UIImageView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        isSignin = true
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        isSignin = true
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait;
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
    
    func processSignin() {
        actionButton.setTitle("Signing in...", forState: .Normal)
        
        Alamofire.request(.POST, engineURL + "/users/signin", parameters: [
            "username": usernameField.text!,
            "password": passwordField.text!
        ]).responseJSON { (_, _, result) -> Void in
            if (!result.isSuccess) {
                self.showNetworkErrorAlert()
            } else {
                let value = result.value!
                
                if (value["success"] as! Int == 1) {
                    DataStore.sharedStore.token = (value["token"] as! String)
//                    TODO: redirect to the actual pages
                } else {
                    self.showAlert("Errors", message: "Incorrect username or password. ")
                }
            }
            
            self.actionButton.setTitle("Sign In", forState: .Normal)
            self.actionButton.enabled = true
        }
    }
    
    func processSignup() {
        actionButton.setTitle("Signing up...", forState: .Normal)
        
        Alamofire.request(.POST, engineURL + "/users/signup", parameters: [
            "name": nameField.text!,
            "username": usernameField.text!,
            "password": passwordField.text!
        ]).responseJSON(completionHandler: { (_, _, result) -> Void in
            if (!result.isSuccess) {
                self.showNetworkErrorAlert()
            } else {
                let value = result.value!
                
                if (value["success"] as! Int == 1) {
                    self.processSignin()
                    return
                } else {
                    self.showAlert("Errors", message: (value["errors"] as! [String]).joinWithSeparator("\n"))
                }
            }
            
            self.actionButton.setTitle("Sign Up", forState: .Normal)
            self.actionButton.enabled = true
        })
    }
    
    @IBAction func actionButtonPressed(sender: AnyObject) {
        actionButton.enabled = false
        
        if (isSignin) {
            self.processSignin()
        } else {
            self.processSignup()
        }
    }
    
    @IBAction func switchButtonPressed(sender: AnyObject) {
        isSignin = !isSignin
        
        nameField.hidden = isSignin
        logoView.hidden = !isSignin
        
        if (isSignin) {
            actionButton.setTitle("Sign In", forState: .Normal);
            switchButton.setTitle("Don't have an account? Sign Up", forState: .Normal);
        } else {
            actionButton.setTitle("Sign Up", forState: .Normal);
            switchButton.setTitle("Already have an account? Sign In", forState: .Normal);
        }
    }
    
    @IBAction func textFieldDone(textField: UITextField) {
        textField.resignFirstResponder()
    }
}

