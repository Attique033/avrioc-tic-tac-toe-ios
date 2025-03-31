//
//  StatisticsViewModal.swift
//  tictactoe
//
//  Created by Attique Ur Rehman on 31/03/2025.
//

import Foundation
import Combine

class StatisticsViewModel: ObservableObject {
    private let gameService: GameServiceProtocol
    private let authService: AuthServiceProtocol
    
    @Published var stats: GameStats?
    @Published var isLoading: Bool = false
    @Published var error: String?
    
    init(gameService: GameServiceProtocol = GameService(),
         authService: AuthServiceProtocol = AuthService()) {
        self.gameService = gameService
        self.authService = authService
    }
    
    // MARK: - Statistics
    func fetchStats() async {
        isLoading = true
        do {
            stats = try await gameService.getStats()
        } catch {
            print("error", error)
            self.error = error.localizedDescription
        }
        isLoading = false
    }
    
    // MARK: - Authentication
    func logout() async {
        do {
            try await authService.logout()
        } catch {
            self.error = error.localizedDescription
        }
    }
} 
