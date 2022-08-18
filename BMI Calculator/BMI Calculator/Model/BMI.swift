//
//  BMI.swift
//  BMI Calculator
//
//  Created by Artem Solovev on 17.07.2022.
//

import UIKit

// структура содержащая BMI, совет и фоновый цвет
struct BMI {
    let value: Float
    let advice: String
    let color: UIColor
    
    init (value: Float) {
        switch value {
        case ..<18.5:
            self.value = value
            self.advice = "Underweight"
            self.color = UIColor.blue
        case ..<24.9:
            self.value = value
            self.advice = "Healthy"
            self.color = UIColor.green
        case 24.9...:
            self.value = value
            self.advice = "Overweight"
            self.color = UIColor.orange
        default:
            self.value = value
            self.advice = "ERROR"
            self.color = UIColor.white
        }
    }
}
