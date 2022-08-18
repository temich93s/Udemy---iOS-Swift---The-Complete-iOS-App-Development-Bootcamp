//
//  LoginViewController.swift
//  Flash Chat
//
//  Created by Artem Solovev on 26.07.2022.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!

    @IBAction func loginPressed(_ sender: UIButton) {
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            // .signIn - авторизация пользователя, используя адрес электронной почты и пароль, после авторизации выполняется замыкание в которое передается результат: данные авторизированного пользователя, или ошибка
            // authResult - результат аутентификации (учетная запись пользователя после успешной регистрации)
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e)
                } else {
                    self.performSegue(withIdentifier: K.loginSegue, sender: self)
                }
            }
        }
    }
}
