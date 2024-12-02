/*
    
    @file: QuoteNestApp.swift
    @project: QuoteNest | Fall 2024 Swift Final Project
    @author: Hunter Scheppat
    @date: December 2nd, 2024
 
    @description: main application file with some Firebase logic 
 
 */

import SwiftUI
import FirebaseCore

// AppDelegate code for Firebase
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

// Main application!
@main
struct QuoteNestApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }
}
