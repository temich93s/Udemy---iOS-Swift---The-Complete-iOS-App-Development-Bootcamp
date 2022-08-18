//
//  ViewController.swift
//  Xylophone
//
//  Created by Artem Solovev on 14.07.2022.
//

import UIKit
import AVFAudio

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func keyPressed(_ sender: UIButton) {
        //print("sender.titleLabel?.text: \(sender.titleLabel?.text)")
        if let currentSoundName = sender.titleLabel?.text {
            playSound(soundName: currentSoundName)
        }
        // устанавливаем прозрачность. Она распространяется и на дочернии view
        sender.alpha = 0.5
        // создаем асинхронный поток который запуститься через 0.1 сек, и установит прозрачность в 1 (полная непрозрачность).
        // DispatchQueue - управляет выполнением задач последовательно или одновременно в основном потоке вашего приложения или в фоновом потоке.
        // main - основной поток.
        // asyncAfter(wallDeadline:qos:flags:execute:) - выполнение блока в определенный момент времени с использованием указанных атрибутов.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            sender.alpha = 1
        }
    }
    
    // Декларируем аудиоплеер в общей области видимости
    var player: AVAudioPlayer?

    func playSound(soundName: String) {
        // создаем путь до звукового файла.
        // Bundle - представление кода и ресурсов, хранящихся в каталоге на диске.
        // main - директория (пакет), где находится текущий исполняемый файл
        if let url = Bundle.main.url(forResource: "Sounds/\(soundName)", withExtension: "wav") {
            do {
                // создаем и сохраняем аудиоплеер из звукового файла
                player = try AVAudioPlayer(contentsOf: url)
                // воспроизводим аудио (асинхронно)
                player?.play()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

