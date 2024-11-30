import Foundation
import FirebaseAuth

class FirebaseAuthService {
    static let shared = FirebaseAuthService()

    private init() {}

    func signIn(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if let error = error {
                completion(.failure(error))
                print("ERROR Signing In: \(error.localizedDescription)")
            } else {
                completion(.success(()))
            }
        }
    }

    func signUp(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            if let error = error {
                completion(.failure(error))
                print("ERROR Signing Up: \(error.localizedDescription)")
            } else {
                completion(.success(()))
            }
        }
    }

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
