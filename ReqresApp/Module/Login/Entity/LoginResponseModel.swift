//
//  LoginResponseModel.swift
//  ReqresApp
//
//  Created by AnangNugraha on 07/11/23.
//

import Foundation

struct LoginResponseModel: Codable {
    var token: String?

    enum CodingKeys: String, CodingKey {
        case token = "token"
    }
}
