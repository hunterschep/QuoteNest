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
    @State private var selectedQuote: Quote? = nil

    var body: some View {
        VStack {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            List {
                ForEach(viewModel.savedQuotes) { quote in
                    NavigationLink(destination: QuoteDetailView(quote: quote)) {
                        VStack(alignment: .leading) {
                            Text("\"\(quote.text)\"")
                                .font(.body)
                                .italic()
                            Text("- \(quote.author)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            viewModel.deleteQuote(quote)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .onAppear {
                viewModel.fetchSavedQuotes()
            }
        }
        .navigationTitle("My Quote Library")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.black.ignoresSafeArea()) 
    }
}


#Preview {
    SavedQuotesView()
}
