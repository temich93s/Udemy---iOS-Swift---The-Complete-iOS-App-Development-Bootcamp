//
//  ViewController.swift
//  Destini
//
//  Created by Artem Solovev on 17.07.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var storyLabel: UILabel!
    @IBOutlet weak var choice1Button: UIButton!
    @IBOutlet weak var choice2Button: UIButton!
    
    let story0 = ""
    let choice1 = ""
    let choice2 = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // округляем углы на кнопках
        choice1Button.layer.cornerRadius = 20
        choice2Button.layer.cornerRadius = 20
        // несколько строк текста на кнопке
        choice1Button.titleLabel?.numberOfLines = 0
        choice2Button.titleLabel?.numberOfLines = 0
        // выравнивание текста по центру
        choice1Button.titleLabel?.textAlignment = .center
        choice2Button.titleLabel?.textAlignment = .center
        
        storyLabel.text = story[choiceDestination].title
        choice1Button.setTitle(story[choiceDestination].choice1, for: .normal)
        choice2Button.setTitle(story[choiceDestination].choice2, for: .normal)
    }

    @IBAction func choiceMade(_ sender: UIButton) {
        // обновляем историю в зависимости от выбранного ответа
        nextStory(number: sender.tag)
        // устанавливаем текст истории на лейбле и кнопках
        storyLabel.text = story[choiceDestination].title
        choice1Button.setTitle(story[choiceDestination].choice1, for: .normal)
        choice2Button.setTitle(story[choiceDestination].choice2, for: .normal)
    }
}

