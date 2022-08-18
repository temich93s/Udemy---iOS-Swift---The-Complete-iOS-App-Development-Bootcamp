//
//  ResultViewController.swift
//  Tipsy
//
//  Created by Artem Solovev on 18.07.2022.
//

import UIKit

class ResultViewController: UIViewController {

    var calculator = Calculator()
    
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var settingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        totalLabel.text = String(format: "%.2f", calculator.getResult())
        settingLabel.text = "Split between " + String(format: "%.0f", calculator.person!) + " people, with \(calculator.percent!) tip."
    }
    
    @IBAction func recalculatePressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}
