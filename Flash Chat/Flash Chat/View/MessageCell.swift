//
//  MessageCell.swift
//  Flash Chat
//
//  Created by Artem Solovev on 26.07.2022.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var messageBubble: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var leftImageView: UIImageView!
    
    // awakeFromNib() - инфраструктура загрузки nib отправляет сообщение awakeFromNib каждому объекту, воссозданному из архива nib, но только после того, как все объекты в архиве были загружены и инициализированы. Когда объект получает сообщение awakeFromNib, гарантируется, что все его @IBOutlet и @IBAction уже установлены.
        
    // viewDidLoad() - этот метод вызывается после того, как ViewController загрузил свою иерархию View в память. Этот метод вызывается независимо от того, была ли иерархия View загружена из файла nib или создана программно в методе loadView. Обычно этот метод переопределяется для выполнения дополнительной инициализации View, загруженных из nib файлов.

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        messageBubble.layer.cornerRadius = messageBubble.frame.size.height / 5
    }

    // выполняется когда ячейка выбрана
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
