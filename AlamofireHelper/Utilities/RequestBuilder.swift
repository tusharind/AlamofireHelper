//
//  RequestBuilder.swift
//  AlamofireHelper
//
//  Created by Tushar on 21/01/26.
//

import Alamofire
import Foundation

class RequestBuilder {
    private var url: String
    private var method: HTTPMethod
    private var parameters: Parameters?
    private var headers: HTTPHeaders
    private var encoding: ParameterEncoding

    init(url: String, method: HTTPMethod = .get) {
        self.url = url
        self.method = method
        headers = HTTPHeaders()
        encoding = JSONEncoding.default
    }

    func setParameters(_ parameters: Parameters) -> RequestBuilder {
        self.parameters = parameters
        return self
    }

    func addHeader(key: String, value: String) -> RequestBuilder {
        headers.add(name: key, value: value)
        return self
    }

    func setHeaders(_ headers: HTTPHeaders) -> RequestBuilder {
        self.headers = headers
        return self
    }

    func setContentType(_ contentType: String) -> RequestBuilder {
        headers.add(name: "Content-Type", value: contentType)
        return self
    }

    func setEncoding(_ encoding: ParameterEncoding) -> RequestBuilder {
        self.encoding = encoding
        return self
    }

    func setURLEncoding() -> RequestBuilder {
        encoding = URLEncoding.default
        return self
    }

    func setJSONEncoding() -> RequestBuilder {
        encoding = JSONEncoding.default
        return self
    }

    func setMethod(_ method: HTTPMethod) -> RequestBuilder {
        self.method = method
        return self
    }

    func execute<T: Decodable>(
        responseType _: T.Type,
        completion: @escaping (Result<T, Error>) -> Void,
    ) {
        NetworkManager.request(
            url: url,
            method: method,
            parameters: parameters,
            headers: headers,
            completion: completion,
        )
    }

    func executeWithLogging<T: Decodable>(
        responseType _: T.Type,
        completion: @escaping (Result<T, Error>) -> Void,
    ) {
        NetworkManager.requestWithLogging(
            url: url,
            method: method,
            parameters: parameters,
            headers: headers,
            completion: completion,
        )
    }

    func buildURLRequest() throws -> URLRequest {
        guard let requestURL = URL(string: url) else {
            throw NetworkError.invalidURL
        }

        var urlRequest = URLRequest(url: requestURL)
        urlRequest.method = method
        urlRequest.headers = headers

        return try encoding.encode(urlRequest, with: parameters)
    }
}

extension RequestBuilder {
    // Quick GET request
    static func get(url: String) -> RequestBuilder {
        RequestBuilder(url: url, method: .get)
            .setURLEncoding()
    }

    // Quick POST request
    static func post(url: String) -> RequestBuilder {
        RequestBuilder(url: url, method: .post)
            .setJSONEncoding()
            .setContentType("application/json")
    }

    // Quick PUT request
    static func put(url: String) -> RequestBuilder {
        RequestBuilder(url: url, method: .put)
            .setJSONEncoding()
            .setContentType("application/json")
    }

    // Quick DELETE request
    static func delete(url: String) -> RequestBuilder {
        RequestBuilder(url: url, method: .delete)
    }
}
