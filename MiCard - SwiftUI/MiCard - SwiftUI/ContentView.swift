//
//  ContentView.swift
//  MiCard - SwiftUI
//
//  Created by Artem Solovev on 01.08.2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            // устанавливаем фон
            Color(red: 0.18, green: 0.80, blue: 0.44, opacity: 1)
                // игнорируем безопасною зону
                .ignoresSafeArea()
            VStack {
                Image("programmer")
                    // изменяет размер изображения, чтобы его размер соответствовал пространству текущему View
                    .resizable()
                    // .aspectRatio - ограничивает размеры View указанным соотношением сторон.
                    // .fit - Параметр, который пытается показать все изображение, масштабирует изображение (сохраняя пропорции) в соответствии с размером вида вдоль одной оси, возможно, оставляя пустое пространство вдоль другой оси. Результат гарантирует, что будет показано все изображение.
                    .aspectRatio(contentMode: .fit)
                    // .background() - устанавливает фон для View в стиль фона по умолчанию.
                    .background()
                    // Помещает текущее View в невидимую рамку указанного размера и выравнивая контент внутри нее.
                    .frame(width: 150.0, height: 150.0)
                    // Обрезает View в форму, используя стиль определенной фигуры.
                    .clipShape(Circle())
                    // Накладывает дополнительный View перед текущим View
                    .overlay(
                        // Круг
                        Circle()
                            // Обводит контур текущей фигуры цветом или градиентом.
                            .stroke(Color.white, lineWidth: 2)
                    )
                Text("Name SecondName")
                    // устанавливаем кастомный шрифт
                    .font(Font.custom("TitilliumWeb-BoldItalic", size: 40))
                    // устанавливаем цвет текста
                    .foregroundColor(.white)
                    // Устанавливает толщину шрифта текста
                    .fontWeight(.bold)
                Text("iOS Developer")
                    // устанавливаем системный шрифт
                    .font(.system(size: 25))
                    // устанавливаем цвет текста
                    .foregroundColor(.white)
                // Визуальный элемент, который можно использовать для разделения другого контента.
                Divider()
                // используем наши кастомные InfoView
                InfoView(text: "+7-ХХХХ-ХХ-ХХ-ХХ", imageName: "phone.fill")
                InfoView(text: "example-mail@email.com", imageName: "envelope.fill")
            }
        }
    }
}

// ContentView_Previews - определяет, как должен быть создан предварительный просмотр и как он должен вести себя.
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .previewInterfaceOrientation(.portrait)
        }
    }
}
