//
//  UserController.swift
//  Learnt
//
//  Created by Joe Salter on 6/20/16.
//  Copyright © 2016 Joe Salter. All rights reserved.
//

import Foundation
import UIKit

class UserController {
    
    class var sharedInstance: UserController {
        struct Static {
            static var instance:UserController?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token)    {
            Static.instance = UserController()
        }
        return Static.instance!
    }
    
    var allUsers: [User] = []
    
    var noUser = User(email: "", password: "", username: "", profPic: nil, name: "", descriptor: "", posts: [], followerList: [], followingList: [], favoritedList: [], repostList: [])
    
    func registerUser(email:String, password:String, username:String?, profPic: UIImage?, name:String?, descriptor:String?) -> (User?, String?) {
        
        getUsers()
        
        
        
        if doesUserExist(email, password:password) != nil {
            return (nil, "There is already a user registered with that email")
        }
        
        let user = User(email: email, password: password, username: username, profPic: profPic, name: name, descriptor: descriptor, posts: [], followerList: [], followingList: [], favoritedList: [], repostList: [])
        
        allUsers.append(user)
        
        PersistenceManager.saveNSArray(allUsers, fileName: "usersArray")
        
        setLoggedInUser(user)
        
        return(user, nil)
    }
    
    func loginUser(email:String, password:String) -> (User?, String?) {
        
        getUsers()
        
        if let user = doesUserExist(email, password:password) {
            setLoggedInUser(user)
            return (user, nil)
        }
        
        return (nil, "Incorrect username or password!")
    }
    
    func getUsers() {
        
        let emptyUsers:[User] = []
        
        if let users = PersistenceManager.loadNSArray("usersArray") as? [User] {
            allUsers = users
            return
        }
        
        allUsers = emptyUsers
    }
    
    func doesUserExist(user:User) -> Bool {
        
        getUsers()
        
        if let _ = allUsers.indexOf({$0.email == user.email && $0.password == user.password})
        {
            return true
        }
        
        /*for everyUser in allUsers {
            if ((user.email == everyUser.email) && user.password == everyUser.password){
                return true
            }
        }*/
        
        return false
    }
    
    func doesUserExist(email:String, password:String?) -> User? {
        getUsers()
        
        if let index = allUsers.indexOf({$0.email == email && $0.password == password})
        {
            // remove the place
            return allUsers[index]
        }
        
        /*for user in allUsers {
            if ((user.email == email) && (user.password == password)) {
                return user
            }
        }*/
        
        return nil
    }
    
    func setLoggedInUser(user:User?) {
        if user == nil {
            PersistenceManager.saveObject(noUser, fileName: "loggedInUser")
        }
        else {
            PersistenceManager.saveObject(user!, fileName: "loggedInUser")
        }
    }
    
    func getLoggedInUser() -> User? {
        if let user = PersistenceManager.loadObject("loggedInUser") as? User {
            if ((user.email == noUser.email) && (user.password == noUser.password)) {
                return nil
            }
            return user
        }
        
        return nil
    }
    
    func newPostForUser(post:Post) {
        let currentUser = getLoggedInUser()
        
//        if let index = allUsers.indexOf({$0.email == currentUser?.email})
//        {
//            allUsers[index].posts.append(post)
//            
//            // update the array
//            PersistenceManager.saveNSArray(allUsers, fileName: "allUsers")
//        }
    }
}