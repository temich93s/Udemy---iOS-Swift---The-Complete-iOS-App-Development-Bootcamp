//
//  Item.swift
//  Todoey - Realm
//
//  Created by Artem Solovev on 06.08.2022.
//

import Foundation
// фреймворк для работы с Realm
import RealmSwift

// Object — это класс, используемый для определения объектов модели Realm. В Realm вы определяете свои классы моделей, создавая подклассы Object и добавляя свойства, которыми нужно управлять. Затем вы создаете экземпляры и используете свои пользовательские подклассы вместо прямого использования класса Object.
class Item: Object {
    
    // dynamic - это то, что называется модификатором объявления. Он в основном говорит среде выполнения использовать динамическую отправку, которая по стандарту изначально является статической отправкой. Это в основном позволяет отслеживать изменение свойства во время работы приложения. Это означает, что если пользователь во время работы приложения изменяет значение свойства name, то dynamic позволяет Realm динамически обновлять эти изменения в БД. Динамическая отправка - это то, что на самом деле происходит от API Objective-C. Таким образом, это означает, что мы должны отметить dynamic с помощью Objective-C, чтобы было ясно, что мы используем cреду выполнения Objective-C
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    
    // LinkingObjects - это автоматически обновляемый тип контейнера. Он представляет ноль или более объектов, которые связаны с принадлежащим ему объектом модели через отношения свойств.
    let parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
