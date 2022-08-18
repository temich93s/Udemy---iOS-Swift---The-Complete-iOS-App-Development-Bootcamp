//
//  ViewController.swift
//  Calculator - Advanced
//
//  Created by Artem Solovev on 08.08.2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var displayLabel: UILabel!
    
    // переменная говорит что кнопка с числами была нажата и можно будет проводить вычисления
    private var isFinishedTypingNumber = true
    
    // вычисляемое свойство
    private var displayValue: Double {
        // срабатывает когда пытаемся считать значение
        get {
            // конвертируем значение текстового поля в число
            guard let number = Double(displayLabel.text!) else {
                fatalError("Cannot convert display label text to a Double.")
            }
            return number
        }
        // срабатывает когда пытаемся установить значение
        set {
            displayLabel.text = String(newValue)
        }
    }
    
    // переменая хранящая состояние символа точка (что бы она была только одна)
    private var pointNotPress = true
    private var calculator = CalculatorLogic()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // производим вычисление
    @IBAction func CalcButtonPressed(_ sender: UIButton) {
        isFinishedTypingNumber = true
        pointNotPress = true
        calculator.setNumber(displayValue)
        if let calcMethod = sender.currentTitle {
            if let result = calculator.calculate(symbol: calcMethod) {
                displayValue = result
            }
        }
    }
    
    // метод который срабатывае при нажатии на число и точку
    @IBAction func numButtonPressed(_ sender: UIButton) {
        if let numValue = sender.currentTitle {
            if isFinishedTypingNumber {
                isFinishedTypingNumber = false
                displayLabel.text = numValue
                if numValue == "." {
                    if pointNotPress {
                        pointNotPress = false
                    }
                }
            } else {
                // указываем что была нажата точка
                if numValue == "." {
                    if pointNotPress {
                        pointNotPress = false
                    } else {
                        return
                    }
                }
                // добавляем число на экран
                displayLabel.text = displayLabel.text! + numValue
            }
        }
    }
}
