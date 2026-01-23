//
//  APIConfig.swift
//  AlamofireHelper
//
//  Created by Tushar on 21/01/26.
//

import Foundation

enum APIConfig {
    static var baseURL: String = "https://jsonplaceholder.typicode.com"

    static var fullBaseURL: String {
        "\(baseURL)/"
    }
}
