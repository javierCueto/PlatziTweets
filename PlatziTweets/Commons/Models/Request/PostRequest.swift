//
//  PostRequest.swift
//  PlatziTweets
//
//  Created by José Javier Cueto Mejía on 08/03/20.
//  Copyright © 2020 José Javier Cueto Mejía. All rights reserved.
//

import Foundation

struct PostRequest: Codable {
    let text: String
    let imageUrl: String?
    let videoUrl: String?
    let location: PostRequestLocation?
}
