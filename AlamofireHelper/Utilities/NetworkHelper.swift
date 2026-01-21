//
//  NetworkHelper.swift
//  AlamofireHelper
//
//  Created by Tushar on 21/01/26.
//

import Alamofire
import Foundation

enum NetworkHelper {
    static func parseError(from data: Data?) -> String {
        guard let data else {
            return "Unknown error occurred"
        }

        // Try to decode as ErrorResponse
        if let errorResponse = try? JSONDecoder().decode(
            ErrorResponse.self,
            from: data,
        ) {
            return errorResponse.message
        }

        // Try to decode as generic APIResponse
        if let jsonObject = try? JSONSerialization.jsonObject(with: data)
            as? [String: Any]
        {
            if let message = jsonObject["message"] as? String {
                return message
            }
            if let error = jsonObject["error"] as? String {
                return error
            }
        }

        return "Unknown error occurred"
    }

    static func isSuccessful(statusCode: Int) -> Bool {
        (200 ... 299).contains(statusCode)
    }

    static func dictionaryToJSON(_ dictionary: [String: Any]) -> String? {
        guard
            let jsonData = try? JSONSerialization.data(
                withJSONObject: dictionary,
                options: .prettyPrinted,
            )
        else {
            return nil
        }
        return String(data: jsonData, encoding: .utf8)
    }

    static func jsonToDictionary(_ jsonString: String) -> [String: Any]? {
        guard let data = jsonString.data(using: .utf8) else {
            return nil
        }
        return try? JSONSerialization.jsonObject(with: data) as? [String: Any]
    }

    static func buildQueryString(from parameters: [String: String]) -> String {
        var components = URLComponents()
        components.queryItems = parameters.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        return components.query ?? ""
    }
}


