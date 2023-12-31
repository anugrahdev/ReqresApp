//
//  RestApiServices.swift
//  ReqresApp
//
//  Created by AnangNugraha on 07/11/23.
//

import Foundation
import Alamofire

protocol RestApiServicesProtocol {
    func postLogin<T: Codable>(params: [String:String], success: @escaping (T) -> Void, failure: @escaping (CustomError) -> Void)
}

class RestApiServices: RestApiServicesProtocol {
    
    static let shared = {
        RestApiServices()
    }()
    
    func postLogin<T: Codable>(params: [String:String], success: @escaping (T) -> Void, failure: @escaping (CustomError) -> Void) {
        let url = BASE_URL + NetworkServiceConstant.loginURL.rawValue
        AF.request(url, method: .post, parameters: params, encoder: JSONParameterEncoder.default)
            .validate(statusCode: 200..<400)
            .responseDecodable(of: T.self){ response in
                debugPrint(response)
            switch response.result {
            case .success(let data):
                success(data)
            case .failure(let error):
                if let errorData = response.data, let customError = try? JSONDecoder().decode(ErrorResponse.self, from: errorData) {
                    failure(CustomError(title: "error", description: customError.error ?? error.localizedDescription, code: error.responseCode ?? 0))
                }
            }
        }
        
    }
    
}
