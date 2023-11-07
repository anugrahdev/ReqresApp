//
//  UITextField+Extensions.swift
//  ReqresApp
//
//  Created by AnangNugraha on 07/11/23.
//

import Foundation
import UIKit

extension UITextField {
    fileprivate func setPasswordToggleImage(_ button: UIButton) {
        if(isSecureTextEntry){
            button.setImage(UIImage.init(systemName: "eye"), for: .normal)
        }else{
            button.setImage(UIImage.init(systemName: "eye.slash"), for: .normal)
        }
    }
    
    func enablePasswordToggle(){
        let button = UIButton(type: .custom)
        setPasswordToggleImage(button)
        var config = UIButton.Configuration.plain()
        config.imagePadding = 10
        button.configuration = config
        button.tintColor = .gray
        button.frame = CGRect(x: self.frame.size.width - 16, y: 5, width: 16, height: 16)
        button.addTarget(self, action: #selector(self.togglePasswordView), for: .touchUpInside)
        self.rightView = button
        self.rightViewMode = .always
    }
    
    @IBAction func togglePasswordView(_ sender: Any) {
        self.isSecureTextEntry = !self.isSecureTextEntry
        setPasswordToggleImage(sender as! UIButton)
    }
}
