//
//  AppDelegate.swift
//  Learnt
//
//  Created by Joe Salter on 6/20/16.
//  Copyright © 2016 Joe Salter. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var tabController: UITabBarController?
    
    var newsfeedNavController: UINavigationController?
    var searchNavController: UINavigationController?
    var profileNavController: UINavigationController?

    var newsfeedViewController: NewsfeedViewController?
    var searchViewController: SearchViewController?
    var profileViewController: ProfileViewController?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        tabController = UITabBarController()

        newsfeedViewController = NewsfeedViewController()
        newsfeedNavController = UINavigationController(rootViewController: newsfeedViewController!)
        newsfeedNavController?.navigationBarHidden = false
        
        searchViewController = SearchViewController()
        searchNavController = UINavigationController(rootViewController: searchViewController!)

        profileViewController = ProfileViewController()
        profileNavController = UINavigationController(rootViewController: profileViewController!)

        tabController?.viewControllers = [newsfeedNavController!, searchNavController!, profileNavController!]
        
        newsfeedViewController?.tabBarItem = UITabBarItem(title: "Newsfeed", image: UIImage(named: "home"), tag: 0)
        searchViewController?.tabBarItem = UITabBarItem(title: "Search", image: UIImage(named: "search"), tag: 1)
        profileViewController?.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "profile"), tag: 2)

        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.rootViewController = self.tabController
        self.window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

