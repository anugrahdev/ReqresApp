//
//  HomePresenter.swift
//  ReqresApp
//
//  Created by AnangNugraha on 07/11/23.
//

import Foundation

class HomePresenter: HomePresenterProtocol {
    
    let wireframe: HomeWireframeProtocol
    
    init(wireframe: HomeWireframeProtocol) {
        self.wireframe = wireframe
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: "TOKEN")
        wireframe.presentLogin()
    }
    
}
