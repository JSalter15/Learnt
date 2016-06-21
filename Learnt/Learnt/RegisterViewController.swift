//
//  RegisterViewController.swift
//  Learnt
//
//  Created by Joe Salter on 6/20/16.
//  Copyright © 2016 Joe Salter. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var emailField: EmailValidatedTextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func uploadPhotoTapped(sender: UIButton) {
        imagePicker.delegate = self
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .ScaleToFill
            imageView.image = pickedImage
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func registerButtonTapped(sender: UIButton) {
        let email:String? = emailField.text
        let username:String? = usernameField.text
        let password:String? = passwordField.text
        let profPic:UIImage? = imageView.image
        
        if emailField.validate() {
            let (user, message) = UserController.sharedInstance.registerUser(email!, password: password!, username:username, profPic:profPic)
            
            if (user != nil) {
                print("User registered view registration view")
                
                let success = UIAlertController(title: "Congrats!", message: "You have successfully registered.", preferredStyle: UIAlertControllerStyle.Alert)
                let okButton = UIAlertAction(title: "Okay", style: .Default, handler: nil)
                success.addAction(okButton)
                self.presentViewController(success, animated: true, completion: nil)
                
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
