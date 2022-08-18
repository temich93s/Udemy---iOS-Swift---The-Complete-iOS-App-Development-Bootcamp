//
//  CalculatorBrain.swift
//  BMI Calculator
//
//  Created by Artem Solovev on 17.07.2022.
//

import UIKit

struct CalculatorBrain {
    
    var bmi: BMI?
    
    // возвращает значение BMI, в формате 1 символа после запятой
    func getValue() -> String {
        let bmiTo1DecimalPlace = String(format: "%.1f", bmi?.value ?? 0.0)
        return bmiTo1DecimalPlace
    }
    
    // возвращает цвет для текущего BMI
    func getBackgroundColor() -> UIColor {
        return bmi?.color ?? UIColor.white
    }
    
    // вычисление BMI и его установка
    mutating func calculateBMI(height: Float, weight: Float) {
        let bmiValue = weight / (height * height)
        bmi = BMI(value: bmiValue)
    }
}
