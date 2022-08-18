//
//  ChatViewController.swift
//  Flash Chat
//
//  Created by Artem Solovev on 26.07.2022.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    // .firestore() - Создает, кэширует и возвращает «Firestore», используя «FirebaseApp» по умолчанию. Каждый последующий вызов возвращает один и тот же объект «Firestore».
    let db = Firestore.firestore()
    
    // массив из сообщение, нужны были для тестирования приложения
    var messages: [Message] = [
        Message(sender: "1@2.com", body: "Hey!"),
        Message(sender: "a@b.com", body: "Hello!"),
        Message(sender: "1@2.com", body: "What's up?")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // скрываем кнопку Back в верхней панели навигации
        navigationItem.hidesBackButton = true
        
        // устанавливаем UIViewController делегатом (UITableViewDelegate) и истоником данных (UITableViewDataSource) для UITableView
        tableView.delegate = self
        tableView.dataSource = self
        // устанавливаем заголовок нашему ChatViewController
        title = K.appName
        
        // Регистрирует объект UINib (xib), который содержит ячейку UITableView c указанным идентификатором.
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        loadMessages()
    }
    
    // загружаем сообщения из базы данных Firebase
    func loadMessages() {
        // .collection - получаем доступ к коллекции (в Firebase) с указанным именем
        db.collection(K.FStore.collectionName)
            // .order - создаем и выполняем запрос. По умолчани запрос извлекает все документы, которые удовлетворяют запросу, в порядке возрастания по указанному полю.
            .order(by: K.FStore.dateField)
            // .getDocuments() { (querySnapshot, error) in } - (этот метод используется когда данные нужно получить 1 раз, альтернатива .addSnapshotListener) получение доступа ко всем документам нашей коллекций, имеет в конце Completion Handler.
            // .addSnapshotListener - (этот метод используется когда данные нужно получить каждый раз когда данные в коллекции обновились) добавляем прослушивателя коллекции, который делает снимок коллекции с текущем ее содержим. Затем каждый раз, когда содержимое коллекции меняется, "другой вызов" обновляет снимок коллекции.
            // querySnapshot - сам снимок запроса, querySnapshot содержит документы коллекции (в Firebase).
            .addSnapshotListener() { (querySnapshot, error) in
            if let e = error {
                print(e.localizedDescription)
            } else {
                // извлекаем все документы из querySnapshot нашей коллекции, создавая тем самым [QueryDocumentSnapshot]
                if let snapshotDocuments = querySnapshot?.documents {
                    // очищаем массив с сообщениями
                    self.messages = []
                    //  проходим в цикле по каждому документу отдельно
                    for doc in snapshotDocuments {
                        // .data - извлекает все поля из документа в форме как словарей типа [String: Any] .
                        let data = doc.data()
                        // извлекаем содержимое словарей по ключам (sender, body) и сохраняем это содержимое в массив типа Message, который используется для постоения UITableView
                        if let messageSender = data[K.FStore.senderField] as? String,
                           let messageBody = data[K.FStore.bodyField] as? String {
                            let newMessage = Message(sender: messageSender, body: messageBody)
                            self.messages.append(newMessage)
                            DispatchQueue.main.async {
                                // перезагружаем таблицу для обновлеия данных (повторно вызываются методы UITableViewDataSource)
                                self.tableView.reloadData()
                                // получаем индекс предпоследней ячейки
                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                // прокручиваем нашу TableView на одну ячейки вверх, когда добавляется сообщение (пользователь добавляет сообщение -> оно добавляется в БД -> снова вызывается .addSnapshotListener())
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    // отправляем сообщения в базу данных Firebase
    @IBAction func sendPressed(_ sender: UIButton) {
        // проверяем что есть текст сообщения и что отправитель это текущий пользователь
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email {
            // .collection(K.FStore.collectionName) - получаем доступ к коллекции (в Firebase) с указанным именем
            // .addDocument - добавляет в текущую коллекцию (в Firebase) новый документ с указанными данными, автоматически присваивая ему идентификатор документа. После выполнения добавления выполняется Completion Handler
            db.collection(K.FStore.collectionName).addDocument(data: [
                K.FStore.senderField: messageSender,
                K.FStore.bodyField: messageBody,
                // Date().timeIntervalSince1970 - текущее время
                K.FStore.dateField: Date().timeIntervalSince1970
            ]) { (error) in
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    print("Success")
                    DispatchQueue.main.async {
                        // очищаем текстовое поле
                        self.messageTextfield.text = ""
                    }
                }
            }
        }
    }
    
    // разлогиниваемся при нажатии кнопки Log Out в Navigation Bar
    @IBAction func LogOutPressed(_ sender: UIBarButtonItem) {
        do {
            // .signOut() - Выполняет выход текущего пользователя. Может выбросить ошибку - надо обернуть в блок do-catch
            try Auth.auth().signOut()
            // .popToRootViewController - Выталкивает все ViewController в стеке, кроме корневого ViewController, и обновляет отображение. Возвращает нас на экране на корневой ViewController
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}

// UITableViewDataSource - методы, используемые объектом для управления данными и предоставления ячеек для UITableView.
extension ChatViewController: UITableViewDataSource {
    
    // numberOfRoseInSection (вызывается один раз) – указываем сколько строк (ячеек) мы хотим в своем TableView, для конкретной секции
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // устанавливаем количество строк в таблице равному кол-ву собщение в массиве messages
        messages.count
    }
    
    // cellForRowAt (вызывается столько раз сколько у нас строк (ячеек) в таблице) – мы должны тут создать и вернуть UITableViewCell, которую UITableView будет отображать в каждой строке нашего UITableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        
        // .dequeueReusableCell() – возвращает повторно используемую ячейку таблицы для указанного идентификатора и добавляет ее в таблицу.
        // "ReusableCell" - это идентификатор нашей кастомной ячейки, формата .xib
        // as! MessageCell - преобразовываем ячейку типа UITableViewCell до его подклассса MessageCell
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        
        // устанавливаем текст в Label нашей ячейки MessageCell
        cell.label.text = message.body
        
        // кастомизируем ячейку в зависимости кто отправитель сообщения, залогиненный пользователь или нет
        if message.sender == Auth.auth().currentUser?.email {
            // отображаем/прячем картинку отправителя (текущий пользователь или нет)
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            // кастомизируем фон сообщения и цвет текста
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
        } else {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
        }
        
        return cell
    }
}

// UITableViewDelegate - методы управления выборками, настройки верхних и нижних колонтитулов разделов, удаления и изменения порядка ячеек и выполнения других действий в UITableView
extension ChatViewController: UITableViewDelegate {
    
    // didSelectRowAt - выполняет этот блок кода, когда ячейка была выбрана
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
