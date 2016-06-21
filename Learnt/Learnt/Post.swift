//
//  Post.swift
//  Learnt
//
//  Created by Joe Salter on 6/20/16.
//  Copyright © 2016 Joe Salter. All rights reserved.
//

import Foundation

class Post: NSObject, NSCoding {
    
    var poster:User?
    var body:String?
    var date:NSDate?
    var favoriters:[User] = []
    var reposters:[User] = []
    
    required init(poster:User?, body:String?, date:NSDate?, favoriters:[User], reposters:[User]) {
        self.poster = poster
        self.body = body
        self.date = date
        self.favoriters = favoriters
        self.reposters = reposters
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.poster, forKey: "poster")
        aCoder.encodeObject(self.body, forKey: "body")
        aCoder.encodeObject(self.date, forKey: "data")
        aCoder.encodeObject(self.favoriters, forKey: "favoriters")
        aCoder.encodeObject(self.reposters, forKey: "reposters")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let poster = aDecoder.decodeObjectForKey("poster") as? User
        let body = aDecoder.decodeObjectForKey("body") as? String
        let date = aDecoder.decodeObjectForKey("date") as? NSDate
        let favoriters = aDecoder.decodeObjectForKey("favoriters") as! [User]
        let reposters = aDecoder.decodeObjectForKey("reposters") as! [User]
        
        self.init(poster:poster, body:body, date:date, favoriters:favoriters, reposters:reposters)
    }
    
    func favorite(user:User) {
        self.favoriters.append(user)
        user.favoritedList.append(self)
    }
    
    func repost(user:User) {
        self.reposters.append(user)
        user.repostList.append(self)
    }
}