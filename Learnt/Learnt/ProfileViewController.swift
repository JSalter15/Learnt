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
    @IBOutlet weak var newPostButton: UIButton!
    @IBOutlet weak var postsButton: UIButton!
    @IBOutlet weak var favoritesButton: UIButton!
    @IBOutlet weak var outlineView: UIView!
    
    var profPicImageView:UIImageView?
    
    var myPosts:[Post] = []
    var favoritedPosts:[Post] = []
    
    var user:User?
    
    var refreshControl: UIRefreshControl!
    
    var onPosts:Bool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBarHidden = true
        
        user = UserController.sharedInstance.getLoggedInUser()
        let allPosts = PostController.sharedInstance.getPosts()
        myPosts = []
        for post in allPosts {
            if post.poster!.email == user?.email {
                myPosts.append(post)
            }
        }
        
        self.tableView.registerNib(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomTableViewCell")

        favoritesButton.backgroundColor = UIColor.whiteColor()
        favoritesButton.layer.borderWidth = 1
        favoritesButton.layer.borderColor = UIColor.orangeColor().CGColor
        favoritesButton.layer.cornerRadius = 5
        favoritesButton.titleLabel?.textColor = UIColor.orangeColor()
        
        postsButton.layer.cornerRadius = 5
        postsButton.backgroundColor = UIColor.orangeColor()
        postsButton.layer.borderWidth = 1
        postsButton.layer.borderColor = UIColor.orangeColor().CGColor
        
        outlineView.layer.borderWidth = 0.5
        outlineView.layer.borderColor = UIColor.grayColor().CGColor

        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Release to refresh")
        refreshControl.addTarget(self, action: #selector(self.refreshTable), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let josh:User = User(email: "Josh", password: "Josh", username: "JBroomberg", profPic: UIImage(named: "josh.jpg"), name: "Josh", descriptor: "Josh", posts: [], followerList: [], followingList: [], favoritedList: [], repostList: [])
        let post1:Post = Post(poster: josh, body: "how to code.", date: NSDate(), favoriters: [], reposters: [])
        
        let julian:User = User(email: "Julian", password: "Julian", username: "JHulme", profPic: UIImage(named: "julian.jpg"), name: "Julian", descriptor: "Julian", posts: [], followerList: [], followingList: [], favoritedList: [], repostList: [])
        let post2:Post = Post(poster: julian, body: "how to teach delegates to his class.", date: NSDate(), favoriters: [], reposters: [])
        
        let aaron:User = User(email: "Aaron", password: "Aaron", username: "AFuchs", profPic: UIImage(named: "aaron.jpg"), name: "Aaron", descriptor: "Aaron", posts: [], followerList: [], followingList: [], favoritedList: [], repostList: [])
        let post3:Post = Post(poster: aaron, body: "how to give a bunch of college kids a chance to come to Cape Town for one hell of an epic summer!", date: NSDate(), favoriters: [], reposters: [])
        
        let ale:User = User(email: "Ale", password: "Ale", username: "Ale", profPic: UIImage(named: "ale.jpg"), name: "Ale", descriptor: "Ale", posts: [], followerList: [], followingList: [], favoritedList: [], repostList: [])
        let post4:Post = Post(poster: ale, body: "how to make a BoardView", date: NSDate(), favoriters: [], reposters: [])
        
        favoritedPosts = [post1, post2, post3, post4]
    }
    
    override func viewDidAppear(animated: Bool) {
        user = UserController.sharedInstance.getLoggedInUser()
        let allPosts = PostController.sharedInstance.getPosts()
        myPosts = []
        for post in allPosts {
            if post.poster!.email == user?.email {
                myPosts.append(post)
            }
        }
        
        profPicImageView = UIImageView(frame: CGRectMake(19, 27, 150, 150))
        profPicImageView!.layer.masksToBounds = true
        profPicImageView!.layer.cornerRadius = 8
        profPicImageView?.contentMode = .ScaleAspectFill
        profPicImageView!.image = user?.profPic

        
        
        view.addSubview(profPicImageView!)
        
        nameLabel.text = user?.name
        nameLabel.textColor = UIColor.orangeColor()
        usernameLabel.text = "@" + (user?.username)!
        usernameLabel.textColor = UIColor.orangeColor()
        descriptionLabel.text = user?.descriptor
        descriptionLabel.textColor = UIColor.orangeColor()
        
        tableView.reloadData()

    }
    
    func refreshTable() {
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if onPosts {
            return myPosts.count
        }
        else {
            return favoritedPosts.count
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var post:Post
        if onPosts {
            post = myPosts[indexPath.row]
        }
        else {
            post = favoritedPosts[indexPath.row]
        }
        
        var length = 0
        
        if post.body?.characters.count > 110 {
            length = 140
        }
        else if post.body?.characters.count > 60 {
            length = 120
        }
        else if post.body?.characters.count > 36 {
            length = 100
        }
        else {
            length = 75
        }
        
        return CGFloat(length)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var post:Post
        if onPosts {
            post = myPosts[indexPath.row]
        }
        
        else {
            post = favoritedPosts[indexPath.row]
        }
        
        //let post = followedPosts[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("CustomTableViewCell") as! CustomTableViewCell
        
        cell.profPicImageView?.contentMode = .ScaleAspectFill
        cell.bodyTextView.text = post.body
        
        if onPosts {
            cell.profPicImageView!.image = user?.profPic
            cell.nameLabel.text = "⭐️Today I learned..."
            cell.favoriteHeart.setImage(UIImage(named: "grayHeart.png"), forState: .Normal)
        }
        else {
            cell.profPicImageView!.image = post.poster?.profPic
            cell.nameLabel.text = "Today @\((post.poster?.username)!) learned..."
            cell.favoriteHeart.setImage(UIImage(named: "orangeHeart.png"), forState: .Normal)
            cell.dateLabel.text = "6/23/16"
            return cell
        }
        
        
        let currentDate:NSDate = NSDate()
        let oneDayAgo = currentDate.addDays(-1)
        let oneHourAgo = currentDate.addHours(-1)
        
        let currDateFormatter = NSDateFormatter()
        currDateFormatter.locale = NSLocale.currentLocale()
        currDateFormatter.dateFormat = "M/dd/yy"
        let currDate:String = currDateFormatter.stringFromDate(currentDate)
        
        let postDateFormatter = NSDateFormatter()
        postDateFormatter.locale = NSLocale.currentLocale()
        postDateFormatter.dateFormat = "M/dd/yy"
        let postDate:String = postDateFormatter.stringFromDate(post.date)
        
        if post.date.isLessThanDate(oneDayAgo) {
            cell.dateLabel.text = currDate
            return cell
        }
        
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
        
        if post.date.isGreaterThanDate(oneHourAgo) {
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
        if onPosts {
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
                self.myPosts.removeAtIndex(indexPath.row)
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

    @IBAction func postsTapped(sender: UIButton) {
        if !onPosts {
            onPosts = true
            
            postsButton.backgroundColor = UIColor.orangeColor()
            postsButton.titleLabel?.textColor = UIColor.whiteColor()
            postsButton.layer.borderColor = UIColor.orangeColor().CGColor
            
            favoritesButton.backgroundColor = UIColor.whiteColor()
            favoritesButton.layer.borderColor = UIColor.orangeColor().CGColor
            favoritesButton.setTitleColor(UIColor.orangeColor(), forState: .Normal)
            
            tableView.reloadData()
        }
    }
    
    @IBAction func favoritesTapped(sender: UIButton) {
        if onPosts {
            onPosts = false
            
            favoritesButton.backgroundColor = UIColor.orangeColor()
            favoritesButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            favoritesButton.layer.borderColor = UIColor.orangeColor().CGColor
            
            postsButton.backgroundColor = UIColor.whiteColor()
            postsButton.titleLabel?.textColor = UIColor.orangeColor()
            postsButton.layer.borderColor = UIColor.orangeColor().CGColor
            
            tableView.reloadData()
        }
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
