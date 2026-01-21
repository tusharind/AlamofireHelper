//
//  NetworkManager.swift
//  AlamofireHelper
//
//  Created by Tushar on 21/01/26.
//

import Alamofire
import Foundation

struct NetworkManager {
    static let session: Session = {
        // Basic session configuration
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30

        // Create session with auth interceptor
        let interceptor = AuthInterceptor()
        return Session(configuration: configuration, interceptor: interceptor)
    }()

    static func request<T: Decodable>(
        url: String,
        method: HTTPMethod,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil,
        completion: @escaping (Result<T, Error>) -> Void,
    ) {
        session.request(
            url,
            method: method,
            parameters: parameters,
            headers: headers
        )
        .validate()
        .responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    static func uploadFile<T: Decodable>(
        url: String,
        fileData: Data,
        fileName: String,
        mimeType: String,
        parameters: [String: String]? = nil,
        completion: @escaping (Result<T, Error>) -> Void,
    ) {
        session.upload(
            multipartFormData: { multipartFormData in
                // Add file
                multipartFormData.append(
                    fileData,
                    withName: "file",
                    fileName: fileName,
                    mimeType: mimeType
                )

                // Add other parameters
                if let parameters {
                    for (key, value) in parameters {
                        if let data = value.data(using: .utf8) {
                            multipartFormData.append(data, withName: key)
                        }
                    }
                }
            },
            to: url
        )
        .validate()
        .responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    static func downloadFile(
        url: String,
        destination: DownloadRequest.Destination? = nil,
        completion: @escaping (Result<URL, Error>) -> Void,
    ) {
        let finalDestination =
            destination ?? DownloadRequest.suggestedDownloadDestination()

        session.download(url, to: finalDestination)
            .validate()
            .response { response in
                if let error = response.error {
                    completion(.failure(error))
                } else if let fileURL = response.fileURL {
                    completion(.success(fileURL))
                } else {
                    completion(
                        .failure(NSError(domain: "Download failed", code: -1))
                    )
                }
            }
    }

    static func requestData(
        url: String,
        method: HTTPMethod,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil,
        completion: @escaping (Result<Data, Error>) -> Void,
    ) {
        session.request(
            url,
            method: method,
            parameters: parameters,
            headers: headers
        )
        .validate()
        .responseData { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
