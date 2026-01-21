//
//  NetworkError.swift
//  AlamofireHelper
//
//  Created by Prakhar Jaiswal on 21/01/26.
//


import Foundation
import Alamofire

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
            return "No internet connection. Please check your network."
        case .timeout:
            return "Request timed out. Please try again."
        case .invalidURL:
            return "Invalid URL."
        case .invalidResponse:
            return "Invalid response from server."
        case .unauthorized:
            return "Unauthorized. Please login again."
        case .forbidden:
            return "Access forbidden."
        case .notFound:
            return "Resource not found."
        case .serverError:
            return "Server error. Please try again later."
        case .decodingError:
            return "Failed to process response data."
        case .encodingError:
            return "Failed to process request data."
        case .unknown(let message):
            return message
        }
    }
    
    var errorCode: Int {
        switch self {
        case .noInternet: return -1009
        case .timeout: return -1001
        case .invalidURL: return -1000
        case .invalidResponse: return -1011
        case .unauthorized: return 401
        case .forbidden: return 403
        case .notFound: return 404
        case .serverError: return 500
        case .decodingError: return -1016
        case .encodingError: return -1015
        case .unknown: return -1
        }
    }
}

// MARK: - Convert AFError to NetworkError

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

// MARK: - NetworkError Extension for User Display

extension NetworkError {
    
    var shouldRetry: Bool {
        switch self {
        case .noInternet, .timeout, .serverError:
            return true
        default:
            return false
        }
    }
    
    var shouldLogout: Bool {
        switch self {
        case .unauthorized:
            return true
        default:
            return false
        }
    }
}
