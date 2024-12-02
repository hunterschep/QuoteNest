/*
 
     @file: AuthViewModel.swift
     @project: QuoteNest | Fall 2024 Swift Final Project
     @author: Hunter Scheppat
     @date: December 2nd, 2024
     
     @description: view model that interactions with -> AuthService and -> LoginView
        * Handles logins/logouts/signups
 
 */

import Foundation
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    private let authService = FirebaseAuthService.shared

    // Attempt to sign in by using the Auth service
    func signIn(email: String, password: String, completion: @escaping (Bool) -> Void) {
        authService.signIn(email: email, password: password) { result in
            // Handle successes and failures
            DispatchQueue.main.async {
                switch result {
                case .success:
                    completion(true)
                    print("😊 Successful sign in")
                case .failure:
                    completion(false)
                    print("😢 Failed sign in")
                }
            }
        }
    }

    // Attempt to sign up using the Auth service
    func signUp(email: String, password: String, completion: @escaping (Bool) -> Void) {
        authService.signUp(email: email, password: password) { result in
            // Handle successes and failures
            DispatchQueue.main.async {
                switch result {
                case .success:
                    completion(true)
                    print("😊 Successful sign up")
                case .failure:
                    completion(false)
                    print("😢 Failed sign up")
                }
            }
        }
    }

    // Sign out 
    func signOut() {
        if authService.signOut() {
            isAuthenticated = false
        }
    }
}
