//
//  ViewController.swift
//  BMI Calculator
//
//  Created by Artem Solovev on 17.07.2022.
//

import UIKit

// мейн контроллер
class ViewController: UIViewController {

    //var bmi: Float = 0
    
    var calculatorBrain = CalculatorBrain()
    
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    @IBOutlet weak var heightSlider: UISlider!
    @IBOutlet weak var weightSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // изменение роста на UI при перемещении слайдера
    @IBAction func heightSliderChanged(_ sender: UISlider) {
        let height = String(format: "%.2f", sender.value)
        heightLabel.text = height + "m"
        
    }
    
    // изменение веса на UI при перемещении слайдера
    @IBAction func weightSliderChanged(_ sender: UISlider) {
        let weight = String(format: "%.0f", sender.value)
        weightLabel.text = "\(weight)Kg"
    }
    
    //
    @IBAction func calculatePressed(_ sender: UIButton) {
        let height = heightSlider.value
        let weight = weightSlider.value
        
        calculatorBrain.calculateBMI(height: height, weight: weight)
        
        /*
        // другой код-пример по переходу на другой контроллер
        bmi = weight / pow(height, 2)
        // создание SecondViewController
        let secondVC = SecondViewController()
        secondVC.bmiValue = String(format: "%.1f", bmi)
        // .present() - модально представляет SecondViewController
        self.present(secondVC, animated: true, completion: nil)
        */
        
        // вызов сегвея, который осуществляет переход из текущего ViewController на ResultViewController
        self.performSegue(withIdentifier: "goToResult", sender: self)
    }
    
    // prepare(for:sender:) - уведомляет UIViewController о предстоящем переходе
    // segue - объект перехода, содержащий информацию о UIViewController, участвующих в переходе
    // sender - объект, инициировавший переход. Вы можете использовать этот параметр для выполнения различных действий в зависимости от того, какой элемент управления (или другой объект) инициировал переход.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // проверяем наш ли сегвей инициализировал переход
        if segue.identifier == "goToResult" {
            // segue.destination - это UIViewController на который segue осуществляет переход
            // as? ResultViewController - проверяем через приведение типов, что контроллер на который мы переходим это ResultViewController
            if let destination = segue.destination as? ResultViewController {
                // настраиваем свойства ResultViewController
                destination.bmiValue = calculatorBrain.getValue()
                destination.bmiAdvice = calculatorBrain.bmi?.advice ?? "ERROR"
                destination.backgroundColor = calculatorBrain.getBackgroundColor()
            }
        }
    }
    
}

