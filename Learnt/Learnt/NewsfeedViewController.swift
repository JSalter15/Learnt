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
    //var followedPosts:[Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        let newPostButton = UIBarButtonItem(image: UIImage(named: "new_post"), style: .Plain, target: self, action: #selector(newPostTapped))
        newPostButton.tintColor = UIColor.orangeColor()
        navigationItem.rightBarButtonItem = newPostButton
        
        /*let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 46, height: 46))
        imageView.contentMode = .ScaleAspectFit
        let image = UIImage(named: "lightbulb")
        imageView.image = image
        navigationItem.titleView = imageView*/
        
        let logo = UIBarButtonItem(image: UIImage(named: "logo"), style: .Plain, target: self, action: nil)
        logo.tintColor = UIColor.orangeColor()
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        negativeSpacer.width = -12
        navigationItem.setLeftBarButtonItems([negativeSpacer, logo], animated: true)
        
        allPosts = PostController.sharedInstance.getPosts()
        
        //let user = UserController.sharedInstance.getLoggedInUser()
        //followedPosts = PostController.sharedInstance.getPostsForUser(user!)
        
        self.tableView.registerNib(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomTableViewCell")
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
//        let user = UserController.sharedInstance.getLoggedInUser()
//        followedPosts = PostController.sharedInstance.getPostsForUser(user!)
//        sortPosts()
        allPosts = PostController.sharedInstance.getPosts()
        tableView.reloadData()

    }
    
    /*func sortPosts() { // should probably be called sort and not filter
        followedPosts.sortInPlace() { $0.date!.compare($1.date!) == NSComparisonResult.OrderedDescending }
    }*/

    func newPostTapped() {
        let npvc = NewPostViewController()
        presentViewController(npvc, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(followedPosts.count)
        //print(allPosts.count)
        //return followedPosts.count
        return allPosts.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let post = allPosts[indexPath.row]
        let user = UserController.sharedInstance.getLoggedInUser()
        var length = 0
        
        if post.body?.characters.count > 100 {
            length = 90
        }
        else {
            length = 70
        }
        if post.poster?.email == user?.email {
            length = length + 25
        }
        return CGFloat(length)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let post = allPosts[indexPath.row]

        //let post = followedPosts[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("CustomTableViewCell") as! CustomTableViewCell
        
        cell.profPic.image = post.poster?.profPic
        cell.nameLabel.text = "Today @\((post.poster?.username)!) learned..."
        cell.bodyTextView.text = post.body
        
        let currentDate:NSDate = NSDate()
        let oneDayAgo = currentDate.addDays(-1)
        let oneHourAgo = currentDate.addHours(-1)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.currentLocale()
        let dateFormatter2 = NSDateFormatter()
        dateFormatter.locale = NSLocale.currentLocale()
        
        let user = UserController.sharedInstance.getLoggedInUser()
        if post.poster?.email == user?.email {
            cell.trashButton.hidden = false
            cell.trashButton.tag = indexPath.row
            cell.trashButton.addTarget(self, action: #selector(trashTapped(_:)), forControlEvents: .TouchUpInside)
        }
        else {
            cell.trashButton.hidden = true
        }
        
        if post.date.isLessThanDate(oneDayAgo) {
            dateFormatter.dateFormat = "MM/dd/yy"
            let convertedDate:String = dateFormatter.stringFromDate(post.date)
            cell.dateLabel.text = convertedDate
        }
        else if post.date.isGreaterThanDate(oneHourAgo) {
            dateFormatter.dateFormat = "m"
            let postMin:Int = Int(dateFormatter.stringFromDate(post.date))!
            
            dateFormatter2.dateFormat = "m"
            let currentMin:Int = Int(dateFormatter2.stringFromDate(currentDate))!
            
            cell.dateLabel.text = String(currentMin - postMin) + "m"
        }
            
        else {
            dateFormatter.dateFormat = "H"
            let postHour:Int = Int(dateFormatter.stringFromDate(post.date))!

            dateFormatter2.dateFormat = "H"
            let currentHour:Int = Int(dateFormatter2.stringFromDate(currentDate))!

            cell.dateLabel.text = String(currentHour - postHour) + "h"
        }
        
        return cell
    }
    
    func trashTapped(sender: UIButton) {
        print("hi")
        print(sender.tag)
        
        /*let indexPath:NSIndexPath = NSIndexPath(forRow: sender.tag, inSection: 1)
        
        self.allPosts.removeAtIndex(sender.tag)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
