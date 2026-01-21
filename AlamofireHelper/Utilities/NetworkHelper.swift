//
//  NetworkHelper.swift
//  AlamofireHelper
//
//  Created by Prakhar Jaiswal on 21/01/26.
//


import Foundation
import Alamofire

// MARK: - Network Helper Utilities

struct NetworkHelper {
    
    // MARK: - Parse Error from Response
    
    static func parseError(from data: Data?) -> String {
        guard let data = data else {
            return "Unknown error occurred"
        }
        
        // Try to decode as ErrorResponse
        if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
            return errorResponse.message
        }
        
        // Try to decode as generic APIResponse
        if let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            if let message = jsonObject["message"] as? String {
                return message
            }
            if let error = jsonObject["error"] as? String {
                return error
            }
        }
        
        return "Unknown error occurred"
    }
    
    // MARK: - Check Response Success
    
    static func isSuccessful(statusCode: Int) -> Bool {
        return (200...299).contains(statusCode)
    }
    
    // MARK: - Convert Dictionary to JSON String
    
    static func dictionaryToJSON(_ dictionary: [String: Any]) -> String? {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted) else {
            return nil
        }
        return String(data: jsonData, encoding: .utf8)
    }
    
    // MARK: - Convert JSON String to Dictionary
    
    static func jsonToDictionary(_ jsonString: String) -> [String: Any]? {
        guard let data = jsonString.data(using: .utf8) else {
            return nil
        }
        return try? JSONSerialization.jsonObject(with: data) as? [String: Any]
    }
    
    // MARK: - Build Query String
    
    static func buildQueryString(from parameters: [String: String]) -> String {
        var components = URLComponents()
        components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        return components.query ?? ""
    }
    
    // MARK: - Extract File Extension
    
    static func getFileExtension(from url: String) -> String {
        let urlComponents = url.components(separatedBy: ".")
        return urlComponents.last ?? ""
    }
    
    // MARK: - Get MIME Type
    
    static func getMimeType(for fileExtension: String) -> String {
        switch fileExtension.lowercased() {
        case "jpg", "jpeg":
            return "image/jpeg"
        case "png":
            return "image/png"
        case "gif":
            return "image/gif"
        case "pdf":
            return "application/pdf"
        case "txt":
            return "text/plain"
        case "json":
            return "application/json"
        case "mp4":
            return "video/mp4"
        case "mp3":
            return "audio/mpeg"
        default:
            return "application/octet-stream"
        }
    }
    
    // MARK: - Validate Email
    
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    // MARK: - Pretty Print JSON
    
    static func prettyPrintJSON(_ data: Data) -> String {
        if let jsonObject = try? JSONSerialization.jsonObject(with: data),
           let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
           let prettyString = String(data: prettyData, encoding: .utf8) {
            return prettyString
        }
        return String(data: data, encoding: .utf8) ?? "Unable to print JSON"
    }
    
    // MARK: - Calculate Request Timeout
    
    static func calculateTimeout(for fileSize: Int64) -> TimeInterval {
        // Base timeout of 30 seconds
        var timeout: TimeInterval = 30
        
        // Add 10 seconds for every MB
        let fileSizeInMB = Double(fileSize) / (1024 * 1024)
        timeout += fileSizeInMB * 10
        
        // Max timeout of 5 minutes
        return min(timeout, 300)
    }
    
    // MARK: - Format File Size
    
    static func formatFileSize(_ bytes: Int64) -> String {
        let kb = Double(bytes) / 1024
        let mb = kb / 1024
        let gb = mb / 1024
        
        if gb >= 1 {
            return String(format: "%.2f GB", gb)
        } else if mb >= 1 {
            return String(format: "%.2f MB", mb)
        } else if kb >= 1 {
            return String(format: "%.2f KB", kb)
        } else {
            return "\(bytes) bytes"
        }
    }
    
    // MARK: - Retry Delay Calculator
    
    static func calculateRetryDelay(attemptNumber: Int) -> TimeInterval {
        // Exponential backoff: 1s, 2s, 4s, 8s, etc.
        return pow(2.0, Double(attemptNumber))
    }
}
