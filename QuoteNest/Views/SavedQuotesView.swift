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
                    .foregroundColor(Color("lightRed"))
                    .padding()
            }
            
            Text("Your Quote Nest")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.bottom, 10)
            
            List {
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
            .onAppear {
                viewModel.fetchSavedQuotes()
            }
        }
        .padding(.horizontal)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.black.ignoresSafeArea())
    }
}

#Preview {
    SavedQuotesView()
}
