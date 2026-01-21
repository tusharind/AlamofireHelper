//
//  RequestBuilder.swift
//  AlamofireHelper
//
//  Created by Prakhar Jaiswal on 21/01/26.
//


import Foundation
import Alamofire

// MARK: - Request Builder

class RequestBuilder {
    
    private var url: String
    private var method: HTTPMethod
    private var parameters: Parameters?
    private var headers: HTTPHeaders
    private var encoding: ParameterEncoding
    
    init(url: String, method: HTTPMethod = .get) {
        self.url = url
        self.method = method
        self.headers = HTTPHeaders()
        self.encoding = JSONEncoding.default
    }
    
    // MARK: - Add Parameters
    
    func setParameters(_ parameters: Parameters) -> RequestBuilder {
        self.parameters = parameters
        return self
    }
    
    // MARK: - Add Headers
    
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
    
    // MARK: - Set Encoding
    
    func setEncoding(_ encoding: ParameterEncoding) -> RequestBuilder {
        self.encoding = encoding
        return self
    }
    
    func setURLEncoding() -> RequestBuilder {
        self.encoding = URLEncoding.default
        return self
    }
    
    func setJSONEncoding() -> RequestBuilder {
        self.encoding = JSONEncoding.default
        return self
    }
    
    // MARK: - Set Method
    
    func setMethod(_ method: HTTPMethod) -> RequestBuilder {
        self.method = method
        return self
    }
    
    // MARK: - Build and Execute
    
    func execute<T: Decodable>(
        responseType: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        NetworkManager.request(
            url: url,
            method: method,
            parameters: parameters,
            headers: headers,
            completion: completion
        )
    }
    
    func executeWithLogging<T: Decodable>(
        responseType: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        NetworkManager.requestWithLogging(
            url: url,
            method: method,
            parameters: parameters,
            headers: headers,
            completion: completion
        )
    }
    
    // MARK: - Build URLRequest
    
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

// MARK: - Usage Example Extension

extension RequestBuilder {
    
    // Quick GET request
    static func get(url: String) -> RequestBuilder {
        return RequestBuilder(url: url, method: .get)
            .setURLEncoding()
    }
    
    // Quick POST request
    static func post(url: String) -> RequestBuilder {
        return RequestBuilder(url: url, method: .post)
            .setJSONEncoding()
            .setContentType("application/json")
    }
    
    // Quick PUT request
    static func put(url: String) -> RequestBuilder {
        return RequestBuilder(url: url, method: .put)
            .setJSONEncoding()
            .setContentType("application/json")
    }
    
    // Quick DELETE request
    static func delete(url: String) -> RequestBuilder {
        return RequestBuilder(url: url, method: .delete)
    }
}
