//
//  SecondViewController.swift
//  BMI Calculator
//
//  Created by Artem Solovev on 17.07.2022.
//

import UIKit

class SecondViewController: UIViewController {

    var bmiValue = "0.0"

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .blue

        let label = UILabel()
        label.text = bmiValue
        label.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        view.addSubview(label)
    }

}
