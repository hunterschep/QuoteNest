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
    
    // Save a quote to the Firestore database
    func saveQuote(_ quote: Quote, completion: @escaping (Error?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"]))
            return
        }
        
        let userDocRef = db.collection("users").document(user.uid)
        
        // Quote data to add
        let quoteData: [String: Any] = [
            "id": quote.id,
            "text": quote.text,
            "author": quote.author
        ]
        
        // Check if the document exists
        userDocRef.getDocument { document, error in
            if let error = error {
                completion(error)
                return
            }
            
            if document?.exists == true {
                // Document exists, update the quotes array
                userDocRef.updateData([
                    "quotes": FieldValue.arrayUnion([quoteData])
                ]) { error in
                    completion(error)
                }
            } else {
                // Document does not exist, create a new document with the quotes array
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
        
        // Try and get the documents
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
                return Quote(id: id, text: text, author: author, tags: nil)
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
        
        // TODO: Deletion
        let userDocRef = db.collection("users").document(user.uid)

        // Get the quotes array from that users document
        
        // Find the quote with the id of the one we want to delete
        
        // Delete it 
    }
}
