//
//  AuthRouter.swift
//  AlamofireHelper
//
//  Created by Tushar on 21/01/26.
//

import Alamofire
import Foundation

enum AuthRouter: EndpointType {
    case refreshToken(token: String)

    var baseURL: URL {
        URL(string: APIConfig.baseURL)!
    }

    var path: String {
        switch self {
        case .refreshToken:
            return "auth/refresh"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .refreshToken:
            return .post
        }
    }

    var parameters: Parameters? {
        switch self {
        case .refreshToken(let token):
            return ["refresh_token": token]
        }
    }

    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
}

extension NetworkServiceProtocol {
    func request<T: Decodable>(
        _ endpoint: AuthRouter,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        request(endpoint as URLRequestConvertible, completion: completion)
    }

    func requestData(
        _ endpoint: AuthRouter,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        requestData(endpoint as URLRequestConvertible, completion: completion)
    }
}
