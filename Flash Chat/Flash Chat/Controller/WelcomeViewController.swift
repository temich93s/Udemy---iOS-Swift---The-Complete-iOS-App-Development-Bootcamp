//
//  WelcomeViewController.swift
//  Flash Chat
//
//  Created by Artem Solovev on 26.07.2022.
//

import UIKit
import CLTypingLabel

class WelcomeViewController: UIViewController {

    // Создаем аутлет у titleLabel типа CLTypingLabel, на сториборде мы UILabel так же изменили тип на CLTypingLabel
    @IBOutlet weak var titleLabel: CLTypingLabel!
    
    // viewWillAppear - выполняется прям перед тем как UIViewController появится на экране
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // скрываем UINavigationController на экране WelcomeViewController перед показом WelcomeViewController на экране
        navigationController?.isNavigationBarHidden = true
    }
    
    // viewDidDisappear - выполняется сразу после как UIViewController исчезло на экране
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // показываем UINavigationController на экране WelcomeViewController перед исчезанием WelcomeViewController с экрана
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = K.appName
    }
    
}
