//
//  FirebaseQuoteService.swift
//  QuoteNest
//
//  Created by Hunter Scheppat on 11/19/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class FirebaseQuoteService {
    static let shared = FirebaseQuoteService()
    private let db = Firestore.firestore()

    private init() {}

    func saveQuote(_ quote: Quote, completion: @escaping (Error?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"]))
            return
        }

        db.collection("users").document(user.uid).collection("quotes").document(quote.id).setData([
            "text": quote.text,
            "author": quote.author,
            "tags": quote.tags ?? []
        ]) { error in
            completion(error)
        }
    }

    func fetchSavedQuotes(completion: @escaping ([Quote]?, Error?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(nil, NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"]))
            return
        }

        db.collection("users").document(user.uid).collection("quotes").getDocuments { (snapshot, error) in
            if let error = error {
                completion(nil, error)
            } else {
                let quotes = snapshot?.documents.compactMap { document -> Quote? in
                    let data = document.data()
                    let id = document.documentID
                    guard let text = data["text"] as? String,
                          let author = data["author"] as? String,
                          let tags = data["tags"] as? [String] else { return nil }
                    return Quote(id: id, text: text, author: author, tags: tags)
                }
                completion(quotes, nil)
            }
        }
    }
}
