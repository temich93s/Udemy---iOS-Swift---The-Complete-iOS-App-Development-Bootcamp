//
//  ViewController.swift
//  Quizzler
//
//  Created by Artem Solovev on 16.07.2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var choice1Button: UIButton!
    @IBOutlet weak var choice2Button: UIButton!
    @IBOutlet weak var choice3Button: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    
    // создаем экземпляр структуры со всеми вопросами и ответами
    var quizBrain = QuizBrain()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    @IBAction func answerButtonPressed(_ sender: UIButton) {
        
        // текст выбранного ответа
        let userAnswer = sender.currentTitle!
        // проверяем верный ли был ответ
        let userGotItRight = quizBrain.checkAnswer(userAnswer: userAnswer)
        
        // отображает цветом, правильный ли был ответ
        if userGotItRight {
            sender.configuration?.background.backgroundColor = .green
        } else {
            sender.configuration?.background.backgroundColor = .red
        }
        
        quizBrain.nextQuestion()
        // одноразовый таймер, который обновляет сториборд, спустя 0.2 сек
        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(updateUI), userInfo: nil, repeats: false)
    }
    
    // обновляем сториборд с вопросом
    @objc func updateUI() {
        // устанавливаем вопрос
        questionLabel.text = quizBrain.getQuestionText()
        
        // устанавливаем варианты на кнопках
        choice1Button.setTitle(quizBrain.answerOption(number: 1), for: UIControl.State.normal)
        choice2Button.setTitle(quizBrain.answerOption(number: 2), for: UIControl.State.normal)
        choice3Button.setTitle(quizBrain.answerOption(number: 3), for: UIControl.State.normal)
        
        // отображаем кол-во правильных ответов
        progressBar.progress = quizBrain.getProgress()
        scoreLabel.text = "Score: \(quizBrain.getScore())"
        
        // очищаем фон у кнопок
        choice1Button.configuration?.background.backgroundColor = UIColor.clear
        choice2Button.configuration?.background.backgroundColor = UIColor.clear
        choice3Button.configuration?.background.backgroundColor = UIColor.clear
    }

}


