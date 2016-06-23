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
    
    var charLength:UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        header.text = "Today I learned..."
        header.textColor = UIColor.orangeColor()
        
        textView.delegate = self
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tapRecognizer.delegate = self
        textView.addGestureRecognizer(tapRecognizer)
        
        charLength =  UIBarButtonItem(title: "140", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        charLength?.enabled = false
        
        let postButton = UIBarButtonItem(title: "Post", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.handlePost(_:)))
        postButton.tintColor = UIColor.orangeColor()
        
        let numberToolbar = UIToolbar(frame: CGRectMake(0, 0, self.view.frame.size.width, 50))
        numberToolbar.barStyle = UIBarStyle.Default
        numberToolbar.items = [
            charLength!,
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil),
            postButton]
        numberToolbar.sizeToFit()
        textView.inputAccessoryView = numberToolbar
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let lengthLeft = 140 - textView.text.characters.count - 1
        //var inHashtag:Bool = false
        
        print(textView.text.characters.count)
        
        let  char = text.cStringUsingEncoding(NSUTF8StringEncoding)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92) {
            if textView.text == "" {
                charLength?.title = String(lengthLeft + 1)
            }
            else {
                charLength?.title = String(lengthLeft + 2)
            }
            return true
        }
        
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
        
        if lengthLeft >= 0 {
            charLength?.title = String(lengthLeft)
        }
        return lengthLeft >= 0
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
        poster!.posts.insert(post, atIndex: 0)
        UserController.sharedInstance.newPostForUser(post)
        print(poster!.posts.count)
        
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
