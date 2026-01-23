//
//  TokenManager.swift
//  AlamofireHelper
//
//  Created by Tushar on 23/01/26.
//

import Foundation

class TokenManager {
    static let shared = TokenManager()

    private let accessTokenKey = "accessToken"
    private let refreshTokenKey = "refreshToken"

    private init() {}

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
}
