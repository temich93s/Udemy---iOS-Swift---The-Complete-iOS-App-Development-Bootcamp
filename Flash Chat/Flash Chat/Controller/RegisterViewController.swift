//
//  RegisterViewController.swift
//  Flash Chat
//
//  Created by Artem Solovev on 26.07.2022.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBAction func registerPressed(_ sender: UIButton) {
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            // .createUser - создание нового пользователя, после создания выполняется замыкание в которое передается результат: данные созданного нового пользователя, или ошибка 
            // authResult - результат аутентификации (учетная запись пользователя после успешной регистрации)
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    self.performSegue(withIdentifier: K.registerSegue, sender: self)
                }
            }
        }
    }    
}
