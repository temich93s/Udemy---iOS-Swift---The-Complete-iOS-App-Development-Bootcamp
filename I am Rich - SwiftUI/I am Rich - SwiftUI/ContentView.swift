//
//  ContentView.swift
//  I am Rich - SwiftUI
//
//  Created by Artem Solovev on 31.07.2022.
//

import SwiftUI

// ContentView - определяет, как будет выглядеть пользовательский интерфейс и как он будет себя вести
struct ContentView: View {
    var body: some View {
        // cтек по оси Z. Создаем его, что бы фон (цветовая заливка) был позади, остальное спереди
        ZStack {
            // устанавливаем цвет всему ZStack
            Color(.systemTeal)
                // указываем какие области SafeArea игнорируются
                .edgesIgnoringSafeArea(.all)
            // cтек по оси V
            VStack {
                // View, отображающее одну или несколько строк текста, доступного только для чтения
                Text("I Am Rich")
                    // Устанавливает шрифт для текста
                    .font(.system(size: 40))
                    // Устанавливает толщину шрифта текста
                    .fontWeight(.bold)
                    // Задает цвет текста
                    .foregroundColor(Color.white)
                    // Добавляет равное количество отступов к определенным краям View
                    .padding()
                // View, отображающее изображение
                Image("diamond")
                    // изменяет размер изображения, чтобы его размер соответствовал пространству текущему View
                    .resizable()
                    // Ограничивает размеры изображения определенным соотношением сторон
                    // .fit - Параметр, который пытается показать все изображение, масштабирует изображение (сохраняя пропорции) в соответствии с размером вида вдоль одной оси, возможно, оставляя пустое пространство вдоль другой оси. Результат гарантирует, что будет показано все изображение.
                    .aspectRatio(contentMode: .fit)
                    // Помещает текущее View в невидимую рамку указанного размера и выравнивая контент внутри нее.
                    .frame(width: 200, height: 200, alignment: .center)
            }
        }
        
    }
}

// ContentView_Previews - определяет, как должен быть создан предварительный просмотр и как он должен вести себя.
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            // .previewInterfaceOrientation - ориентация предпросмотра
            // .portrait - портретная ориентация
            .previewInterfaceOrientation(.portrait)
    }
}
