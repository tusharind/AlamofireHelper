//
//  NetworkManager.swift
//  AlamofireHelper
//
//  Created by Tushar on 21/01/26.
//

import Alamofire
import Foundation

struct NetworkManager: NetworkServiceProtocol {
    let session: Session

    init() {

        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30

        let interceptor = AuthInterceptor()
        let logger = NetworkLogger()
        self.session = Session(
            configuration: configuration,
            interceptor: interceptor,
            eventMonitors: [logger]
        )
    }

    func request<T: Decodable>(
        _ endpoint: URLRequestConvertible,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        session.request(endpoint)
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

    func uploadFile<T: Decodable>(
        _ endpoint: URLRequestConvertible,
        fileData: Data,
        fileName: String,
        mimeType: String,
        parameters: [String: String]? = nil,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        session.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(
                    fileData,
                    withName: "file",
                    fileName: fileName,
                    mimeType: mimeType
                )

                if let parameters {
                    for (key, value) in parameters {
                        if let data = value.data(using: .utf8) {
                            multipartFormData.append(data, withName: key)
                        }
                    }
                }
            },
            with: endpoint
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

    func downloadFile(
        _ endpoint: URLRequestConvertible,
        destination: DownloadRequest.Destination? = nil,
        completion: @escaping (Result<URL, Error>) -> Void
    ) {
        let finalDestination =
            destination ?? DownloadRequest.suggestedDownloadDestination()

        session.download(endpoint, to: finalDestination)
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

    func requestData(
        _ endpoint: URLRequestConvertible,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        session.request(endpoint)
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
