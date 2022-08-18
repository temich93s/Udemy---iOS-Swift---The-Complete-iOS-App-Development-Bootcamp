//
//  WebView.swift
//  H4X0R - SwiftUI
//
//  Created by 2lup on 02.08.2022.
//

import Foundation
import WebKit
import SwiftUI

// UIViewRepresentable - Оболочка для View из UIKit, которую вы используете для интеграции этого View в иерархию представлений SwiftUI.
struct WebView: UIViewRepresentable {
    
    let urlString: String?
    
    // makeUIView - Создает объект View и настраивает его начальное состояние.
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    // updateUIView - Обновляет состояние указанного View новой информацией из SwiftUI.
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let safeString = urlString {
            // URL - Значение, определяющее расположение ресурса, например элемент на удаленном сервере или путь к локальному файлу.
            if let url = URL(string: safeString) {
                // URLRequest - инкапсулирует два основных свойства запроса на загрузку: загружаемый URL-адрес и политики, используемые для его загрузки. Кроме того, для запросов HTTP и HTTPS URLRequest включает метод HTTP (GET, POST и т. д.) и заголовки HTTP.
                let request = URLRequest(url: url)
                // .load - Загружает веб-контент, на который ссылается указанный объект запроса URL, и переходит к этому контенту.
                uiView.load(request)
            }
        }
    }
}
