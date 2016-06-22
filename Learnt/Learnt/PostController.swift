//
//  PostController.swift
//  Learnt
//
//  Created by Joe Salter on 6/20/16.
//  Copyright © 2016 Joe Salter. All rights reserved.
//

import Foundation

class PostController {
    
    class var sharedInstance: PostController {
        struct Static {
            static var instance:PostController?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token)    {
            Static.instance = PostController()
        }
        return Static.instance!
    }
    
    var allPosts:[Post] = []
    
    func newPost(post:Post) {
        allPosts.insert(post, atIndex: 0)
        PersistenceManager.saveNSArray(allPosts, fileName: "allPosts")
    }
    
    func removePost(index:Int)
    {
        getPosts()
        
        allPosts.removeAtIndex(index)
        PersistenceManager.saveNSArray(allPosts, fileName: "allPosts")
    }
    
    private func readPlacesFromMemory() {
        if let postArray = PersistenceManager.loadNSArray("allPosts") {
            allPosts = postArray as! [Post]
        }
    }
    
    func getPosts() -> [Post] {
        if allPosts.count == 0 {
            readPlacesFromMemory()
        }

        return allPosts
    }
    
    func getPostsForUser(user:User) -> [Post] {
        var followedPosts:[Post] = []

        getPosts()
        
        for post in allPosts {
            if post.poster?.email == user.email {
                followedPosts.append(post)
            }
            else if user.follows(post.poster!) {
                followedPosts.append(post)
            }
        }
        return followedPosts
    }
}