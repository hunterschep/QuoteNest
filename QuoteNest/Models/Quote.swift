/*
    
    @file: Quote.swift
    @project: QuoteNest | Fall 2024 Swift Final Project
    @author: Hunter Scheppat
    @date: December 2nd, 2024
 
    @description: class file for a singular 'Quote' retrieved from the API
 
 */

import Foundation

// Quote struct
struct Quote: Identifiable, Codable, Equatable {
    // Quote fields gathered from API
    let id: Int
    let text: String
    let author: String
    let tags: [String]?

    // User-added field for notes
    var notes: String?

    // Custom CodingKeys to map JSON keys to struct properties
    enum CodingKeys: String, CodingKey {
        case id
        case text = "quote" // Map "quote" from JSON to "text"
        case author
        case tags
    }
}

extension Quote {
    static var mockSavedQuotes: [Quote] {
        return [
            Quote(
                id: 1,
                text: "The only limit to our realization of tomorrow is our doubts of today.",
                author: "Franklin D. Roosevelt",
                tags: ["motivational", "future"],
                notes: "This inspires me to overcome self-doubt."
            ),
            Quote(
                id: 2,
                text: "In the middle of every difficulty lies opportunity.",
                author: "Albert Einstein",
                tags: ["opportunity", "challenge"],
                notes: "Reminds me of tackling my project deadlines."
            ),
            Quote(
                id: 3,
                text: "Do not dwell in the past, do not dream of the future, concentrate the mind on the present moment.",
                author: "Buddha",
                tags: ["mindfulness", "present"],
                notes: "Helps me stay grounded during stressful times."
            ),
            Quote(
                id: 4,
                text: "It always seems impossible until it is done.",
                author: "Nelson Mandela",
                tags: ["determination", "success"],
                notes: "A reminder to persist through challenges."
            ),
            Quote(
                id: 5,
                text: "Happiness depends upon ourselves.",
                author: "Aristotle",
                tags: ["happiness", "self"],
                notes: "Great reminder that I control my own happiness."
            ),
        ]
    }
}


