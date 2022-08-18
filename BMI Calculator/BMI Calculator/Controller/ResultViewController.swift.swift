//
//  ResultViewController.swift.swift
//  BMI Calculator
//
//  Created by Artem Solovev on 17.07.2022.
//

import UIKit

// контроллер с результатом
class ResultViewController: UIViewController {

    var bmiValue: String?
    var bmiAdvice: String?
    var backgroundColor: UIColor?
    
    @IBOutlet weak var bmiLabel: UILabel!
    @IBOutlet weak var adviceLabel: UILabel!
    @IBOutlet weak var resultBackground: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // устанавливаем текущие значения на UI в зависимости от текущего BMI
        bmiLabel.text = bmiValue
        adviceLabel.text = bmiAdvice
        view.backgroundColor = backgroundColor
        //resultBackground.backgroundColor = backgroundColor
    }
    
    // возвращаемся на мейн контроллер при нажатии кнопки, уничтожая ResultViewController
    @IBAction func recalculatePressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
