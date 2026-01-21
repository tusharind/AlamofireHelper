//
//  AuthInterceptor.swift
//  AlamofireHelper
//
//  Created by Tushar on 21/01/26.
//

import Alamofire
import Foundation

struct AuthInterceptor: RequestInterceptor {
    private let accessTokenKey = "accessToken"
    private let refreshTokenKey = "refreshToken"

    func adapt(
        _ urlRequest: URLRequest,
        for _: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void,
    ) {
        var urlRequest = urlRequest

        // Get access token
        if let token = getAccessToken() {
            urlRequest.setValue(
                "Bearer \(token)",
                forHTTPHeaderField: "Authorization",
            )
        }

        completion(.success(urlRequest))
    }

    func retry(
        _ request: Request,
        for _: Session,
        dueTo _: Error,
        completion: @escaping (RetryResult) -> Void,
    ) {
        guard let response = request.task?.response as? HTTPURLResponse else {
            completion(.doNotRetry)
            return
        }

        // If 401 Unauthorized, try to refresh token
        if response.statusCode == 401 {
            refreshAccessToken { success in
                if success {
                    completion(.retry)
                } else {
                    completion(.doNotRetry)
                }
            }
        } else {
            completion(.doNotRetry)
        }
    }

    func saveAccessToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: accessTokenKey)
    }

    func getAccessToken() -> String? {
        UserDefaults.standard.string(forKey: accessTokenKey)
    }

    func saveRefreshToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: refreshTokenKey)
    }

    func getRefreshToken() -> String? {
        UserDefaults.standard.string(forKey: refreshTokenKey)
    }

    func clearTokens() {
        UserDefaults.standard.removeObject(forKey: accessTokenKey)
        UserDefaults.standard.removeObject(forKey: refreshTokenKey)
    }

    private func refreshAccessToken(completion: @escaping (Bool) -> Void) {
        guard let refreshToken = getRefreshToken() else {
            completion(false)
            return
        }

        // TODO: Replace with your actual refresh token endpoint
        let refreshURL = "YOUR_BASE_URL/auth/refresh"
        let parameters: [String: String] = ["refresh_token": refreshToken]

        AF.request(
            refreshURL,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
        )
        .validate()
        .responseDecodable(of: TokenResponse.self) { response in
            switch response.result {
            case let .success(tokenResponse):
                saveAccessToken(tokenResponse.accessToken)
                if let newRefreshToken = tokenResponse.refreshToken {
                    saveRefreshToken(newRefreshToken)
                }
                completion(true)
            case .failure:
                clearTokens()
                completion(false)
            }
        }
    }
}

nonisolated struct TokenResponse: Decodable, Sendable {
    let accessToken: String
    let refreshToken: String?

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}
