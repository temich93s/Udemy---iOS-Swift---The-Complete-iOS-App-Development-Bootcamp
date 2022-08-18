//
//  ToDoListTableViewController.swift
//  Todoey - Items.plist
//
//  Created by Artem Solovev on 04.08.2022.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    // FileManager - модуль для взаимодействия с содержимым файловой системы
    // .appendingPathComponent - создает файл и возвращает путь до этого файла
    // файл Items.plist создается в папке Documents нашего приложения в файловой системе iOS
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(dataFilePath ?? "nil")
        // загружаем данные из Items.plist
        loadItems()
        
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
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        // устанавливаем голочку или нет у ячейки таблицы (условный тернарныый оператор a?b:c)
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    
    //MARK: - Tableview Delegate Methods
    
    // вызывается при нажатии на ячейку таблицы
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //меняем чек-марку и сохраняем данные в .plist
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        // .deselectRow - отменяет выбор строки
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add new Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        // создаем UITextField в который мы сохраним введеные данные пользователя в текстовое поле UIAlert
        var textField = UITextField()
        // создаем UIAlertController
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        // создаем действие для UIAlertController
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            self.saveItems()
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
    
    // MARK: - Save Items and Load Items
     
    func saveItems() {
        // создаем кодер, который кодирует данные типа списка свойств (.plist)
        let encoder = PropertyListEncoder()
        do {
            // кодируем данные и сохраняем их в переменную data типа Data
            let data = try encoder.encode(itemArray)
            // производим запись данных в файл типа списка свойств (.plist)
            try data.write(to: dataFilePath!)
        } catch {
            print(error.localizedDescription)
        }
        // .reloadData - Перезагружает строки и разделы табличного представления.
        self.tableView.reloadData()
    }
    
    func loadItems() {
        // получаем данные из файла Items.plist
        if let data = try? Data(contentsOf: dataFilePath!) {
            // создаем декодер, декодирующий данные из списка свойств (.plist)
            let decoder = PropertyListDecoder()
            do {
                // производим декодирование и сохраняем данные в массив типа: [Item]
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
