//
//  NewPostViewController.swift
//  Learnt
//
//  Created by Joe Salter on 6/20/16.
//  Copyright © 2016 Joe Salter. All rights reserved.
//

import UIKit

class NewPostViewController: UIViewController {

    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let user = UserController.sharedInstance.getLoggedInUser()
        header.text = "Today @\((user?.username)!) learned..."
    }

    @IBAction func closeButtonTapped(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func postButtonTapped(sender: UIButton) {
        let poster = UserController.sharedInstance.getLoggedInUser()
        
        let post:Post = Post(poster: poster, body: textView.text, date: NSDate(), favoriters: [], reposters: [])
        
        PostController.sharedInstance.newPost(post)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
