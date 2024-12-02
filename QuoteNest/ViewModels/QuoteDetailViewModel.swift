/*
 
     @file: QuoteDetailViewModel.swift
     @project: QuoteNest | Fall 2024 Swift Final Project
     @author: Hunter
 
     @description: View model that handles showing a specific quote and its notes
 
 */

import Foundation

class QuoteDetailViewModel: ObservableObject {
    @Published var notes: String = ""
    @Published var errorMessage: ErrorMessage? = nil
    @Published var isSaving: Bool = false

    private let quoteService = FirebaseQuoteService.shared
    let quote: Quote

    init(quote: Quote) {
        self.quote = quote
        fetchNotes()
    }

    // Fetch notes from Firebase
    func fetchNotes() {
        quoteService.fetchSavedQuotes { [weak self] quotes, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = ErrorMessage(message: "Error fetching notes \(error.localizedDescription)")
                    return
                }

                if let savedQuote = quotes?.first(where: { $0.id == self?.quote.id }) {
                    self?.notes = savedQuote.notes ?? ""
                }
            }
        }
    }

    // Save notes to Firebase
    func saveNotes() {
        isSaving = true
        let updatedQuote = Quote(
            id: quote.id,
            text: quote.text,
            author: quote.author,
            tags: quote.tags,
            notes: notes
        )
        quoteService.saveQuote(updatedQuote) { [weak self] error in
            DispatchQueue.main.async {
                self?.isSaving = false
                if let error = error {
                    self?.errorMessage = ErrorMessage(message:"Error saving notes: \(error.localizedDescription)")
                }
            }
        }
    }
}
