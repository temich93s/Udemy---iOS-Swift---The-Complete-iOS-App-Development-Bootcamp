//
//  Item.swift
//  Todoey - Items.plist
//
//  Created by Artem Solovev on 04.08.2022.
//

import Foundation

class Item: Encodable, Decodable {
    var title: String = ""
    var done: Bool = false
}

