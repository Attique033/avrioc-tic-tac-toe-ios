//
//  Constants.swift
//  tictactoe
//
//  Created by Attique Ur Rehman on 31/03/2025.
//


import Foundation

enum Constants {
    enum API {
        static let baseURL = "http://localhost:8080"

        enum Endpoints {
            static let login = "/auth/login"
            static let register = "/auth/register"
            static let createGame = "/game/create_game_session"
            static let playerMove = "/game/player_move"
            static let pcMove = "/game/pc_move"
            static let gameState = "/game"
            static let stats = "/stats"
        }
    }

    enum UserDefaults {
        static let userDataKey = "userData"
        static let gameStateKey = "currentGameState"
    }

    enum Game {
        static let boardSize = 3
        static let playerXValue = -1
        static let playerOValue = 1
        static let emptyCellValue = 0
    }

    enum UI {
        static let cornerRadius: CGFloat = 8
        static let padding: CGFloat = 16
        static let buttonHeight: CGFloat = 44
        static let textFieldHeight: CGFloat = 44
    }
}
