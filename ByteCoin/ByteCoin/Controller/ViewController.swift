//
//  ViewController.swift
//  ByteCoin
//
//  Created by Artem Solovev on 26.07.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    // экземпляр структуры, где у нас осуществляются сетевые запросы и парсинг JSON
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // указываем что ViewController источник данных для UIPickerView и устанавливаем ViewController в качестве делегата
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self
    }

}

//MARK: - UIPickerViewDataSource
extension ViewController: UIPickerViewDataSource {
    
    // устанавливаем количество столбцов (компонента) UIPickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // устанавливаем количество строк для столбца (компонента)
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
}

//MARK: - UIPickerViewDelegate
extension ViewController: UIPickerViewDelegate {
    
    // titleForRow - этот метод возвращает содержимое для выбранной строки столбца (компонента)
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    // didSelectRow - этот метод выполняется, когда пользователь выбирает строку в компоненте
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //print(coinManager.currencyArray[row])
        let selectedCurrency = coinManager.currencyArray[row]
        // формируем URL-запрос в форме строки
        let personalUrlString = "\(coinManager.baseURL)/\(selectedCurrency)?apikey=\(coinManager.apiKey)"
        // print(personalUrlString)
        // осуществляем сетевой запрос
        coinManager.performRequest(with: personalUrlString)
    }
}

//MARK: - CoinManagerDelegate
extension ViewController: CoinManagerDelegate {
    
    // обновление UI основываясь на полученных данных от rest.coinapi.io
    func didUpdateCoin(coinManager: CoinManager, сoinData: CoinData) {
        DispatchQueue.main.async {
            self.currencyLabel.text = сoinData.asset_id_quote
            self.bitcoinLabel.text = String(format: "%.2f", сoinData.rate)
        }
    }

    // метод на случай возникновения ошибки 
    func didFailWithError(error: Error) {
        print(error)
    }
}

