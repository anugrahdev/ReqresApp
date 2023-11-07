//
//  HomeWireframe.swift
//  ReqresApp
//
//  Created by AnangNugraha on 07/11/23.
//

import Foundation

class HomeWireframe: HomeWireframeProtocol {
    
    weak var controller: HomeViewController?
    let resolver: Resolver
    
    init(resolver: Resolver) {
        self.resolver = resolver
    }
    
    func setupHomeViewController() -> HomeViewController {
        let presenter = HomePresenter( wireframe: self)
        let view = HomeViewController()
        controller = view
        view.presenter = presenter
        
        return view
    }
    
    func presentLogin() {
        let router = resolver.resolve(Router.self)
        let viewController = router.setupLoginViewController()
        controller?.navigationController?.setViewControllers([viewController], animated: true)
    }
    
    func showErrorAlert(_ message: String) {}

}

extension Router {
    
    func setupHomeViewController() -> HomeViewController {
        let wireframe = HomeWireframe(resolver: resolver)
        return wireframe.setupHomeViewController()
    }
    
}
