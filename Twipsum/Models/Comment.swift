//
//  Comment.swift
//  Twipsum
//
//  Created by Matthew Clevenger on 09/06/2020.
//  Copyright © 2020 Matt Clevenger. All rights reserved.
//

/**
Represents a single comment object retrieved from the API.
*/
struct Comment: Decodable {
    var id: Int
    var body: String
    var email: String
    var name: String
    var postId: Int
}
