//
//  Quote.swift
//  QuoteNest
//
//  Created by Hunter Scheppat on 11/19/24.
//

import Foundation

struct Quote: Identifiable, Codable, Equatable { // Added Equatable
    let id: Int // Updated to match the API's `id` as an Int
    let text: String // Match the API's `quote` field
    let author: String
    let tags: [String]?

    // Custom CodingKeys to map JSON keys to struct properties
    enum CodingKeys: String, CodingKey {
        case id
        case text = "quote" // Map "quote" from JSON to "text"
        case author
        case tags
    }
}
