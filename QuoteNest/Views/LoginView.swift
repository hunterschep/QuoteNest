import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var email = ""
    @State private var password = ""
    @State private var isLoginMode = true
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var navigateToHome = false // State variable to control navigation

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Spacer()

                Text("QuoteNest")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color("lightRed"))
                    .shadow(color: Color("lightRed"), radius: 10)

                Picker("Mode", selection: $isLoginMode) {
                    Text("Login").tag(true)
                    Text("Create Account").tag(false)
                }
                .pickerStyle(SegmentedPickerStyle())
                .background(Color.gray.opacity(0.7))
                .cornerRadius(8)
                .foregroundColor(.white)
                .padding(.horizontal)

                // Email & Password field
                VStack(spacing: 15) {
                    ZStack(alignment: .leading) {
                        if email.isEmpty {
                            Text("  Email")
                                .foregroundColor(Color.white.opacity(0.5)) // Light white color
                                .padding(.leading, 8)
                        }
                        TextField("Email", text: $email)
                            .padding()
                            .background(Color.gray.opacity(0.25))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                    }

                    ZStack(alignment: .leading) {
                        if password.isEmpty {
                            Text("  Password")
                                .foregroundColor(Color.white.opacity(0.5)) // Light white color
                                .padding(.leading, 8)
                        }
                        SecureField("", text: $password)
                            .padding()
                            .background(Color.gray.opacity(0.25))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding(.horizontal)

                Button(action: performAction) {
                    Text(isLoginMode ? "Login" : "Create Account")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("lightRed"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .shadow(color: Color("lightRed"), radius: 10)

                Spacer()

                VStack(alignment: .leading) {
                    Text("\"Famous remarks are very seldom quoted correctly.\"")
                        .italic()
                    HStack {
                        Spacer()
                        Text("-- Simeon Strunsky")
                            .italic()
                    }
                }
                .padding()
                .foregroundStyle(.gray)

                // NavigationLink for programmatic navigation
                NavigationLink(destination: HomeView(), isActive: $navigateToHome) {
                    EmptyView()
                }
            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Message"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .background(Color.black.ignoresSafeArea())
        }
    }

    private func performAction() {
        if isLoginMode {
            viewModel.signIn(email: email, password: password) { success in
                handleCompletion(success: success, message: "Failed to login. Please check your credentials.")
            }
        } else {
            viewModel.signUp(email: email, password: password) { success in
                handleCompletion(success: success, message: "Failed to create account. Please ensure your email is not currently in use")
            }
        }
    }

    private func handleCompletion(success: Bool, message: String) {
        if success {
            navigateToHome = true // Trigger navigation to HomeView
        } else {
            alertMessage = message
            showAlert = true
        }
    }
}

#Preview {
    LoginView()
}
