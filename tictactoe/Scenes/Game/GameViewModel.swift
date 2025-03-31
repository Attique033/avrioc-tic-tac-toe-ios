//
//  GameViewModel.swift
//  tictactoe
//
//  Created by Attique Ur Rehman on 31/03/2025.
//

import Foundation
import Combine

class GameViewModel: ObservableObject {
    private let gameService: GameServiceProtocol
    private var currentSession: GameSession?
    private var isPCMoveInProgress = false
    
    @Published var board: [[Int]] = Array(repeating: Array(repeating: 0, count: 3), count: 3)
    @Published var currentPlayer: Player = .x
    @Published var gameStatus: GameStatus = .ongoing
    @Published var winner: String?
    @Published var isLoading: Bool = false
    @Published var error: String?
    @Published var showResultAlert: Bool = false
    @Published var resultMessage: String = ""
    @Published var sessionId: Int?
    
    init(gameService: GameServiceProtocol = GameService()) {
        self.gameService = gameService
    }
    
    // MARK: - Game Logic
    func startNewGame(startWithPlayer: Bool) async {
        isLoading = true
        do {
            let session = try await gameService.createGameSession(startWithPlayer: startWithPlayer)
            currentSession = session
            board = session.board
            currentPlayer = session.currentPlayer
            gameStatus = session.status
            sessionId = session.id
            
            if !startWithPlayer {
                await makePCMove()
            }
        } catch {
            self.error = error.localizedDescription
        }
        isLoading = false
    }
    
    func makeMove(at row: Int, column: Int) async {
        guard !isPCMoveInProgress,
              let sessionId = currentSession?.id,
              board[row][column] == 0 else { return }
        
        var newBoard = board
        newBoard[row][column] = -1
        
        do {
            let status = try await gameService.makeMove(board: newBoard, sessionId: String(sessionId))
            board = newBoard
            gameStatus = status
            
            if status == .ongoing {
                await makePCMove()
            } else {
                handleGameEnd(status: status)
            }
        } catch {
            self.error = error.localizedDescription
        }
    }
    
    private func makePCMove() async {
        guard let sessionId = currentSession?.id else { return }
        
        isPCMoveInProgress = true
        
        // Random delay between 200-1000ms
        try? await Task.sleep(nanoseconds: UInt64.random(in: 200_000_000...1_000_000_000))
        
        do {
            let response = try await gameService.pcMove(board: board, sessionId: String(sessionId))
            board = response.board
            gameStatus = response.status
            currentPlayer = currentPlayer == .x ? .o : .x
            
            if response.status != .ongoing {
                handleGameEnd(status: response.status)
            }
        } catch {
            self.error = error.localizedDescription
        }
        
        isPCMoveInProgress = false
    }
    
    private func handleGameEnd(status: GameStatus) {
        switch status {
        case .x_won:
            resultMessage =  "You won!"
        case .o_won:
            resultMessage = "AI won!"
        case .draw:
            resultMessage = "It's a draw!"
        case .ongoing:
            return
        }
        showResultAlert = true
    }
} 
