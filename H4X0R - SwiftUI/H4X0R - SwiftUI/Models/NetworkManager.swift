//
//  NetworkManager.swift
//  H4X0R - SwiftUI
//
//  Created by 2lup on 02.08.2022.
//

    import Foundation

    // Как мы можем передать результаты (results) из нашего сетевого менеджера в список внутри contentView? Самый простой способ — это сделать наш NetworkManager соответствующим протоколу, называемому ObservableObject.
    // ObservableObject является протоколом, таким образом, он делает NetworkManager наблюдаемым. А затем можно опубликовать одно или несколько его свойств сказав, что всякий раз, когда он имеет изменения, чтобы уведомить всех слушателей.
    // ObservableObject - По умолчанию ObservableObject синтезирует издателя objectWillChange, который передает измененное значение до любого из его свойств @Published.
    class NetworkManager: ObservableObject {
        
        // Публикуем наши сообщения для любых заинтересованных сторон.
        // Публикация свойства с атрибутом @Published создает издателя этого типа. Вы получаете доступ к издателю с помощью оператора $
        @Published var posts = [Post]()
        
        func fetchData() {
            // URL - Значение, определяющее расположение ресурса, например элемент на удаленном сервере или путь к локальному файлу.
            if let url = URL(string: "https://hn.algolia.com/api/v1/search?tags=front_page") {
                // URLSession - Объект, который координирует группу связанных задач передачи данных по сети.
                let session = URLSession(configuration: .default)
                // .dataTask - Создает задачу, которая извлекает содержимое указанного URL-адреса, а затем вызывает обработчик по завершении.
                let task = session.dataTask(with: url) { data, response, error in
                    if error == nil {
                        // JSONDecoder() - Объект, который декодирует экземпляры типа данных из объектов JSON.
                        let decoder = JSONDecoder()
                        if let safeData = data {
                            do {
                                // .decode - Возвращает значение указанного типа, декодированное из объекта JSON.
                                let result = try decoder.decode(Results.self, from: safeData)
                                // DispatchQueue - Объект, который управляет выполнением задач последовательно или одновременно в основном потоке вашего приложения или в фоновом потоке.
                                // .main - Очередь отправки (dispatch), связанная с основным потоком текущего процесса.
                                // .async - Планирует выполнение блока асинхронно и при необходимости связывает его с группой отправки (dispatch).
                                DispatchQueue.main.async {
                                    self.posts = result.hits
                                }
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                    }
                }
                // .resume - Возобновляет задачу, если она была приостановлена.
                task.resume()
            }
        }
    }
