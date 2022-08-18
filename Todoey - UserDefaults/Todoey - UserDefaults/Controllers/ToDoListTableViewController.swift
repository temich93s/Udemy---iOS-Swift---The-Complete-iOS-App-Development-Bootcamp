//
//  ToDoListTableViewController.swift
//  Todoey - UserDefaults
//
//  Created by Artem Solovev on 04.08.2022.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = ["One", "Two", "Three"]
    
    // получаем доступ к файлу UserDefaults
    // UserDefaults - Интерфейс к пользовательской базе данных по умолчанию, где вы постоянно храните пары ключ-значение при запуске вашего приложения.
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Вытаскиваем данные из файла UserDefaults по ключу "TodoListArray" массив с данными и кастим данные как [String]
        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
            itemArray = items
        }
    }
    
    //MARK: - Tableview Datasource Methods
    
    // задаем количество строк в UITableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    // задаем ячейку для UITableView
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // .dequeueReusableCell - возвращает многократно используемую ячейку UITableView по указанному идентификатору
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    //MARK: - Add new Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        // создаем UITextField в который мы сохраним введеные данные пользователя в текстовое поле UIAlert
        var textField = UITextField()
        // создаем UIAlertController
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        // создаем действие для UIAlertController
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            self.itemArray.append(textField.text!)
            // Записываем значение (в нашем случае это массив [String]) для указанного ключа в файл UserDefaults
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            self.tableView.reloadData()
        }
        // добавляем TextField нашему алерту и сохраняем введенные данные пользователем в заранее созданный UITextField
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        // добавляем экшн кнопки
        alert.addAction(action)
        // отображаем на экране наш UIAlertController
        present(alert, animated: true, completion: nil)
    }
}
