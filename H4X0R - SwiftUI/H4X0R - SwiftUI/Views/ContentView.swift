//
//  ContentView.swift
//  H4X0R - SwiftUI
//
//  Created by Artem Solovev on 02.08.2022.
//

import SwiftUI

struct ContentView: View {
    
    // Подписываемся на сообщения, что бы всякий раз услышать от свойства posts, когда происходит его изменение. И для того, чтобы слушать его в нашем contentView, мы собираемся создать объект из этого Класс NetworkManager.
    // @ObservedObject - Тип оболочки свойства, который подписывается на наблюдаемый объект и делает View недействительным при каждом изменении наблюдаемого объекта.
    @ObservedObject var networkManager = NetworkManager()
    
    var body: some View {
        // NavigationView - View для представления стека View, представляющих видимый путь в иерархии навигации.
        NavigationView {
            // List - Контейнер, который представляет строки данных, упорядоченные в один столбец, при необходимости предоставляя возможность выбора одного или нескольких элементов.
            List(networkManager.posts) { post in
                // NavigationLink - View, управляющее представлением навигации. Пользователи щелкают или касаются навигационной ссылки, чтобы отобразить View внутри NavigationView. Вы управляете внешним View ссылки, предоставляя содержимое View в замыкающем конце ссылки.
                NavigationLink(destination: DetailView(url: post.url)) {
                    HStack {
                        Text(String(post.points))
                        Text(post.title)
                    }
                }
            }
            // .navigationTitle - Устанавливает заголовок у NavigationView.
            .navigationTitle("H4N0R NEWS")
        }
        // .onAppear - Добавляет действие для выполнения при появлении текущего View.
        .onAppear {
            self.networkManager.fetchData()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
