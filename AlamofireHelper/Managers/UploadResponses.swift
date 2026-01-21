//
//  UploadResponses.swift
//  AlamofireHelper
//
//  Created by Prakhar Jaiswal on 21/01/26.
//

import Foundation

// These pure data models are intentionally declared outside of any @MainActor context
// to keep their Decodable conformances non-isolated and safely Sendable.

nonisolated struct ImageUploadResponse: Decodable, Sendable {
    let success: Bool
    let message: String?
    let imageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case success
        case message
        case imageURL = "image_url"
    }
}

nonisolated struct MultipleImageUploadResponse: Decodable, Sendable {
    let success: Bool
    let message: String?
    let imageURLs: [String]?
    
    enum CodingKeys: String, CodingKey {
        case success
        case message
        case imageURLs = "image_urls"
    }
}
