//
//  Post.swift
//  PlatziTweets
//
//  Created by José Javier Cueto Mejía on 08/03/20.
//  Copyright © 2020 José Javier Cueto Mejía. All rights reserved.
//

import Foundation

struct Post: Codable{
    let id: String
    let author: User
    let imageUrl: String
    let text: String
    let videoUrl: String
    let location: PostLocation
    let hasVideo: Bool
    let hasImage: Bool
    let hasLocation: Bool
    let createdAt: String
}
