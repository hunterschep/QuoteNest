//
//  Quote.swift
//  QuoteNest
//
//  Created by Hunter Scheppat on 11/19/24.
//

import Foundation

struct Quote: Identifiable, Codable {
    let id: String // Use a UUID or Firebase's document ID for saved quotes
    let text: String
    let author: String
    let tags: [String]?

    init(id: String = UUID().uuidString, text: String, author: String, tags: [String]? = nil) {
        self.id = id
        self.text = text
        self.author = author
        self.tags = tags
    }
}
