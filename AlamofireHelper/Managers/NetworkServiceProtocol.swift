//
//  NetworkServiceProtocol.swift
//  AlamofireHelper
//
//  Created by Tushar on 23/01/26.
//

import Alamofire
import Foundation

protocol NetworkServiceProtocol {
    func request<T: Decodable>(
        _ endpoint: URLRequestConvertible,
        completion: @escaping (Result<T, Error>) -> Void
    )

    func requestData(
        _ endpoint: URLRequestConvertible,
        completion: @escaping (Result<Data, Error>) -> Void
    )

    func uploadFile<T: Decodable>(
        _ endpoint: URLRequestConvertible,
        fileData: Data,
        fileName: String,
        mimeType: String,
        parameters: [String: String]?,
        completion: @escaping (Result<T, Error>) -> Void
    )

    func downloadFile(
        _ endpoint: URLRequestConvertible,
        destination: DownloadRequest.Destination?,
        completion: @escaping (Result<URL, Error>) -> Void
    )
}
