/*
 
     @file: SavedQuotesViewModel.swift
     @project: QuoteNest | Fall 2024 Swift Final Project
     @author: Hunter Scheppat
     @date: December 2nd, 2024
     
     @description: view model that handles fetching a user's currently saved quotes
         * Fetches a user's saved quotes
         * TODO: deleting a quote (integrate into QuoteService)
         * TODO: handle notes
 
 */

import Foundation
import FirebaseFirestore
import FirebaseAuth

class SavedQuotesViewModel: ObservableObject {
    @Published var savedQuotes: [Quote] = []
    @Published var errorMessage: String? = nil
    
    private let quoteService = FirebaseQuoteService.shared
    
    // Fetch the saved quotes from the quoteService
    func fetchSavedQuotes() {
        quoteService.fetchSavedQuotes { [weak self] quotes, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = "Failed to fetch saved quotes: \(error.localizedDescription)"
                } else if let quotes = quotes {
                    self?.savedQuotes = quotes
                }
            }
        }
    }
    
    // Delete a quote using the quoteservice
    func deleteQuote(_ quote: Quote) {
        quoteService.deleteQuote(quote) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = "Failed to delete quote: \(error.localizedDescription)"
                } else {
                    self?.fetchSavedQuotes() // Refresh the list after deletion
                }
            }
        }
    }
}

