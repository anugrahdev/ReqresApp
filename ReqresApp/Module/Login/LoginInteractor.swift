//
//  LoginInteractor.swift
//  ReqresApp
//
//  Created by AnangNugraha on 07/11/23.
//

import Foundation

class LoginInteractor: LoginInteractorProtocol {
    weak var delegate: LoginInteractorDelegate?

    func login(username: String, password: String) {
        let params: [String: String] = [
            "password": password,
            "username": username
        ]
        
        RestApiServices.shared.postLogin(params: params) { [weak self] (result: LoginResponseModel) in
            guard let token = result.token else { return }
            self?.delegate?.loginSuccessfull(token: token)
        } failure: { error in
            self.delegate?.serviceRequestDidFail(error)
        }

    }
}
