//
//  RESTService.swift
//  CoreTranslate
//
//  Created by Daniel.Metzing on 12.01.18.
//  Copyright © 2018 Dirtylabs. All rights reserved.
//

import Foundation
import Alamofire

final class RESTService {

    enum Error: Swift.Error {
        case invalidRequest
    }

    enum Method: String {
        case get = "GET"
        case post = "POST"

        func toHTTPMethod() -> HTTPMethod {
            switch self {
            case .get: return .get
            case .post: return .post
            }
        }
    }

    struct Request {
        let method: Method
        let path: String
        let parameters: [String: String]?
        let headers: [String: String]?
    }

    let baseURL: URL

    init(baseURL: URL) {
        self.baseURL = baseURL
    }

    func executeWithDataResponse(request: Request, completion: @escaping (Result<Data>) -> Void) {
        guard let url = URL(string: request.path, relativeTo: self.baseURL) else {
            completion(.failure(RESTService.Error.invalidRequest))
            return
        }

        Alamofire.request(url,
                          method: request.method.toHTTPMethod(),
                          parameters: request.parameters,
                          encoding: JSONEncoding.default,
                          headers: request.headers).responseData { response in
                            switch response.result {
                            case .success(let data):
                                completion(.success(data))
                            case .failure(let error):
                                completion(.failure(error))
                            }
        }
    }

    func executeWithDecodableResponse<T: Decodable>(request: Request, completion: @escaping (Result<T>) -> Void) {
        self.executeWithDataResponse(request: request) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let decodedResponse = try decoder.decode(T.self, from: data)
                    completion(.success(decodedResponse))
                } catch let error {
                    completion(.failure(error))
                }
            }
        }
    }
}
