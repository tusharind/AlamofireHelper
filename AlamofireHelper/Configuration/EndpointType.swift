//
//  EndpointType.swift
//  AlamofireHelper
//
//  Created by Tushar on 21/01/26.
//

import Alamofire
import Foundation

protocol EndpointType: URLRequestConvertible {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
    var encoding: ParameterEncoding { get }
    var headers: HTTPHeaders? { get }
}

extension EndpointType {
    var headers: HTTPHeaders? { nil }
    var encoding: ParameterEncoding { JSONEncoding.default }

    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        if let headers = headers {
            for header in headers {
                request.setValue(header.value, forHTTPHeaderField: header.name)
            }
        }

        if let parameters = parameters {
            return try encoding.encode(request, with: parameters)
        }

        return request
    }
}
