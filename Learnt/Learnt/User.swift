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
    var followerList: [User] = []
    var followingList: [User] = []
    var favoritedList: [Post] = []
    var repostList: [Post] = []
    
    required init(email:String?, password:String?, username:String?, profPic: UIImage?, followerList:[User], followingList:[User], favoritedList:[Post], repostList:[Post]) {
        self.email = email
        self.password = password
        self.username = username
        self.profPic = profPic
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
        let followerList = aDecoder.decodeObjectForKey("followerList") as! [User]
        let followingList = aDecoder.decodeObjectForKey("followingList") as! [User]
        let favoritedList = aDecoder.decodeObjectForKey("favoriteLdist") as! [Post]
        let repostList = aDecoder.decodeObjectForKey("repostList") as! [Post]
        
        self.init(email:email, password:password, username:username, profPic:profPic, followerList:followerList, followingList:followingList, favoritedList:favoritedList, repostList:repostList)
    }
    
    func changeProfPic(newProfPic:UIImage) {
        self.profPic = newProfPic
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
    
}