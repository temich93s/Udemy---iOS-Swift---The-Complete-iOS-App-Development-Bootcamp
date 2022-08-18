//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Artem Solovev on 26.07.2022.
//

import Foundation

// протокол делегата для взаимодействия (обновления UI) CoinManager и ViewController
protocol CoinManagerDelegate {
    func didUpdateCoin(coinManager: CoinManager, сoinData: CoinData)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "4E146AA5-FD74-40C0-AB2D-7404C629AA3E"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var delegate: CoinManagerDelegate?
    
    // выполенение сетевого запроса rest.coinapi.io
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) {(data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    //print(String(data: safeData, encoding: .utf8))
                    self.parseJSON(coinData: safeData)
                }
            }
            task.resume()
        }
    }
    
    // декодируем пришедшие данные в формате JSON и вызываем метод делегата по обновлению UI
    func parseJSON(coinData: Data) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            delegate?.didUpdateCoin(coinManager: self, сoinData: decodedData)
        } catch {
            delegate?.didFailWithError(error: error)
        }
    }
}
