//
//  RegisterViewModal.swift
//  tictactoe
//
//  Created by Attique Ur Rehman on 31/03/2025.
//

import Foundation
import Combine

class RegisterViewModel: ObservableObject {
    private let authService: AuthServiceProtocol
    
    @Published var isLoading: Bool = false
    @Published var error: String?
    @Published var isAuthenticated: Bool = false
    
    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService
    }
    
    // MARK: - Validation
    func validateName(_ name: String) -> Bool {
        return name.count >= 2
    }
    
    func validateEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func validatePassword(_ password: String) -> Bool {
        return password.count >= 8
    }
    
    // MARK: - Registration
    @MainActor
    func register(name: String, email: String, password: String) async {
        guard validateName(name) else {
            error = "Name must be at least 2 characters"
            return
        }
        
        guard validateEmail(email) else {
            error = "Please enter a valid email address"
            return
        }
        
        guard validatePassword(password) else {
            error = "Password must be at least 8 characters"
            return
        }
        
        isLoading = true
        error = nil
        
        do {
            let session = try await authService.register(name: name, email: email, password: password)
            try authService.saveUserSession(session)
            isAuthenticated = true
        } catch {
            self.error = error.localizedDescription
        }
        
        isLoading = false
    }
} 
