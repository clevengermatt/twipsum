//
//  Cache.swift
//  Twipsum
//
//  Created by Matthew Clevenger on 09/06/2020.
//  Copyright © 2020 Matt Clevenger. All rights reserved.
//

/**
The cache of fetched data for frequent use.
*/
struct Cache {
    
    public static var shared = Cache()
    
    var comments: [Comment] = []
    var posts: [Post] = []
}
