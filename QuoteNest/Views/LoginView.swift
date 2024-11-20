//
//  LoginView.swift
//  QuoteNest
//
//  Hunter Scheppat | Final Project
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    // Hold state object and variables
    @StateObject private var viewModel = AuthViewModel()
    @State private var email = ""
    @State private var password = ""
    @State private var isLoginMode = true
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    // Main view to login
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {

                Spacer()
                
                // App title
                Text("QuoteNest")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color("lightRed"))
                    .shadow(color: Color("lightRed"), radius: 10)
                
                
                // Login | Create account picker
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
                
                // Try and login w/ Firebase
                Button(action: performAction) {
                    Text(isLoginMode ? "Login" : "Create Account")
                        .frame(maxWidth: .infinity)
                        .fontWeight(.bold)
                        .padding()
                        .background(Color("lightRed"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                Spacer()
                
                
                VStack(alignment: .leading) {
                    // App quote with additional horizontal padding
                    Text("\"Famous remarks are very seldom quoted correctly.\"")
                        .italic()
                        .padding(.horizontal, 16) // Increased horizontal padding
                    
                    // Author aligned to the right and italicized
                    HStack {
                        Spacer()
                        Text("-- Simeon Strunsky")
                            .italic()
                    }
                }
                .foregroundStyle(.gray)
                .padding(.bottom)
                .padding(.horizontal)


                
            }
            .padding()
            // Alert in case things don't work
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Message"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .background(Color.black.ignoresSafeArea())
        }
    }
    
    // Perform the login with the viewmodel 
    private func performAction() {
        if isLoginMode {
            viewModel.signIn(email: email, password: password) { success in
                if success {
                    // Navigate to home view
                } else {
                    alertMessage = "Failed to login. Please check your credentials."
                    showAlert = true
                }
            }
        } else {
            viewModel.signUp(email: email, password: password) { success in
                if success {
                    // Navigate to home view
                } else {
                    alertMessage = "Failed to create account. Please try again."
                    showAlert = true
                }
            }
        }
    }
}

#Preview {
    LoginView()
}
