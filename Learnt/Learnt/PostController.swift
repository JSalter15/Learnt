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
        allPosts.append(post)
        PersistenceManager.saveNSArray(allPosts, fileName: "allPosts")
    }
    
    func removePost(post:Post)
    {
        getPosts()
        
        // the index is found if the title and the date are the same. That's enough to know
        if let index = allPosts.indexOf({$0.poster == post.poster && $0.date == post.date})
        {
            // remove the place
            allPosts.removeAtIndex(index)
            
            // update the array
            PersistenceManager.saveNSArray(allPosts, fileName: "allPosts")
        }
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