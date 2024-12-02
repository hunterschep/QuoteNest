/*
 
     @file: AuthViewModel.swift
     @project: QuoteNest | Fall 2024 Swift Final Project
     @author: Hunter Scheppat
     @date: December 2nd, 2024
     
     @description: view model that handles quote gathering and rendering for the main home page
        * Fetches a random quote
        * Saving a quote -> FirebaseQuoteService
        * Fetching saved quotes -> FirebaseQuoteService
 
 */

import Foundation

// Special struct for an error
struct ErrorMessage: Identifiable {
    let id = UUID()
    let message: String
}

class HomeViewModel: ObservableObject {
    @Published var randomQuote: Quote? = nil
    @Published var savedQuotes: [Quote] = []
    @Published var errorMessage: ErrorMessage? = nil // Update type to ErrorMessage

    private let quoteService = FirebaseQuoteService.shared

    // Fetch a random quote from the QuoteSlate API matching the user's specifications
    func fetchRandomQuote(maxLength: Int?, tags: String?, author: String?) {
        // baseURL
        var urlComponents = URLComponents(string: "https://quoteslate.vercel.app/api/quotes/random")!
        var queryItems: [URLQueryItem] = []
        
        // User determined attributes
        if let maxLength = maxLength {
            queryItems.append(URLQueryItem(name: "maxLength", value: "\(maxLength)"))
        }
        if let tags = tags, !tags.isEmpty {
            queryItems.append(URLQueryItem(name: "tags", value: tags))
        }
        if let author = author, !author.isEmpty {
            queryItems.append(URLQueryItem(name: "authors", value: author))
        }
        
        urlComponents.queryItems = queryItems

        // Try to make the URL
        guard let url = urlComponents.url else {
            print("Invalid URL")
            return
        }

        // Log the URL being requested
        print("Requesting URL: \(url)")

        // Attempt to get the data with URLSession
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                // Handle an error
                if let error = error {
                    print("Error encountered: \(error.localizedDescription)")
                    self?.errorMessage = ErrorMessage(message: error.localizedDescription)
                    return
                }
                
                // Parse the data
                guard let data = data else {
                    print("No data received from the server")
                    self?.errorMessage = ErrorMessage(message: "No data received")
                    return
                }

                // Log the raw JSON response
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Received JSON: \(jsonString)")
                }

                // Decode the JSONdata
                do {
                    let quoteResponse = try JSONDecoder().decode(Quote.self, from: data)
                    self?.randomQuote = quoteResponse
                    print("Decoded Quote: \(quoteResponse)")
                } catch {
                    print("Decoding error: \(error.localizedDescription)")
                    self?.errorMessage = ErrorMessage(message: "Failed to decode quote: \(error.localizedDescription)")
                }
            }
        }.resume()
    }

    // Save a quote using the Quote Service to a user's account
    func saveQuote(_ quote: Quote) {
        quoteService.saveQuote(quote) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Save quote error: \(error.localizedDescription)")
                    self?.errorMessage = ErrorMessage(message: error.localizedDescription)
                } else {
                    self?.fetchSavedQuotes()
                }
            }
        }
    }

    // Fetch all the quotes currently saved to a user's account 
    func fetchSavedQuotes() {
        quoteService.fetchSavedQuotes { [weak self] quotes, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Fetch saved quotes error: \(error.localizedDescription)")
                    self?.errorMessage = ErrorMessage(message: error.localizedDescription)
                } else if let quotes = quotes {
                    self?.savedQuotes = quotes
                    print("Fetched saved quotes: \(quotes)")
                }
            }
        }
    }
}
