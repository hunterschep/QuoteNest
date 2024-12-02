/*
 
     @file: FirebaseQuoteService.swift
     @project: QuoteNest | Fall 2024 Swift Final Project
     @author: Hunter Scheppat
     @date: December 2nd, 2024
     
     @description: service file to handle interactions with quotes and users like
         * Saving a quote to a user's account
         * Retrieving a user's saved quotes
         * TODO: Deleting a quote
         * TODO: Add users own notes about their quotes
 
 */

import Foundation
import FirebaseFirestore
import FirebaseAuth

class FirebaseQuoteService {
    static let shared = FirebaseQuoteService()
    private let db = Firestore.firestore()
    
    private init() {}

    // Save or update a quote
    func saveQuote(_ quote: Quote, completion: @escaping (Error?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"]))
            return
        }

        let userDocRef = db.collection("users").document(user.uid)

        // Quote data to save
        var quoteData: [String: Any] = [
            "id": quote.id,
            "text": quote.text,
            "author": quote.author
        ]

        if let notes = quote.notes {
            quoteData["notes"] = notes
        }

        userDocRef.getDocument { document, error in
            if let error = error {
                completion(error)
                return
            }

            if let document = document, document.exists {
                // Fetch existing quotes and replace or add the quote
                guard let data = document.data(),
                      let quotesArray = data["quotes"] as? [[String: Any]] else {
                    // If no quotes exist, just add the new quote
                    userDocRef.updateData([
                        "quotes": FieldValue.arrayUnion([quoteData])
                    ]) { error in
                        completion(error)
                    }
                    return
                }

                // Remove the old version of the quote if it exists
                let oldQuoteData = quotesArray.first { $0["id"] as? Int == quote.id }
                if let oldQuoteData = oldQuoteData {
                    userDocRef.updateData([
                        "quotes": FieldValue.arrayRemove([oldQuoteData])
                    ]) { error in
                        if let error = error {
                            completion(error)
                            return
                        }

                        // Add the updated quote
                        userDocRef.updateData([
                            "quotes": FieldValue.arrayUnion([quoteData])
                        ]) { error in
                            completion(error)
                        }
                    }
                } else {
                    // No old quote found, just add the new one
                    userDocRef.updateData([
                        "quotes": FieldValue.arrayUnion([quoteData])
                    ]) { error in
                        completion(error)
                    }
                }
            } else {
                // Document doesn't exist, create it
                userDocRef.setData([
                    "quotes": [quoteData]
                ]) { error in
                    completion(error)
                }
            }
        }
    }

    // Fetch all saved quotes for the user
    func fetchSavedQuotes(completion: @escaping ([Quote]?, Error?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(nil, NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"]))
            return
        }

        let userDocRef = db.collection("users").document(user.uid)

        userDocRef.getDocument { document, error in
            if let error = error {
                completion(nil, error)
                return
            }

            guard let document = document, document.exists,
                  let data = document.data(),
                  let quotesArray = data["quotes"] as? [[String: Any]] else {
                completion([], nil) // No quotes found
                return
            }

            // Convert Firestore data to `Quote` objects
            let quotes = quotesArray.compactMap { dict -> Quote? in
                guard let id = dict["id"] as? Int,
                      let text = dict["text"] as? String,
                      let author = dict["author"] as? String else { return nil }

                let notes = dict["notes"] as? String
                return Quote(id: id, text: text, author: author, tags: nil, notes: notes)
            }

            completion(quotes, nil)
        }
    }

    // Delete a quote
    func deleteQuote(_ quote: Quote, completion: @escaping (Error?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"]))
            return
        }

        let userDocRef = db.collection("users").document(user.uid)

        // Quote data to remove
        var quoteData: [String: Any] = [
            "id": quote.id,
            "text": quote.text,
            "author": quote.author
        ]
        if let notes = quote.notes {
            quoteData["notes"] = notes
        }

        userDocRef.updateData([
            "quotes": FieldValue.arrayRemove([quoteData])
        ]) { error in
            completion(error)
        }
    }
}
