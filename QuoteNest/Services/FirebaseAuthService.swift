/*
    
    @file: FirebaseAuthService.swift
    @project: QuoteNest | Fall 2024 Swift Final Project
    @author: Hunter Scheppat
    @date: December 2nd, 2024
 
    @description: service file to handle user signin, signup, and signout with Firebase
 
 */

import Foundation
import FirebaseAuth

class FirebaseAuthService {
    static let shared = FirebaseAuthService()

    private init() {}

    // Attempt to sign in using Firebase Auth
    func signIn(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if let error = error {
                // Send a completion state back to the viewmodel
                completion(.failure(error))
                print("ERROR Signing In: \(error.localizedDescription)")
            } else {
                completion(.success(()))
            }
        }
    }

    // Attempt to sign up using Firebase Auth
    func signUp(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            if let error = error {
                // Send a completion state back to the ViewModel
                completion(.failure(error))
                print("ERROR Signing Up: \(error.localizedDescription)")
            } else {
                completion(.success(()))
            }
        }
    }

    // Attempt to sign out using Firebase Auth -> Just returns a boolean 
    func signOut() -> Bool {
        do {
            try Auth.auth().signOut()
            return true
        } catch {
            print("ERROR Signing Out: \(error.localizedDescription)")
            return false
        }
    }
}
