//
//  NetworkLogger.swift
//  AlamofireHelper
//
//  Created by Tushar on 21/01/26.
//

import Alamofire
import Foundation

struct NetworkLogger: EventMonitor {

    var isEnabled: Bool = true

    let queue = DispatchQueue.main

    init() {
        print("NetworkLogger initialized")
    }

    func requestDidResume(_ request: Request) {
        guard isEnabled else { return }

        print("\n======== REQUEST ========")
        print("URL: \(request.request?.url?.absoluteString ?? "No URL")")
        print("Method: \(request.request?.httpMethod ?? "No Method")")

        if let headers = request.request?.allHTTPHeaderFields, !headers.isEmpty
        {
            print("Headers:")
            for (key, value) in headers {
                print("  \(key): \(value)")
            }
        }

        if let body = request.request?.httpBody {
            if let jsonString = String(data: body, encoding: .utf8) {
                print("Body: \(jsonString)")
            }
        }
        print("========================\n")
    }

    func request<Value>(
        _ request: DataRequest,
        didParseResponse response: DataResponse<Value, AFError>
    ) {
        guard isEnabled else { return }

        print("\n======== RESPONSE ========")

        if let httpResponse = response.response {
            print("Status Code: \(httpResponse.statusCode)")
            print("URL: \(httpResponse.url?.absoluteString ?? "No URL")")
        }

        if let data = response.data {
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Data: \(jsonString)")
            }
        }

        if let error = response.error {
            print("Error: \(error.localizedDescription)")
        }

        print("========================\n")
    }
}
