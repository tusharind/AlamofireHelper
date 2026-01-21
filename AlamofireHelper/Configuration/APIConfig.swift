//
//  APIConfig.swift
//  AlamofireHelper
//
//  Created by Tushar on 21/01/26.
//

import Foundation

// MARK: - Base URL Configuration

struct APIConfig {
    static var baseURL: String = "https://api.yourapp.com"

    static var fullBaseURL: String {
        return "\(baseURL)/"
    }
}

struct APIEndpoints {

    struct Auth {
        static let login = "\(APIConfig.fullBaseURL)/auth/login"
        static let register = "\(APIConfig.fullBaseURL)/auth/register"
        static let logout = "\(APIConfig.fullBaseURL)/auth/logout"
        static let forgotPassword =
            "\(APIConfig.fullBaseURL)/auth/forgot-password"
        static let resetPassword =
            "\(APIConfig.fullBaseURL)/auth/reset-password"
        static let refreshToken = "\(APIConfig.fullBaseURL)/auth/refresh"
    }

    struct User {
        static let profile = "\(APIConfig.fullBaseURL)/user/profile"
        static let updateProfile =
            "\(APIConfig.fullBaseURL)/user/profile/update"
        static let changePassword =
            "\(APIConfig.fullBaseURL)/user/change-password"
        static let uploadAvatar = "\(APIConfig.fullBaseURL)/user/avatar"

        static func getUserById(id: String) -> String {
            return "\(APIConfig.fullBaseURL)/user/\(id)"
        }
    }

    struct Posts {
        static let allPosts = "\(APIConfig.fullBaseURL)/posts"
        static let createPost = "\(APIConfig.fullBaseURL)/posts/create"

        static func getPost(id: String) -> String {
            return "\(APIConfig.fullBaseURL)/posts/\(id)"
        }

        static func updatePost(id: String) -> String {
            return "\(APIConfig.fullBaseURL)/posts/\(id)/update"
        }

        static func deletePost(id: String) -> String {
            return "\(APIConfig.fullBaseURL)/posts/\(id)/delete"
        }
    }

    static func buildURL(endpoint: String, queryParams: [String: String]?)
        -> String
    {
        guard let params = queryParams, !params.isEmpty else {
            return endpoint
        }

        var components = URLComponents(string: endpoint)
        components?.queryItems = params.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        return components?.url?.absoluteString ?? endpoint
    }
}
