//
//  LoginViewController.swift
//  ReqresApp
//
//  Created by AnangNugraha on 07/11/23.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var welcomeeLabel: UILabel!
    @IBOutlet weak var loginButton: LoaderButton!
    
    var presenter: LoginPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.imageView?.trailingAnchor.constraint(equalTo: loginButton.trailingAnchor, constant: -20.0).isActive = true
        loginButton.imageView?.centerYAnchor.constraint(equalTo: loginButton.centerYAnchor, constant: 0.0).isActive = true
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.imageView?.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.isSecureTextEntry = true
        passwordTextField.enablePasswordToggle()
        let attributedText = NSMutableAttributedString(string: welcomeeLabel.text ?? "")
        let range = (welcomeeLabel.text as NSString?)?.range(of: "Selamat Datang")
        if let range = range {
            attributedText.addAttribute(.font, value: UIFont(name: "Gilroy-ExtraBold", size: 28)!, range: range)
        }
        welcomeeLabel.attributedText = attributedText
    }
    
    @IBAction func loginButtonAction(_ sender: LoaderButton) {
        guard let username = emailTextField.text, let password = passwordTextField.text else { return }
        sender.isLoading = true
        presenter?.doLogin(username: username, password: password)
    }
}

extension LoginViewController: LoginViewProtocol {
    func loginActionHandler(isSuccess: Bool) {
        if isSuccess {
            showSnackbar("Login Success")
        }
        loginButton.isLoading = false
    }
}
