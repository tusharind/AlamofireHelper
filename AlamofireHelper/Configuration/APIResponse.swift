//
//  APIResponse.swift
//  AlamofireHelper
//
//  Created by Tushar on 21/01/26.
//

import Foundation

struct APIResponse<T: Decodable>: Decodable {
    let success: Bool
    let message: String?
    let data: T?
    let errors: [String]?

    enum CodingKeys: String, CodingKey {
        case success
        case message
        case data
        case errors
    }
}

struct MessageResponse: Decodable {
    let message: String
}

struct EmptyResponse: Decodable {
    // Use when API returns empty response
}

struct PaginatedResponse<T: Decodable>: Decodable {
    let data: [T]
    let currentPage: Int
    let totalPages: Int
    let totalItems: Int
    let itemsPerPage: Int

    enum CodingKeys: String, CodingKey {
        case data
        case currentPage = "current_page"
        case totalPages = "total_pages"
        case totalItems = "total_items"
        case itemsPerPage = "items_per_page"
    }
}

struct ErrorResponse: Decodable {
    let success: Bool
    let message: String
    let errors: [String]?
    let errorCode: String?

    enum CodingKeys: String, CodingKey {
        case success
        case message
        case errors
        case errorCode = "error_code"
    }
}

extension APIResponse {
    var isSuccess: Bool {
        success && data != nil
    }

    var errorMessage: String {
        if let errors, !errors.isEmpty {
            return errors.joined(separator: ", ")
        }
        return message ?? "Unknown error occurred"
    }
}
