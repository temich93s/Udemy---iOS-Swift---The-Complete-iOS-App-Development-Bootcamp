//
//  WeatherModel.swift
//  Clima
//
//  Created by Artem Solovev on 19.07.2022.
//

import Foundation

struct WeatherModel {
    let conditionId: Int
    let cityName: String
    let temperature: Double
    
    // вычисляемые свойства - фактически не хранят значения, вместо этого они предоставляют геттер и опциональный сеттер для получения и установки других свойств косвенно
    // температура с одним символом после запятой
    var temperatureString: String {
        String(format: "%.1f", temperature)
    }
    
    // SFSymbols в зависимости от id погоды
    var conditionName: String {
        switch conditionId {
                case 200...232:
                    return "cloud.bolt"
                case 300...321:
                    return "cloud.drizzle"
                case 500...531:
                    return "cloud.rain"
                case 600...622:
                    return "cloud.snow"
                case 701...781:
                    return "cloud.fog"
                case 800:
                    return "sun.max"
                case 801...804:
                    return "cloud.bolt"
                default:
                    return "cloud"
                }
    }
}
