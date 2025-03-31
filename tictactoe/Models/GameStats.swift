//
//  GameStats.swift
//  tictactoe
//
//  Created by Attique Ur Rehman on 31/03/2025.
//

import Foundation

struct GameStats: Codable {
    let wins: Int?
    let losses: Int?
    let draws: Int?
    let totalGames: Int?
    
    func getTotalGames() -> Int {
        return (wins ?? 0) + (losses ?? 0) + (draws ?? 0)
    }
}

struct GameStatusResponse: Codable {
    let status: GameStatus
}

struct StatsResponse: Codable {
    let stats: GameStats
}

struct EngineMoveResponse: Codable {
    let board: [[Int]]
    let status: GameStatus
    let winner: Player?
}
