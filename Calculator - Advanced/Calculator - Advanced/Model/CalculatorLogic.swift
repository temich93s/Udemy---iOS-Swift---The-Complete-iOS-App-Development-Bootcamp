//
//  CalculatorLogic.swift
//  Calculator - Advanced
//
//  Created by Artem Solovev on 08.08.2022.
//

import Foundation

struct CalculatorLogic {
    
    private var number: Double?
    
    // кортеж хранящий число и математический оператор
    private var intermediadeCalculation: (n1: Double, calcMethod: String)?
    
    // устанавливаем число в приватную переменную
    mutating func setNumber(_ number: Double) {
        self.number = number
    }
    
    mutating func calculate(symbol: String) -> Double? {
        if let n = number {
            switch symbol {
            // меняем знак числа на противоположный
            case "+/-":
                return n * -1
            // сбрасываем значение на 0
            case "AC":
                return 0
            // превращаем в процент
            case "%":
                return n * 0.01
            // вычисляем результат между текущим и промежуточным числом
            case "=":
                return performTwoNumCalculation(n2: n)
            // сохраняем число и математический оператор
            default:
                intermediadeCalculation = (n1: n, calcMethod: symbol)
            }
        }
        return nil
    }
    
    private func performTwoNumCalculation(n2: Double) -> Double? {
        if let n1 = intermediadeCalculation?.n1,
           let operation = intermediadeCalculation?.calcMethod {
            // производим вычисление
            switch operation {
            case "+":
                return n1 + n2
            case "-":
                return n1 - n2
            case "×":
                return n1 * n2
            case "÷":
                return n1 / n2
            default:
                fatalError("The operation passed in does not match any of the cases.")
            }
        }
        return nil
    }
}
