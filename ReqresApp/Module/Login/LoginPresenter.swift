//
//  LoginPresenter.swift
//  ReqresApp
//
//  Created by AnangNugraha on 07/11/23.
//

import Foundation

class LoginPresenter: LoginPresenterProtocol {
    
    weak var view: LoginViewProtocol?
    let interactor: LoginInteractorProtocol
    let wireframe: LoginWireframeProtocol
    
    init(interactor: LoginInteractorProtocol, wireframe: LoginWireframeProtocol) {
        self.interactor = interactor
        self.wireframe = wireframe
    }
    
    func doLogin(username: String, password: String) {
        interactor.login(username: username, password: password)
    }
}

extension LoginPresenter: LoginInteractorDelegate {
    func loginSuccessfull(token: String) {
        view?.loginActionHandler(isSuccess: true)
    }
    
    func serviceRequestDidFail(_ error: NSError) {
        view?.loginActionHandler(isSuccess: false)
        DispatchQueue.main.async { [weak self] in
            self?.wireframe.showErrorAlert(error.localizedDescription)
        }
    }
}
