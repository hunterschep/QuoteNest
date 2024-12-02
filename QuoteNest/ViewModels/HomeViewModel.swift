//
//  HomeViewModel.swift
//  QuoteNest
//
//  Created by Hunter Scheppat on 11/19/24.
//

import Foundation

struct ErrorMessage: Identifiable {
    let id = UUID()
    let message: String
}

class HomeViewModel: ObservableObject {
    @Published var randomQuote: Quote? = nil
    @Published var savedQuotes: [Quote] = []
    @Published var errorMessage: ErrorMessage? = nil // Update type to ErrorMessage

    private let quoteService = FirebaseQuoteService.shared

    func fetchRandomQuote(maxLength: Int?, tags: String?, author: String?) {
        var urlComponents = URLComponents(string: "https://quoteslate.vercel.app/api/quotes/random")!
        var queryItems: [URLQueryItem] = []
        
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

        guard let url = urlComponents.url else {
            print("Invalid URL")
            return
        }

        // Log the URL being requested
        print("Requesting URL: \(url)")

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error encountered: \(error.localizedDescription)")
                    self?.errorMessage = ErrorMessage(message: error.localizedDescription)
                    return
                }

                guard let data = data else {
                    print("No data received from the server")
                    self?.errorMessage = ErrorMessage(message: "No data received")
                    return
                }

                // Log the raw JSON response
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Received JSON: \(jsonString)")
                }

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
