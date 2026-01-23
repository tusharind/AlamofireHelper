//
//  AuthViewModel.swift
//  AlamofireHelper
//
//  Created by Tushar on 23/01/26.
//

import Alamofire
import Combine
import Foundation

class AuthViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let networkManager: NetworkServiceProtocol

    init(networkManager: NetworkServiceProtocol) {
        self.networkManager = networkManager
    }

    func refreshAccessToken(completion: @escaping (Bool) -> Void) {
        guard let refreshToken = TokenManager.shared.getRefreshToken() else {
            completion(false)
            return
        }

        isLoading = true
        errorMessage = nil

        networkManager.request(.refreshToken(token: refreshToken)) {
            [weak self] (result: Result<TokenResponse, Error>) in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let tokenResponse):
                    TokenManager.shared.saveAccessToken(
                        tokenResponse.accessToken
                    )
                    if let newRefreshToken = tokenResponse.refreshToken {
                        TokenManager.shared.saveRefreshToken(newRefreshToken)
                    }
                    completion(true)
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    TokenManager.shared.clearTokens()
                    completion(false)
                }
            }
        }
    }
}
