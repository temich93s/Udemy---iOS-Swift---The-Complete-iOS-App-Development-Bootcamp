//
//  WeatherManager.swift
//  Clima
//
//  Created by Artem Solovev on 19.07.2022.
//

import Foundation
import CoreLocation

// создаем протокол делегата для WeatherManager
protocol WeatherModelDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    // URL-ссылка с готовым запросом (URL-запрос)
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid="
    // приватный ключ API
    let apiKey = ""
    
    // свойство делегата
    var delegate: WeatherModelDelegate?
    
    // осуществление запроса по имени города
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)\(apiKey)&units=metric&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    // осуществление запроса по координатам
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        // CLLocationDegrees это Double (используется просто typealias)
        let urlString = "\(weatherURL)\(apiKey)&units=metric&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    // осуществляем запрос
    func performRequest(with urlString: String) {
        // 1. Cоздаем URL
        if let url = URL(string: urlString) {
            // 2. Cоздаем URL-сессию
            let session = URLSession(configuration: .default)
            // 3. Создаем задачу с заданным URL и с обработчиком (замыкание) принимаемых данных. Замыкание это - completionHandler
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                    // вызываем метод делегата, что произошла ошибка
                    delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    // let dataString = String(data: safeData, encoding: .utf8)
                    // print(dataString)
                    // парсим пришедшие данные о погоде в формате JSON и сохраняем результат в переменной weather типа WeatherModel
                    if let weather = parseJSON(safeData) {
                        // вызываем метод делегата, передавая ему данные о погоде
                        delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            // 4. Запускаем задачу по получению данных о погоде
            task.resume()
        }
    }
    
    // функция парсинга пришедших данных о погоде в формате JSON
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        // создаем декодер данных типа JSON
        let decoder = JSONDecoder()
        do {
            // осуществляем декодирование данных типа JSON из пришедших данных
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            // формируем переменную типа WeatherModel из данных о погоде
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
        } catch {
            print(error)
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
