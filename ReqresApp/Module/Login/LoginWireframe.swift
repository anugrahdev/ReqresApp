//
//  LoginWireframe.swift
//  ReqresApp
//
//  Created by AnangNugraha on 07/11/23.
//

import Foundation

class LoginWireframe: LoginWireframeProtocol {
    
    weak var controller: LoginViewController?
    let resolver: Resolver
    
    init(resolver: Resolver) {
        self.resolver = resolver
    }
    
    func setupLoginViewController() -> LoginViewController {
        let interactor = LoginInteractor()
        let presenter = LoginPresenter(interactor: interactor, wireframe: self)
        let view = LoginViewController()
        interactor.delegate = presenter
        controller = view
        view.presenter = presenter
        presenter.view = view
        
        return view
    }
    
    func setLoadingIndicator(isHidden: Bool) {
        
    }
    
    func showNoInternetAlert() {
    }
    
    func showErrorAlert(_ message: String) {
        showSnackbar(message)
    }
}

extension Router {
    
    func setupLoginViewController() -> LoginViewController {
        let wireframe = LoginWireframe(resolver: resolver)
        return wireframe.setupLoginViewController()
    }
    
}
