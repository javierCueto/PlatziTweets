//
//  LoginResponse.swift
//  PlatziTweets
//
//  Created by José Javier Cueto Mejía on 08/03/20.
//  Copyright © 2020 José Javier Cueto Mejía. All rights reserved.
//

import Foundation

struct LoginResponse: Codable {
    let user: User
    let token: String
}
