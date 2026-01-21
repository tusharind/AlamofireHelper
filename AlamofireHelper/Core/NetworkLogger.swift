//
//  NetworkLogger.swift
//  AlamofireHelper
//
//  Created by Tushar on 21/01/26.
//

import Alamofire
import Foundation

enum NetworkLogger {
    // Enable/disable logging
    static var isEnabled: Bool = true

    // MARK: - Log Request

    static func logRequest(_ request: URLRequest?) {
        guard isEnabled else { return }
        guard let request else { return }

        print("\n======== REQUEST ========")
        print("URL: \(request.url?.absoluteString ?? "No URL")")
        print("Method: \(request.httpMethod ?? "No Method")")

        if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
            print("Headers:")
            for (key, value) in headers {
                print("  \(key): \(value)")
            }
        }

        if let body = request.httpBody {
            if let jsonString = String(data: body, encoding: .utf8) {
                print("Body: \(jsonString)")
            }
        }
        print("========================\n")
    }

    // MARK: - Log Response

    static func logResponse(_ response: HTTPURLResponse?, data: Data?, error: Error?) {
        guard isEnabled else { return }

        print("\n======== RESPONSE ========")

        if let response {
            print("Status Code: \(response.statusCode)")
            print("URL: \(response.url?.absoluteString ?? "No URL")")
        }

        if let data {
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Data: \(jsonString)")
            }
        }

        if let error {
            print("Error: \(error.localizedDescription)")
        }

        print("========================\n")
    }
}

