//
//  User.swift
//  Learnt
//
//  Created by Joe Salter on 6/20/16.
//  Copyright © 2016 Joe Salter. All rights reserved.
//

import Foundation
import UIKit

class User: NSObject, NSCoding {
    
    var email: String?
    var password: String?
    var username: String?
    var profPic: UIImage?
    var name: String?
    var descriptor: String?
    var posts: [Post] = []
    var followerList: [User] = []
    var followingList: [User] = []
    var favoritedList: [Post] = []
    var repostList: [Post] = []
    
    required init(email:String?, password:String?, username:String?, profPic: UIImage?, name: String?, descriptor: String?,posts:[Post], followerList:[User], followingList:[User], favoritedList:[Post], repostList:[Post]) {
        self.email = email
        self.password = password
        self.username = username
        self.profPic = profPic
        self.name = name
        self.descriptor = descriptor
        self.posts = posts
        self.followerList = followerList
        self.followingList = followingList
        self.favoritedList = favoritedList
        self.repostList = repostList
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.email, forKey: "email")
        aCoder.encodeObject(self.password, forKey: "password")
        aCoder.encodeObject(self.username, forKey: "username")
        aCoder.encodeObject(self.profPic, forKey: "profPic")
        aCoder.encodeObject(self.name, forKey: "name")
        aCoder.encodeObject(self.descriptor, forKey: "descriptor")
        aCoder.encodeObject(self.posts, forKey: "posts")
        aCoder.encodeObject(self.followerList, forKey: "followerList")
        aCoder.encodeObject(self.followingList, forKey: "followingList")
        aCoder.encodeObject(self.favoritedList, forKey: "favoritedList")
        aCoder.encodeObject(self.repostList, forKey: "repostList")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        let email = aDecoder.decodeObjectForKey("email") as? String
        let password = aDecoder.decodeObjectForKey("password") as? String
        let username = aDecoder.decodeObjectForKey("username") as? String
        let profPic = aDecoder.decodeObjectForKey("profPic") as? UIImage
        let name = aDecoder.decodeObjectForKey("name") as? String
        let descriptor = aDecoder.decodeObjectForKey("descriptor") as? String
        let posts = aDecoder.decodeObjectForKey("posts") as? [Post]
        let followerList = aDecoder.decodeObjectForKey("followerList") as! [User]
        let followingList = aDecoder.decodeObjectForKey("followingList") as! [User]
        let favoritedList = aDecoder.decodeObjectForKey("favoritedList") as! [Post]
        let repostList = aDecoder.decodeObjectForKey("repostList") as! [Post]
        
        self.init(email:email, password:password, username:username, profPic:profPic, name: name, descriptor:descriptor, posts:posts!, followerList:followerList, followingList:followingList, favoritedList:favoritedList, repostList:repostList)
    }
    
    func changeProfPic(newProfPic:UIImage) {
        self.profPic = newProfPic
    }
    
    func getPosts() -> [Post] {
        return posts
    }
    
    func follow(user:User) {
        self.followingList.append(user)
        user.followerList.append(self)
    }
    
    func unfollow(user:User) {        
        if let indexToRemove = self.followingList.indexOf(user) {
            followingList.removeAtIndex(indexToRemove)
        }
        
        if let indexToRemove = user.followerList.indexOf(self) {
            user.followerList.removeAtIndex(indexToRemove)
        }
    }
    
    func follows(user:User) -> Bool {
        return followingList.contains(user)
    }
}