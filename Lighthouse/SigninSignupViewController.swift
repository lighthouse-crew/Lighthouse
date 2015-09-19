//
//  ViewController.swift
//  Lighthouse
//
//  Created by Jiahao Li on 19/09/2015.
//  Copyright © 2015 Jiahao Li. All rights reserved.
//

import UIKit

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
    
    @IBAction func actionButtonPressed(sender: AnyObject) {
        
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

