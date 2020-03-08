//
//  LoginRequest.swift
//  PlatziTweets
//
//  Created by José Javier Cueto Mejía on 08/03/20.
//  Copyright © 2020 José Javier Cueto Mejía. All rights reserved.
//

import Foundation

struct LoginRequest: Codable {
    let email: String
    let password: String
}
