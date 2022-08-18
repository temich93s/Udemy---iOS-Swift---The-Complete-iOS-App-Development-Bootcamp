//
//  Question.swift
//  Quizzler
//
//  Created by Artem Solovev on 16.07.2022.
//

import Foundation

struct Question {
    let text: String
    let answer: [String]
    let correctAnswer: String
    
    // инициализатор
    init(q: String, a: [String], correctAnswer: String) {
        text = q
        answer = a
        self.correctAnswer = correctAnswer
    }
}
