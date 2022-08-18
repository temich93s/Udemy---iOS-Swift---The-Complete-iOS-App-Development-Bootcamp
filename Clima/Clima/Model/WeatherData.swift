//
//  WeatherData.swift
//  Clima
//
//  Created by Artem Solovev on 19.07.2022.
//

import Foundation

// Decodable - тип, который может декодировать себя из внешнего представления.

// структура для парсинга данных о погоде пришедших с openweathermap.org
struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable {
    let temp: Double
}

struct Weather: Decodable {
    let id: Int
}
