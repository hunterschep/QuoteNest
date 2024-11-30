import Foundation
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false

    private let authService = FirebaseAuthService.shared

    func signIn(email: String, password: String, completion: @escaping (Bool) -> Void) {
        authService.signIn(email: email, password: password) { result in
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

    func signUp(email: String, password: String, completion: @escaping (Bool) -> Void) {
        authService.signUp(email: email, password: password) { result in
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

    func signOut() {
        if authService.signOut() {
            isAuthenticated = false
        }
    }
}
