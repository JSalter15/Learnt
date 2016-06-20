//
//  NewsfeedViewController.swift
//  Learnt
//
//  Created by Joe Salter on 6/20/16.
//  Copyright © 2016 Joe Salter. All rights reserved.
//

import UIKit

class NewsfeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var allPosts:[Post] = []
    var followedPosts:[Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Learnt"
        let newPostButton = UIBarButtonItem(image: UIImage(named: "new_post"), style: .Plain, target: self, action: #selector(newPostTapped))
        
        navigationItem.rightBarButtonItem = newPostButton
        
        allPosts = PostController.sharedInstance.getPosts()
        let user = UserController.sharedInstance.getLoggedInUser()
        followedPosts = PostController.sharedInstance.getPostsForUser(user!)
        
        self.tableView.registerNib(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomTableViewCell")
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        allPosts = PostController.sharedInstance.getPosts()
        let user = UserController.sharedInstance.getLoggedInUser()
        followedPosts = PostController.sharedInstance.getPostsForUser(user!)
        
        tableView.reloadData()

    }

    func newPostTapped() {
        let npvc = NewPostViewController()
        presentViewController(npvc, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(followedPosts.count)
        print(allPosts.count)
        //return followedPosts.count
        return allPosts.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let post = allPosts[indexPath.row]

        //let post = followedPosts[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("CustomTableViewCell") as! CustomTableViewCell
        
        cell.profPic.image = post.poster?.profPic
        cell.nameLabel.text = "Today @\((post.poster?.username)!) learned..."
        cell.bodyTextView.text = post.body
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
