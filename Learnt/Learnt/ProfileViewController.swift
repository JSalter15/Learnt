//
//  ProfileViewController.swift
//  Learnt
//
//  Created by Joe Salter on 6/20/16.
//  Copyright © 2016 Joe Salter. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var profPicImageView:UIImageView?
    
    var myPosts:[Post] = []
    
    var user:User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBarHidden = true
        
        user = UserController.sharedInstance.getLoggedInUser()
        myPosts = (user?.posts)!

        self.tableView.registerNib(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomTableViewCell")
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(animated: Bool) {
        user = UserController.sharedInstance.getLoggedInUser()
        print(user?.posts.count)
        myPosts = (user?.posts)!
        
        profPicImageView = UIImageView(frame: CGRectMake(19, 27, 150, 150))
        profPicImageView!.layer.masksToBounds = true
        profPicImageView!.layer.cornerRadius = 8
        profPicImageView?.contentMode = .ScaleToFill
        profPicImageView!.image = user?.profPic
        
        view.addSubview(profPicImageView!)
        
        nameLabel.text = user?.name
        usernameLabel.text = "@" + (user?.username)!
        descriptionLabel.text = user?.descriptor
        
        tableView.reloadData()

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(myPosts.count)
        return myPosts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let post = myPosts[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CustomTableViewCell") as! CustomTableViewCell
        
        cell.profPic.image = post.poster?.profPic
        cell.nameLabel.text = "Today I learned..."
        cell.bodyTextView.text = post.body
        
        return cell
    }
    
    @IBAction func newPostTapped(sender: UIButton) {
        let npvc = NewPostViewController()
        presentViewController(npvc, animated: true, completion: nil)
    }
    
    @IBAction func settingsTapped(sender: UIButton) {
        let alert = UIAlertController(title: "Settings", message: "", preferredStyle: .ActionSheet)
        
        let signoutAction = UIAlertAction(title: "Sign out", style: .Default, handler: {(signoutAction) -> Void in
            UserController.sharedInstance.setLoggedInUser(nil)
            
            let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.navigateToLandingScreen()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {action in
        })
        
        alert.addAction(signoutAction)
        alert.addAction(cancelAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
