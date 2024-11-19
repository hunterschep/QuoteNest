//
//  AuthViewModel.swift
//  QuoteNest
//
//  Created by Hunter Scheppat on 11/19/24.
//

import Foundation
import FirebaseAuth

// ViewModel to handle logging in
class AuthViewModel: ObservableObject {
    @Published var user: User?
    @Published var isAuthenticated = false
    
    private let authService = FirebaseAuthService.shared
    
    // Sign in
    func signIn(email: String, password: String, completion: @escaping (Bool) -> Void) {
        authService.signIn(email: email, password: password) { [weak self] result in
            switch result {
            case .success(let user):
                self?.user = user
                self?.isAuthenticated = true
                completion(true)
            case .failure(_):
                completion(false)
            }
        }
    }
    
    // Sign up
    func signUp(email: String, password: String, completion: @escaping (Bool) -> Void) {
        authService.signUp(email: email, password: password) { [weak self] result in
            switch result {
            case .success(let user):
                self?.user = user
                self?.isAuthenticated = true
                completion(true)
            case .failure(_):
                completion(false)
            }
        }
    }
    
    // Log out 
    func signOut() {
        if authService.signOut() {
            user = nil
            isAuthenticated = false
        }
    }
}
