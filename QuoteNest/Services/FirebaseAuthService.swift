//
//  FirebaseAuthService.swift
//  QuoteNest
//
//  Created by Hunter Scheppat on 11/19/24.
//

import Foundation
import FirebaseAuth

// TODO: connect to firebase 
// Perform authentication with Firebase
class FirebaseAuthService {
    static let shared = FirebaseAuthService()
    
    private init() {}
    
    // Sign in
    func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                completion(.failure(error))
            } else if let user = result?.user {
                completion(.success(user))
            }
        }
    }
    
    // Sign up
    func signUp(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                completion(.failure(error))
            } else if let user = result?.user {
                completion(.success(user))
            }
        }
    }
    
    // Log out of the app
    func signOut() -> Bool {
        do {
            try Auth.auth().signOut()
            return true
        } catch {
            return false
        }
    }
}
