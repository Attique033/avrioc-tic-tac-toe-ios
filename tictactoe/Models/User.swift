//
//  User.swift
//  tictactoe
//
//  Created by Attique Ur Rehman on 31/03/2025.
//

import Foundation

struct User: Codable {
    let id: Int
    let name: String
    let email: String
}

struct UserSession: Codable {
    let token: String
    let user: User
    
    var userId: Int {
        user.id
    }
}
