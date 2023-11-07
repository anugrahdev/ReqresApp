//
//  ErrorResponse.swift
//  ReqresApp
//
//  Created by AnangNugraha on 07/11/23.
//

import Foundation

struct ErrorResponse: Codable {
    var error: String?

    enum CodingKeys: String, CodingKey {
        case error = "error"
    }
}
