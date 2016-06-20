//
//  LandingScreenViewController.swift
//  Learnt
//
//  Created by Joe Salter on 6/20/16.
//  Copyright © 2016 Joe Salter. All rights reserved.
//

import UIKit

class LandingScreenViewController: UIViewController {

    @IBOutlet weak var emailField: EmailValidatedTextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Welcome!"
        navigationController?.navigationBarHidden = false
    }

    @IBAction func loginButtonTapped(sender: UIButton) {
        let email:String? = emailField.text
        let password:String? = passwordField.text
        
        if emailField.validate() {
            let (user, message) = UserController.sharedInstance.loginUser(email!, password: password!)
            
            if (user != nil) {
                print("User logged in")
                
                let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.navigateToHomeScreen()
            }
            else if (message != nil) {
                let error = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                let okButton = UIAlertAction(title: "Okay", style: .Default, handler: nil)
                error.addAction(okButton)
                
                self.presentViewController(error, animated: true, completion: nil)
            }
        }
    }
    
    
    @IBAction func registerButtonTapped(sender: UIButton) {
        let rvc = RegisterViewController()
        navigationController?.pushViewController(rvc, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
