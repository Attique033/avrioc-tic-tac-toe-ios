//
//  APIService.swift
//  tictactoe
//
//  Created by Attique Ur Rehman on 31/03/2025.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case networkError(Error)
    case decodingError(Error)
    case serverError(Int)
    case unauthorized
    case invalidBoardFormat

    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .serverError(let code):
            return "Server error with code: \(code)"
        case .unauthorized:
            return "Unauthorized access"
        case .invalidBoardFormat:
            return "Invalid board format"
        }
    }
}

class APIService {
    private let baseURL: String
    private let session: URLSession

    init(baseURL: String = Constants.API.baseURL, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }

    private func createRequest(_ endpoint: String, method: String = "GET", body: [String: Any]? = nil) throws -> URLRequest {
        guard let url = URL(string: baseURL + endpoint) else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let token = AuthService().getUserSession()?.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        if let body = body {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        }

        return request
    }

    private func parseBoardString(_ boardString: String) throws -> [[Int]] {
        guard let data = boardString.data(using: .utf8),
              let board = try? JSONDecoder().decode([[Int]].self, from: data) else {
            throw APIError.invalidBoardFormat
        }
        return board
    }

    func request<T: Decodable>(_ endpoint: String, method: String = "GET", body: [String: Any]? = nil) async throws -> T {
        let request = try createRequest(endpoint, method: method, body: body)

        do {
            let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }

            switch httpResponse.statusCode {
            case 200...299:
                do {
                    if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let boardString = json["board"] as? String {
                        let board = try parseBoardString(boardString)
                        var mutableJson = json
                        mutableJson["board"] = board
                        let updatedData = try JSONSerialization.data(withJSONObject: mutableJson)
                        return try JSONDecoder().decode(T.self, from: updatedData)
                    }
                    return try JSONDecoder().decode(T.self, from: data)
                } catch {
                    throw APIError.decodingError(error)
                }
            case 401:
                throw APIError.unauthorized
            default:
                throw APIError.serverError(httpResponse.statusCode)
            }
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.networkError(error)
        }
    }
}
