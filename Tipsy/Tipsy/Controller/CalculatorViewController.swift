//
//  CalculatorViewController.swift
//  Tipsy
//
//  Created by Artem Solovev on 18.07.2022.
//

import UIKit

class CalculatorViewController: UIViewController {

    var calculator = Calculator()
    
    @IBOutlet weak var billTextField: UITextField!
    @IBOutlet weak var zeroPctButton: UIButton!
    @IBOutlet weak var tenPctButton: UIButton!
    @IBOutlet weak var twentyPctButton: UIButton!
    @IBOutlet weak var splitNumberLabel: UILabel!
    @IBOutlet weak var stepperButton: UIStepper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // задаем параметры степперу
        stepperButton.minimumValue = 2
        stepperButton.maximumValue = 12
        stepperButton.stepValue = 1
        stepperButton.value = 2
        
        // задаем плейсхолдер текстовому полю
        billTextField.placeholder = "e.g. 123.56"
        // задаем тип клавиатуры текстового поля
        billTextField.keyboardType = .decimalPad
        
    }
    
    @IBAction func tipChanged(_ sender: UIButton) {
        
        // убираем у всех кнопок статус "выбрана"
        zeroPctButton.isSelected = false
        tenPctButton.isSelected = false
        twentyPctButton.isSelected = false
        
        // проверяем какая кнопка была нажата, и устанавливаем ей статус "выбрана"
        switch sender {
        case zeroPctButton:
            zeroPctButton.isSelected = true
        case tenPctButton:
            tenPctButton.isSelected = true
        case twentyPctButton:
            twentyPctButton.isSelected = true
        default:
            break
        }
        // При значении true говорит view (или одному из его встроенных текстовых полей) выйти из статуса первого ответчика.
        // Это строка необходима что бы скрыть клавиатуру текстового поля при срабатывании IBAction
        view.endEditing(true)
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        // меняем значение у splitNumberLabel в зависимости от значения степпера, и отфарматировав его
        splitNumberLabel.text = String(format: "%.0f", sender.value)
        view.endEditing(true)
    }
    
    @IBAction func calculatePress(_ sender: UIButton) {
        // осуществляем переход на ResultViewController
        self.performSegue(withIdentifier: "getResult", sender: self)
    }
    
    // осуществляем подготовку ResultViewController перед тем как осуществить переход на него
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // устанавливаем значения по кол-ву человек и счету
        calculator.person = Float(stepperButton.value)
        // ?? - оператор объединения по nil (a ?? b)
        calculator.bill = Float(billTextField.text ?? "0") ?? 0.0
        
        // устанавливаем значение по значению чаевых
        if zeroPctButton.isSelected == true {
            calculator.tip = 0.0
            calculator.percent = "0%"
        } else if tenPctButton.isSelected == true {
            calculator.tip = 0.1
            calculator.percent = "10%"
        } else if twentyPctButton.isSelected == true {
            calculator.tip = 0.2
            calculator.percent = "20%"
        } else {
            calculator.tip = 0.0
            calculator.percent = "0%"
        }
        print(calculator)
        print(calculator.getResult())
        
        // передаему значения текущего экземпляра calculator созданного в CalculatorViewController экземпляру calculator, что существует в ResultViewController
        if segue.identifier == "getResult" {
            let destinationVC = segue.destination as! ResultViewController
            destinationVC.calculator = self.calculator
        }
    }
}
