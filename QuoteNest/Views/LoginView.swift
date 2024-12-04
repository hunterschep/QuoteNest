/*
 
     @file: LoginView.swift
     @project: QuoteNest | Fall 2024 Swift Final Project
     @author: Hunter Scheppat
     @date: December 2nd, 2024
     
     @description: view that allows login / account creation and utilizes auth service
 
 */


import SwiftUI
import FirebaseAuth


struct LoginView: View {
    // VM to handle login & account creation
    @StateObject private var viewModel = AuthViewModel()
    // Fields
    @State private var email = ""
    @State private var password = ""
    @State private var isLoginMode = true
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var navigationPath = NavigationPath()


    var body: some View {
        NavigationStack(path: $navigationPath) {
            // Text & logins
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


                // Email & password fields
                VStack(spacing: 15) {
                    ZStack(alignment: .leading) {
                        if email.isEmpty {
                            Text("  Email")
                                .foregroundColor(Color.white.opacity(0.5))
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
                                .foregroundColor(Color.white.opacity(0.5))
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


                // Button to login or create
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
                .fontWeight(.bold)



                Spacer()


                VStack(alignment: .center) {
                    Text("Made by Hunter Scheppat")
                }
                .padding()
                .foregroundStyle(.gray)
            }
            .padding()
            // Alert if something fails
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Message"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .background(Color.black.ignoresSafeArea())
            .navigationDestination(for: String.self) { _ in
                HomeView()
            }
        }
    }


    // Attempt to login or signup
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


    // Handle the result of attempting to login or signup
    private func handleCompletion(success: Bool, message: String) {
        if success {
            navigationPath.append("home")
        } else {
            alertMessage = message
            showAlert = true
        }
    }
}


#Preview {
    LoginView()
}
