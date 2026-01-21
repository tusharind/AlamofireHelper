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

// MARK: - Extension to use with NetworkManager

extension NetworkManager {
    static func requestWithLogging<T: Decodable>(
        url: String,
        method: HTTPMethod,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil,
        completion: @escaping (Result<T, Error>) -> Void,
    ) {
        // Create request
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.method = method
        urlRequest.headers = headers ?? HTTPHeaders()

        if let parameters {
            urlRequest = try! JSONEncoding.default.encode(urlRequest, with: parameters)
        }

        // Log request
        NetworkLogger.logRequest(urlRequest)

        // Make request
        session.request(urlRequest)
            .validate()
            .responseDecodable(of: T.self) { response in
                // Log response
                NetworkLogger.logResponse(
                    response.response,
                    data: response.data,
                    error: response.error,
                )

                switch response.result {
                case let .success(data):
                    completion(.success(data))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
    }
}
