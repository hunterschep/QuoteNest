/*
 
     @file: SavedQuotesView.swift
     @project: QuoteNest | Fall 2024 Swift Final Project
     @author: Hunter Scheppat
     @date: December 2nd, 2024
     
     @description: view model for looking at all of a user's saved quotes
 
 */

import SwiftUI

struct SavedQuotesView: View {
    @StateObject private var viewModel = SavedQuotesViewModel()
    @State private var showLoadingScreen = true // Controls the initial loading view

    var body: some View {
        ZStack {
            if showLoadingScreen {
                // Loading Screen while we fetch quotes
                Color.black
                    .ignoresSafeArea()
                    .overlay(
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Color("lightRed")))
                            .scaleEffect(2) // Make the spinner larger
                    )
            } else {
                // Main Content
                VStack {
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(Color("lightRed"))
                            .padding()
                    }

                    Text("Your Quote Nest")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.bottom, 10)

                    List {
                        // Show each saved user quote 
                        ForEach(viewModel.savedQuotes) { quote in
                            NavigationLink(destination: QuoteDetailView(quote: quote)) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("\(quote.author):")
                                            .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(Color.lightRed)
                                        Text("\"\(quote.text.prefix(20))...\"")
                                            .font(.body)
                                            .italic()
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.white)
                                }
                                .padding(15)
                                .cornerRadius(8)
                            }
                            .swipeActions {
                                Button(role: .destructive) {
                                    viewModel.deleteQuote(quote)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                                .tint(Color("lightRed"))
                            }
                        }
                        .listRowBackground(Color.black) // Ensure consistent black background for rows
                        .background(Color.gray.opacity(0.2))
                    }
                    .listStyle(.inset)
                    .scrollContentBackground(.hidden)
                }
                .padding(.horizontal)
                .navigationBarTitleDisplayMode(.inline)
                .background(Color.black.ignoresSafeArea())
            }
        }
        .onAppear {
            if ProcessInfo.processInfo.environment["XCODE_RUNNING_PREVIEWS"] == "1" {
                // Running in Xcode canvas previews, use mock data
                viewModel.savedQuotes = Quote.mockSavedQuotes
                print("Using mock saved quotes for preview.")
            } else {
                // Not in previews, fetch real saved quotes
                viewModel.fetchSavedQuotes()
            }
            
            // Dismiss loading screen after 1.5 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                showLoadingScreen = false
            }
        }
    }
}

#Preview {
    SavedQuotesView()
}
