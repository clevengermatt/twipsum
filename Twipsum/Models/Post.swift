//
//  Post.swift
//  Twipsum
//
//  Created by Matthew Clevenger on 09/06/2020.
//  Copyright © 2020 Matt Clevenger. All rights reserved.
//

/**
Represents a single post object retrieved from the API.
*/
struct Post: Decodable {
    var id: Int
    var body: String
    var title: String
    var userId: Int
}
