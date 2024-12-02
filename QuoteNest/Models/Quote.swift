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

