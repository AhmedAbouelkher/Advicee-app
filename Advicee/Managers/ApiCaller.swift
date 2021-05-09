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
    
//    public func request<T: Codable>(_  ) {
//        AF.request("https://api.adviceslip.com/advice").responseDecodable(of: T.self) { response in
//            switch response.result {
//            case .success(let resp):
//                DispatchQueue.main.async {
//                    self.adviceLabel.text = resp.slip.advice
//                    self.adviceLabel.isHidden = false
//                    self.leadingIndicator.isHidden = true
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
}
