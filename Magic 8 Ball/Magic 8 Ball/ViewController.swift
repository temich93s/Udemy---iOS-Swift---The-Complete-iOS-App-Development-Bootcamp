//
//  ViewController.swift
//  Magic 8 Ball
//
//  Created by 2lup on 12.07.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading , view.
    }

    @IBAction func askButtonPressed(_ sender: UIButton) {
        imageView.image = [UIImage(named: "ball1"),
                           UIImage(named: "ball2"),
                           UIImage(named: "ball3"),
                           UIImage(named: "ball4"),
                           UIImage(named: "ball5")
                           ][Int.random(in: 0...4)]
    }
    
}

