//
//  HomeContract.swift
//  ReqresApp
//
//  Created by AnangNugraha on 07/11/23.
//

import Foundation

protocol HomePresenterProtocol: BasePresenterProtocol {
    func logout()
}

protocol HomeWireframeProtocol: BaseWireframeProtocol {
    func presentLogin()
}
