//
//  PostRouter.swift
//  AlamofireHelper
//
//  Created by Tushar on 21/01/26.
//

import Alamofire
import Foundation

enum PostRouter: EndpointType {
    case allPosts
    case createPost(title: String, body: String, userId: Int)
    case getPost(id: String)
    case updatePost(id: String)
    case deletePost(id: String)

    var baseURL: URL {
        URL(string: APIConfig.baseURL)!
    }

    var path: String {
        switch self {
        case .allPosts, .createPost:
            return "posts"
        case .getPost(let id), .updatePost(let id), .deletePost(let id):
            return "posts/\(id)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .allPosts, .getPost:
            return .get
        case .createPost:
            return .post
        case .updatePost:
            return .put
        case .deletePost:
            return .delete
        }
    }

    var parameters: Parameters? {
        switch self {
        case .allPosts, .getPost, .deletePost, .updatePost:
            return nil
        case .createPost(let title, let body, let userId):
            return [
                "title": title,
                "body": body,
                "userId": userId,
            ]
        }
    }

    var encoding: ParameterEncoding {
        switch self {
        case .createPost:
            return JSONEncoding.default
        default:
            return URLEncoding.default
        }
    }
}

extension NetworkServiceProtocol {
    func request<T: Decodable>(
        _ endpoint: PostRouter,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        request(endpoint as URLRequestConvertible, completion: completion)
    }

    func requestData(
        _ endpoint: PostRouter,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        requestData(endpoint as URLRequestConvertible, completion: completion)
    }
}
