//
//  WeatherViewController.swift
//  Clima
//
//  Created by Artem Solovev on 19.07.2022.
//

import UIKit
// CoreLocation - получение географического положениеъя и ориентации устройства.
import CoreLocation

//MARK: WeatherViewController

class WeatherViewController: UIViewController {

    var weatherManager = WeatherManager()
    // создаем диспетчер местоположения
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // устанавливаем WeatherViewController в качестве делагата
        searchTextField.delegate = self
        weatherManager.delegate = self
        locationManager.delegate = self
        
        // вызываем запрос на разрешение использования данных о местоположении (добавив информацию об этом в файл info.plist - эта информация будет отображена в запросе)
        locationManager.requestWhenInUseAuthorization()
        // осуществляем однократный запрос на текущее местоположение пользователя
        locationManager.requestLocation()
    }
    
    // осуществляем однократный запрос на текущее местоположение пользователя при нажатии кнопки locationButtonPressed
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
}

//MARK: - UITextFieldDelegate

// UITextFieldDelegate - набор дополнительных методов управления редактированием и проверкой текста в объекте текстового поля.
extension WeatherViewController: UITextFieldDelegate {
   
    // прекращаем редактирование UITextField (убираем статус первого ответчика - при этом скроется клавиатура) при нажатии searchPressed
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    // textFieldShouldReturn - cпрашивает делегата, следует ли обрабатывать нажатие кнопки Return для текстового поля.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    // textFieldShouldEndEditing - спрашивает делегата, стоит ли прекращать редактирование в указанном текстовом поле. Тут мы обычно проверяем, что ввел пользователь, перед тем как выполнить его желание по остановке редактирования текста
    // прекращаем редактирование только когда есть текст в UITextField.
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
    // textFieldDidEndEditing - cообщает делегату, когда редактирование останавливается для указанного текстового поля, и причину его остановки. Тут мы обычно совершаем какое-либо действие, когда редактирование UITextField точно прекратилось
    // когда редактирование останавливается, осуществляем запрос на погоду для указаного в UITextField имени города
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
    }
}

//MARK: - WeatherViewController

extension WeatherViewController: WeatherModelDelegate {
    
    // функция которая вызывается, когда данные о погоде были успешно получены
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        // обновляем UI, поскольку это функция вызывается из completionHandler и так как мы обновляем UI, то мы должны выполнять код по обновлению UI в основном потоке
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    
    // функция которая вызывается, если во время запроса/получения данных о погоде возникла ошибка
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate

// CLLocationManagerDelegate - методы, которые используются для получения событий из диспетчера местоположений.
extension WeatherViewController: CLLocationManagerDelegate {
    
    // didUpdateLocations - сообщает делегату, что доступны новые данные о местоположении.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            // Останавливаем генерацию обновлений местоположения
            locationManager.stopUpdatingLocation()
            // latitude - широта
            let lat = location.coordinate.latitude
            // longitude - долгота
            let lon = location.coordinate.longitude
            print(lat, lon)
            // осуществляем запрос о погоде для текущего местоположения
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    // didFailWithError - cообщает делегату, что диспетчер местоположения не смог получить значение местоположения.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
