//
//  PostData.swift
//  H4X0R - SwiftUI
//
//  Created by 2lup on 02.08.2022.
//

import Foundation

// создаем структура для парсинга пришедших из сети данных
struct Results: Decodable {
    let hits: [Post]
}

struct Post: Decodable, Identifiable {
    var id: String {
        return objectID
    }
    let objectID: String
    let points: Int
    let title: String
    let url: String?
}
