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
    
    var user:User?
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        let newPostButton = UIBarButtonItem(image: UIImage(named: "new_post"), style: .Plain, target: self, action: #selector(newPostTapped))
        newPostButton.tintColor = UIColor.orangeColor()
        let searchButton = UIBarButtonItem(image: UIImage(named: "search"), style: .Plain, target: self, action: nil)
        searchButton.tintColor = UIColor.orangeColor()
        navigationItem.setRightBarButtonItems([newPostButton, searchButton], animated: true)
        //navigationItem.rightBarButtonItem = newPostButton
        
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
        
        user = UserController.sharedInstance.getLoggedInUser()
        //followedPosts = PostController.sharedInstance.getPostsForUser(user!)
        
        self.tableView.registerNib(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomTableViewCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Release to refresh")
        refreshControl.addTarget(self, action: #selector(self.refreshTable), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
    }
    
    func refreshTable() {
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    override func viewWillAppear(animated: Bool) {
        user = UserController.sharedInstance.getLoggedInUser()
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
        var length = 0
        
        if post.body?.characters.count > 100 {
            length = 110
        }
        else if post.body?.characters.count > 70 {
            length = 100
        }
        else {
            length = 70
        }

        return CGFloat(length)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let post = allPosts[indexPath.row]

        //let post = followedPosts[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("CustomTableViewCell") as! CustomTableViewCell
        
        cell.profPicImageView!.image = post.poster?.profPic
        
        if user?.email == post.poster?.email {
            cell.nameLabel.text = "⭐️Today I learned..."
        }
        else {
            cell.nameLabel.text = "Today @\((post.poster?.username)!) learned..."
        }
        cell.bodyTextView.text = post.body
        
        let currentDate:NSDate = NSDate()
        let oneDayAgo = currentDate.addDays(-1)
        let oneHourAgo = currentDate.addHours(-1)
        
        let currDateFormatter = NSDateFormatter()
        currDateFormatter.locale = NSLocale.currentLocale()
        currDateFormatter.dateFormat = "MM/dd/yy"
        let currDate:String = currDateFormatter.stringFromDate(currentDate)

        let postDateFormatter = NSDateFormatter()
        postDateFormatter.locale = NSLocale.currentLocale()
        postDateFormatter.dateFormat = "MM/dd/yy"
        let postDate:String = postDateFormatter.stringFromDate(post.date)
        
        let postMinFormatter = NSDateFormatter()
        postMinFormatter.locale = NSLocale.currentLocale()
        postMinFormatter.dateFormat = "m"
        let postMin:Int = Int(postMinFormatter.stringFromDate(post.date))!
        
        let currMinFormatter = NSDateFormatter()
        currMinFormatter.locale = NSLocale.currentLocale()
        currMinFormatter.dateFormat = "m"
        let currMin:Int = Int(currMinFormatter.stringFromDate(currentDate))!
        
        let postHourFormatter = NSDateFormatter()
        postHourFormatter.locale = NSLocale.currentLocale()
        postHourFormatter.dateFormat = "H"
        let postHour:Int = Int(postHourFormatter.stringFromDate(post.date))!
        
        let currHourFormatter = NSDateFormatter()
        currHourFormatter.locale = NSLocale.currentLocale()
        currHourFormatter.dateFormat = "H"
        let currHour:Int = Int(currHourFormatter.stringFromDate(currentDate))!
        
        if post.date.isLessThanDate(oneDayAgo) {
            cell.dateLabel.text = currDate
            return cell
        }
        
        else if post.date.isGreaterThanDate(oneHourAgo) {
            if postHour == currHour {
                cell.dateLabel.text = String(currMin - postMin) + "m"
            }
            else {
                cell.dateLabel.text = String(currMin + (60 - postMin)) + "m"
            }
            return cell
        }
        
        else {
            if postDate == currDate {
                cell.dateLabel.text = String(currHour - postHour) + "h"
            }
            else {
                cell.dateLabel.text = String(currHour + (24 - postHour)) + "h"
            }
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        let post = allPosts[indexPath.row]
        if post.poster?.email == user?.email {
            return true
        }
        else {
            return false
        }
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        // Delete action
        let delete = UITableViewRowAction(style: .Normal, title: "Delete") { action, index in
            print("Delete tapped")
            
            let alert = UIAlertController(title: "Delete", message: "Are you sure?", preferredStyle: .ActionSheet)
            
            let okAction = UIAlertAction(title: "Okay", style: .Default, handler: {(okAction) -> Void in
                PostController.sharedInstance.removePost(indexPath.row)
                self.allPosts.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {action in
                tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Right)
            })
            
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        delete.backgroundColor = UIColor.redColor()
        
        return [delete]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
