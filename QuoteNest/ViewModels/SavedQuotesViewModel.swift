//
//  SavedQuotesViewModel.swift
//  QuoteNest
//
//  Created by Hunter Scheppat on 12/1/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class SavedQuotesViewModel: ObservableObject {
    @Published var savedQuotes: [Quote] = []
    @Published var errorMessage: String? = nil
    
    private let quoteService = FirebaseQuoteService.shared
    
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
    
    func deleteQuote(_ quote: Quote) {
        guard let user = Auth.auth().currentUser else { return }
        let userDocRef = Firestore.firestore().collection("users").document(user.uid)
        
        // Delete the quote from the array
        userDocRef.updateData([
            "quotes": FieldValue.arrayRemove([[
                "id": quote.id,
                "text": quote.text,
                "author": quote.author
            ]])
        ]) { error in
            if let error = error {
                self.errorMessage = "Failed to delete quote: \(error.localizedDescription)"
            } else {
                self.fetchSavedQuotes() // Refresh the list after deletion
            }
        }
    }
}

