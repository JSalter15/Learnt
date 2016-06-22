//
//  NewsfeedViewController.swift
//  Learnt
//
//  Created by Joe Salter on 6/20/16.
//  Copyright © 2016 Joe Salter. All rights reserved.
//

import UIKit

class NewsfeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate, UISearchResultsUpdating {

    @IBOutlet weak var tableView: UITableView!
    
    var allPosts:[Post] = []
    //var followedPosts:[Post] = []
    var filteredPosts:[Post] = []
    
    var user:User?
    var refreshControl: UIRefreshControl!
    
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
      
        let newPostButton = UIBarButtonItem(image: UIImage(named: "new_post"), style: .Plain, target: self, action: #selector(newPostTapped))
        newPostButton.tintColor = UIColor.orangeColor()
        let searchButton = UIBarButtonItem(image: UIImage(named: "search"), style: .Plain, target: self, action: #selector(searchTapped))
        searchButton.tintColor = UIColor.orangeColor()
        navigationItem.setRightBarButtonItems([newPostButton, searchButton], animated: true)
        //navigationItem.rightBarButtonItem = newPostButton

        let logo = UIBarButtonItem(image: UIImage(named: "logo"), style: .Plain, target: self, action: #selector(logoTapped))
        logo.tintColor = UIColor.orangeColor()
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        negativeSpacer.width = -12
        navigationItem.setLeftBarButtonItems([negativeSpacer, logo], animated: true)

        self.tableView.contentOffset = CGPointMake(0, self.searchController.searchBar.frame.size.height)
        
        allPosts = PostController.sharedInstance.getPosts()
        
        user = UserController.sharedInstance.getLoggedInUser()
        //followedPosts = PostController.sharedInstance.getPostsForUser(user!)
        
        self.tableView.registerNib(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomTableViewCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.placeholder = "Search for a username or a post!"
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Release to refresh")
        refreshControl.addTarget(self, action: #selector(self.refreshTable), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredPosts = allPosts.filter { post in
            if post.poster!.username!.lowercaseString.containsString(searchText.lowercaseString) || post.body!.lowercaseString.containsString(searchText.lowercaseString) {
                return true
            }
            else {
                return false
            }
        }
        
        tableView.reloadData()
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func logoTapped() {
        let pvc = HelpPopUpViewController()
        pvc.showInView(self.view, animated: true)
    }
    
    func searchTapped() {
        self.tableView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: false)
        searchController.searchBar.becomeFirstResponder()
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

    func newPostTapped() {
        let npvc = NewPostViewController()
        presentViewController(npvc, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active {
            return filteredPosts.count
        }
        
        return allPosts.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let post = allPosts[indexPath.row]
        var length = 0
        
        if post.body?.characters.count > 100 {
            length = 110
        }
        else if post.body?.characters.count > 60 {
            length = 100
        }
        else {
            length = 70
        }

        return CGFloat(length)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var post:Post

        //let post = followedPosts[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("CustomTableViewCell") as! CustomTableViewCell
        
        if searchController.active && searchController.searchBar.text != "" {
            post = filteredPosts[indexPath.row]
        }
        else {
            post = allPosts[indexPath.row]
        }
        
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
