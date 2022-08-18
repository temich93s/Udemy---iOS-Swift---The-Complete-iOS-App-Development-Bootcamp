//
//  CoinData.swift
//  ByteCoin
//
//  Created by Artem Solovev on 26.07.2022.
//

import Foundation

struct CoinData: Decodable {
    let asset_id_base: String
    let asset_id_quote: String
    let rate: Double
}
