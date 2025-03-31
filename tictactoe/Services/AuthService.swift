//
//  AuthService.swift
//  tictactoe
//
//  Created by Attique Ur Rehman on 31/03/2025.
//

import Foundation

protocol AuthServiceProtocol {
    func login(email: String, password: String) async throws -> UserSession
    func register(name: String, email: String, password: String) async throws -> UserSession
    func saveUserSession(_ session: UserSession) throws
    func getUserSession() -> UserSession?
    func clearUserSession()
    func logout() async throws
}

class AuthService: AuthServiceProtocol {
    private let apiService: APIService
    private let keychainService = KeychainService()

    init(apiService: APIService = APIService()) {
        self.apiService = apiService
    }

    func login(email: String, password: String) async throws -> UserSession {
        let body = [
            "email": email,
            "password": password
        ]

        let session: UserSession = try await apiService.request(Constants.API.Endpoints.login, method: "POST", body: body)
        try saveUserSession(session)
        return session
    }

    func register(name: String, email: String, password: String) async throws -> UserSession {
        let body = [
            "name": name,
            "email": email,
            "password": password
        ]

        let session: UserSession = try await apiService.request(Constants.API.Endpoints.register, method: "POST", body: body)
        try saveUserSession(session)
        return session
    }

    func saveUserSession(_ session: UserSession) throws {
        try keychainService.saveToken(session.token)

        let userData = UserDefaultsData(id: session.user.id, name: session.user.name, email: session.user.email)
        if let encoded = try? JSONEncoder().encode(userData) {
            UserDefaults.standard.set(encoded, forKey: Constants.UserDefaults.userDataKey)
        }
    }

    func getUserSession() -> UserSession? {

        guard let token = try? keychainService.getToken(),
              let userData = UserDefaults.standard.data(forKey: Constants.UserDefaults.userDataKey),
              let userDefaultsData = try? JSONDecoder().decode(UserDefaultsData.self, from: userData) else {
            return nil
        }

        let user = User(id: userDefaultsData.id, name: userDefaultsData.name, email: userDefaultsData.email)
        return UserSession(token: token, user: user)
    }

    func clearUserSession() {
        try? keychainService.deleteToken()

        UserDefaults.standard.removeObject(forKey: Constants.UserDefaults.userDataKey)
    }

    func logout() async throws {
        clearUserSession()
    }
}

private struct UserDefaultsData: Codable {
    let id: Int
    let name: String
    let email: String
}

private class KeychainService {
    private let service = "com.tictactoe.app"
    private let account = "authToken"

    func saveToken(_ token: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: token.data(using: .utf8)!
        ]

        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainError.saveFailed(status)
        }
    }

    func getToken() throws -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess,
              let data = result as? Data,
              let token = String(data: data, encoding: .utf8) else {
            return nil
        }

        return token
    }

    func deleteToken() throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]

        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.deleteFailed(status)
        }
    }
}

enum KeychainError: Error {
    case saveFailed(OSStatus)
    case deleteFailed(OSStatus)
}
