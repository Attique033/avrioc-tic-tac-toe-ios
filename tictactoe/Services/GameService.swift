//
//  GameService.swift
//  tictactoe
//
//  Created by Attique Ur Rehman on 31/03/2025.
//


import Foundation

protocol GameServiceProtocol {
    func createGameSession(startWithPlayer: Bool) async throws -> GameSession
    func makeMove(board: [[Int]], sessionId: String) async throws -> GameStatus
    func pcMove(board: [[Int]], sessionId: String) async throws -> EngineMoveResponse
    func getGameState(sessionId: String) async throws -> GameSession
    func getStats() async throws -> GameStats
}

class GameService: GameServiceProtocol {
    private let apiService: APIService
    
    init(apiService: APIService = APIService()) {
        self.apiService = apiService
    }
    
    func createGameSession(startWithPlayer: Bool) async throws -> GameSession {
        let body: [String: Any] = ["startWithPlayer": startWithPlayer]
        return try await apiService.request(Constants.API.Endpoints.createGame, method: "POST", body: body)
    }
    
    func makeMove(board: [[Int]], sessionId: String) async throws -> GameStatus {
        let body: [String: Any] = [
            "board": board,
            "sessionId": sessionId
        ]
        
        let response: GameStatusResponse = try await apiService.request(Constants.API.Endpoints.playerMove, method: "POST", body: body)
        return response.status
    }
    
    func pcMove(board: [[Int]], sessionId: String) async throws -> EngineMoveResponse {
        let body: [String: Any] = [
            "board": board,
            "sessionId": sessionId
        ]
        
        return try await apiService.request(Constants.API.Endpoints.pcMove, method: "POST", body: body)
    }
    
    func getGameState(sessionId: String) async throws -> GameSession {
        let endpoint = "\(Constants.API.Endpoints.gameState)?sessionId=\(sessionId)"
        return try await apiService.request(endpoint)
    }
    
    func getStats() async throws -> GameStats {
        let response: StatsResponse = try await apiService.request(Constants.API.Endpoints.stats)
        return response.stats
    }
    
}
