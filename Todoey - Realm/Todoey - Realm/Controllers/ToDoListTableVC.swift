//
//  ToDoListTableVC.swift
//  Todoey - Realm
//
//  Created by Artem Solovev on 06.08.2022.
//

import UIKit
// фреймворк для работы с Realm
import RealmSwift

class ToDoListTableVC: UITableViewController {

    // Results — это автоматически обновляемый тип контейнера в Realm, возвращаемый из объектных запросов. Результаты можно запрашивать с помощью тех же предикатов, что и List<Element>, и вы можете связывать запросы для дальнейшей фильтрации результатов запроса.
    // Создаем экземпляр объекта модели Realm, что бы загрузить в него данные из БД Realm, а именно все экземпляры типа Item. Данные в categories обновляются автоматически, так как свойства в Item, помечены @objc dynamic
    var todoItems: Results<Item>?
    // создаем объект Realm для доступа к БД Realm
    let realm = try! Realm()
    // переменная хранящая текущую категорию и загружающая данные при установлении значения категории
    var selectedCategory: Category? {
        // didSet срабатывает когда новое значение уже установлено
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // печать расположения рабочей папки текущиего приложения
        // print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    //MARK: Tableview Datasource Methods
    
    // задаем количество строк в UITableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    // задаем ячейку для UITableView
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // .dequeueReusableCell - возвращает многократно используемую ячейку UITableView по указанному идентификатору
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            // устанавливаем голочку или нет у ячейки таблицы (условный тернарныый оператор a?b:c)
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items added"
        }
        return cell
    }
    
    //MARK: Tableview Delegate Methods
    
    // вызывается при нажатии на ячейку таблицы
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                // .write - Выполняет действия, содержащиеся в данном блоке внутри транзакции записи. Для каждого файла Realm одновременно может быть открыта только одна транзакция записи. Транзакции записи не могут быть вложенными. Вызовы записи из экземпляров Realm для того же файла Realm в других потоках или других процессах будут блокироваться до тех пор, пока текущая транзакция записи не завершится или не будет отменена. Вы можете пропустить уведомление определенных блоков уведомлений об изменениях, внесенных в эту транзакцию записи, передав связанные с ними токены уведомлений. Это в первую очередь полезно, когда транзакция записи сохраняет изменения, уже внесенные в пользовательский интерфейс, и вы не хотите, чтобы блок уведомлений пытался повторно применить те же изменения.
                try realm.write({
                    item.done = !item.done
                    // delete - Удаляет объект из Realm. После удаления объекта он считается недействительным. Этот метод можно вызывать только во время транзакции записи.
                    // realm.delete(item)
                })
            } catch {
                print(error)
            }
        }
        tableView.reloadData()
        // .deselectRow - отменяет выбор строки
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: Add new Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        // создаем UITextField в который мы сохраним введеные данные пользователя в текстовое поле UIAlert
        var textField = UITextField()
        // создаем UIAlertController
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        // создаем действие для UIAlertController
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //
            if let currentCategory = self.selectedCategory {
                do {
                    // .write - Выполняет действия, содержащиеся в данном блоке внутри транзакции записи. Для каждого файла Realm одновременно может быть открыта только одна транзакция записи. Транзакции записи не могут быть вложенными. Вызовы записи из экземпляров Realm для того же файла Realm в других потоках или других процессах будут блокироваться до тех пор, пока текущая транзакция записи не завершится или не будет отменена. Вы можете пропустить уведомление определенных блоков уведомлений об изменениях, внесенных в эту транзакцию записи, передав связанные с ними токены уведомлений. Это в первую очередь полезно, когда транзакция записи сохраняет изменения, уже внесенные в пользовательский интерфейс, и вы не хотите, чтобы блок уведомлений пытался повторно применить те же изменения.
                    try self.realm.write({
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    })
                } catch {
                    print(error)
                }
            }
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
    
    // загружаем данные из БД используя при необходимости дополнительный запрос уже со встроенной сортировкой и правилами фильтрации
    func loadItems() {
        // sorted - Возвращает результаты, содержащие объекты в коллекции, но отсортированные. Объекты сортируются на основе значений заданного ключевого пути. ascending - по возрастанию
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
}

//MARK: - UISearchBarDelegate

extension ToDoListTableVC: UISearchBarDelegate {

    // searchBarSearchButtonClicked - Сообщает делегату, что кнопка поиска была нажата.
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // filter - Возвращает результаты, содержащие все объекты, отфильтрованные по заданному предикату
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }

    // textDidChange - Сообщает делегату, что пользователь изменил текст поиска.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                // Уведомляет этот объект о том, что ему было предложено отказаться от своего статуса первого ответчика в своем окне.
                // Убирает клавиатуру когда пустой searchBar
                searchBar.resignFirstResponder()
            }
        }
    }
}
