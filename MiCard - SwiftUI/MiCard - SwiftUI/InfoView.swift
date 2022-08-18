//
//  InfoView.swift
//  MiCard - SwiftUI
//
//  Created by Artem Solovev on 01.08.2022.
//

import SwiftUI

// Создали отдельное Subview, для многоразового использования
struct InfoView: View {
    
    // создаем свойства, что бы можно было через них кастомизировать InfoView
    let text: String
    let imageName: String
    
    var body: some View {
        // прямоугольник с закругленными углами
        RoundedRectangle(cornerRadius: 25)
            // .frame - помещает текущее View в невидимую рамку указанного размера и выравнивая контент внутри нее. Если вы укажете только одно из измерений, то для другого измерения View примет все доступное пространство родительского View.
            .frame(height: 50)
            // .foregroundColor - задает цвет элементов переднего плана, отображаемых этим View (задаем цвет View)
            .foregroundColor(.white)
            // .overlay - Накладывает дополнительный вид перед этим видом.
            .overlay(
                HStack {
                    // добавляем изображение используя SF Symbols
                    Image(systemName: imageName)
                        // задаем цвет SF Symbols
                        .foregroundColor(.green)
                    Text(text)
                        // задаем цвет тексту
                        .foregroundColor(.black)
                })
            // .padding - Добавляет равное количество отступов к определенным краям View.
            // .all – означает добавление отступов всем сторонам
            .padding(.all)
    }
}

// ContentView_Previews - определяет, как должен быть создан предварительный просмотр и как он должен вести себя.
struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView(text: "+7-ХХХХ-ХХ-ХХ-ХХ", imageName: "phone.fill")
            .previewLayout(.sizeThatFits)
    }
}
