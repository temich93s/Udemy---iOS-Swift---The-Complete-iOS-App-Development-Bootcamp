//
//  ContentView.swift
//  Dicee - SwiftUI
//
//  Created by Artem Solovev on 01.08.2022.
//

import SwiftUI

struct ContentView: View {
    
    // Так как мы в ходе выполнения программы меняем эти переменные которые являются частью структуры, то нам нужно mutable. Но в SwiftUI есть специальная оболочка свойств под названием State, которую мы можем использовать. Таким образом, это позволит нам обновить эти переменные и заставить Swift воссоздать этот contentView всякий раз, когда значение этих переменных изменится
    @State var leftDiceNumber = 1
    @State var rightDiceNumber = 1
    
    var body: some View {
        ZStack() {
            Image("newbackground")
                // изменяет размер изображения, чтобы его размер соответствовал пространству текущему View
                .resizable()
                // игнорируем безопасною зону
                .ignoresSafeArea()
            VStack() {
                Image("diceeLogo")
                // Spacer() - пространство, расширяющееся вдоль главной оси содержащей его компоновки стека или по обеим осям, если оно не содержится в стеке.
                Spacer()
                HStack {
                    // наша игральная кость
                    DiceView(n: leftDiceNumber)
                    DiceView(n: rightDiceNumber)
                }
                // отступы по горизонтали у HStack
                .padding(.horizontal)
                Spacer()
                // создаем кнопку
                // action - то что она делает при нажатии (выполняется замыкание)
                Button(action: {
                    self.leftDiceNumber = Int.random(in: 1...6)
                    self.rightDiceNumber = Int.random(in: 1...6)
                }) {
                    // сам UI кнопки
                    Text("Roll")
                        .font(.system(size: 60))
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .padding(.all)
                }
            }
        }
    }
}

struct DiceView: View {
    
    let n: Int
    
    var body: some View {
        // устанавливаем изображение игральной кости по имени
        Image("dice\(n)")
            // изменяет размер изображения, чтобы его размер соответствовал пространству текущему View
            .resizable()
            // Ограничивает размеры View указанным соотношением сторон.
            .aspectRatio(1, contentMode: .fit)
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
