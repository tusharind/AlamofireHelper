//
//  NetworkError.swift
//  AlamofireHelper
//
//  Created by Tushar on 21/01/26.
//

import Alamofire
import Foundation

// MARK: - Custom Network Errors

enum NetworkError: Error {
    case noInternet
    case timeout
    case invalidURL
    case invalidResponse
    case unauthorized
    case forbidden
    case notFound
    case serverError
    case decodingError
    case encodingError
    case unknown(String)

    var errorMessage: String {
        switch self {
        case .noInternet:
            "No internet connection. Please check your network."
        case .timeout:
            "Request timed out. Please try again."
        case .invalidURL:
            "Invalid URL."
        case .invalidResponse:
            "Invalid response from server."
        case .unauthorized:
            "Unauthorized. Please login again."
        case .forbidden:
            "Access forbidden."
        case .notFound:
            "Resource not found."
        case .serverError:
            "Server error. Please try again later."
        case .decodingError:
            "Failed to process response data."
        case .encodingError:
            "Failed to process request data."
        case .unknown(let message):
            message
        }
    }

    var errorCode: Int {
        switch self {
        case .noInternet: -1009
        case .timeout: -1001
        case .invalidURL: -1000
        case .invalidResponse: -1011
        case .unauthorized: 401
        case .forbidden: 403
        case .notFound: 404
        case .serverError: 500
        case .decodingError: -1016
        case .encodingError: -1015
        case .unknown: -1
        }
    }
}

extension NetworkError {
    static func fromAFError(_ error: AFError) -> NetworkError {
        // Check for network connectivity
        if let underlyingError = error.underlyingError as NSError? {
            if underlyingError.code == NSURLErrorNotConnectedToInternet {
                return .noInternet
            }
            if underlyingError.code == NSURLErrorTimedOut {
                return .timeout
            }
        }

        // Check response status code
        if let statusCode = error.responseCode {
            switch statusCode {
            case 401:
                return .unauthorized
            case 403:
                return .forbidden
            case 404:
                return .notFound
            case 500...599:
                return .serverError
            default:
                return .unknown("HTTP Error \(statusCode)")
            }
        }

        // Check for specific AFError types
        if error.isInvalidURLError {
            return .invalidURL
        }

        if error.isResponseSerializationError {
            return .decodingError
        }

        if error.isParameterEncodingError {
            return .encodingError
        }

        return .unknown(error.localizedDescription)
    }

    static func fromError(_ error: Error) -> NetworkError {
        if let afError = error as? AFError {
            return fromAFError(afError)
        }

        if let networkError = error as? NetworkError {
            return networkError
        }

        let nsError = error as NSError
        if nsError.code == NSURLErrorNotConnectedToInternet {
            return .noInternet
        }
        if nsError.code == NSURLErrorTimedOut {
            return .timeout
        }

        return .unknown(error.localizedDescription)
    }
}

extension NetworkError {
    var shouldRetry: Bool {
        switch self {
        case .noInternet, .timeout, .serverError:
            true
        default:
            false
        }
    }

    var shouldLogout: Bool {
        switch self {
        case .unauthorized:
            true
        default:
            false
        }
    }
}
