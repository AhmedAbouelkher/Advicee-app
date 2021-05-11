//
//  ApiCaller.swift
//  Advicee
//
//  Created by Ahmed Mahmoud on 08/05/2021.
//

import Foundation
import Alamofire

class ApiCaller {
    public static let shared = ApiCaller()
    
    public func request<T: Codable>(
        _ type: T.Type,
        completion: @escaping (Result<T, AFError>) -> Void
    ) {
        AF.request(Constants.Api.url).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let resp):
                completion(.success(resp))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
