//
//  LoginContract.swift
//  ReqresApp
//
//  Created by AnangNugraha on 07/11/23.
//

import Foundation

protocol LoginViewProtocol: BaseViewProtocol {
    func loginActionHandler(isSuccess: Bool)
}

protocol LoginPresenterProtocol: BasePresenterProtocol {
    func doLogin(username: String, password: String)
}

protocol LoginWireframeProtocol: BaseWireframeProtocol {
    func pushToHomeViewController()
}

protocol LoginInteractorProtocol: BaseInteractorProtocol {
    func login(username: String, password:String)
}

protocol LoginInteractorDelegate: BaseInteractorDelegate {
    func loginSuccessfull(token: String)
}
