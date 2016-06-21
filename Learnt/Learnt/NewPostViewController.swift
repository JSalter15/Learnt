//
//  NewPostViewController.swift
//  Learnt
//
//  Created by Joe Salter on 6/20/16.
//  Copyright © 2016 Joe Salter. All rights reserved.
//

import UIKit

class NewPostViewController: UIViewController, UIGestureRecognizerDelegate, UITextViewDelegate {

    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let user = UserController.sharedInstance.getLoggedInUser()
        header.text = "Today @\((user?.username)!) learned..."
        
        textView.delegate = self
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tapRecognizer.delegate = self
        textView.addGestureRecognizer(tapRecognizer)
        
        let numberToolbar = UIToolbar(frame: CGRectMake(0, 0, self.view.frame.size.width, 50))
        numberToolbar.barStyle = UIBarStyle.Default
        numberToolbar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Post", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.handlePost(_:)))]
        numberToolbar.sizeToFit()
        textView.inputAccessoryView = numberToolbar
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            if (textView.text == "") {
                textView.text = "drop some knowledge here"
                textView.textColor = UIColor.lightGrayColor()
                
                let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
                tapRecognizer.delegate = self
                textView.addGestureRecognizer(tapRecognizer)
                
            }
            return false
        }
        return true
    }
    
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        print("hi")
        if textView.text == "drop some knowledge here" {
            textView.text = ""
            textView.textColor = UIColor.blackColor()
            textView.becomeFirstResponder()
        }
    }
    
    func handlePost(sender: UIBarButtonItem) {
        let poster = UserController.sharedInstance.getLoggedInUser()
        print(poster!.email)
        let post:Post = Post(poster: poster, body: textView.text, date: NSDate(), favoriters: [], reposters: [])
        
        PostController.sharedInstance.newPost(post)
        poster?.posts.append(post)
        UserController.sharedInstance.newPostForUser(post)
        //print(poster?.posts.count)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func closeButtonTapped(sender: UIButton) {
        textView.resignFirstResponder()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
