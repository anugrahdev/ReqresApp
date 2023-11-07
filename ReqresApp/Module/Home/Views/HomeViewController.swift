//
//  HomeViewController.swift
//  ReqresApp
//
//  Created by AnangNugraha on 07/11/23.
//

import UIKit

class HomeViewController: UIViewController {

    var presenter: HomePresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logoutButtonAction(_ sender: UIButton) {
        presenter?.logout()
    }
    
}
