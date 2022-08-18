//
//  BrainCalculator.swift
//  Tipsy
//
//  Created by Artem Solovev on 18.07.2022.
//

import Foundation

struct Calculator {
    // чаевые
    var tip: Float!
    // кол-во человек
    var person: Float!
    // счет
    var bill: Float!
    // процент чаевых
    var percent: String!
    
    // возвращает сумму с каждого человека
    func getResult() -> Float {
        return (bill * (1 + tip)) / person
    }
}
