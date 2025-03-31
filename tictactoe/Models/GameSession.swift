//
//  GameSession.swift
//  tictactoe
//
//  Created by Attique Ur Rehman on 31/03/2025.
//

import Foundation

enum Player: String, Codable {
    case x = "x"
    case o = "o"
}

enum GameStatus: String, Codable {
    case ongoing = "ongoing"
    case x_won = "x wins"
    case o_won = "o wins"
    case draw = "draw"
}

struct GameState: Codable {
    let sessionId: Int
    let board: [[Int]]
    let currentPlayer: Player
    let status: GameStatus
    let winner: String?
}

struct GameSession: Codable {
    let id: Int
    var board: [[Int]]
    var currentPlayer: Player
    var status: GameStatus
    var winner: Player?
    let userId: Int?
}
