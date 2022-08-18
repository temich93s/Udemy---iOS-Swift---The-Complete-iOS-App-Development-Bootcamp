//
//  ToDoListTableViewController.swift
//  Todoey - CoreData
//
//  Created by Artem Solovev on 05.08.2022.
//
//

import UIKit
import CoreData

class ToDoListTableViewController: UITableViewController {

    var itemArray = [Item]()
    
    // UIApplication - Централизованная точка контроля и координации для приложений, работающих в iOS. Каждое приложение для iOS имеет ровно один экземпляр UIApplication (или, очень редко, подкласс UIApplication). Когда приложение запускается, система вызывает функцию UIApplicationMain(). Помимо других задач, эта функция создает одноэлементный объект UIApplication, к которому вы обращаетесь с помощью shared.
    // .shared - синглтон нашего экземпляра приложения
    // .delegate - Каждое приложение должно иметь объект делегата приложения для ответа на сообщения, связанные с приложением. Например, приложение уведомляет своего делегата, когда приложение завершает запуск и когда его статус выполнения переднего плана или фона изменяется. Это и есть экземпляр AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadItems()
    }
    
    //MARK: Tableview Datasource Methods
    
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
    
    //MARK: Tableview Delegate Methods
    
    // вызывается при нажатии на ячейку таблицы
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //меняем чек-марку и сохраняем данные в CoreData
        //itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        //saveItems()
        
        // .deselectRow - отменяет выбор строки
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Тут код удаления строки из таблицы и из БД СoreData при нажатии на строку
        // delete - Указывает объект, который должен быть удален из его постоянного хранилища при фиксации изменений.
        context.delete(itemArray[indexPath.row])
        // удаление элемента из массива (массив используется для построения таблицы)
        itemArray.remove(at: indexPath.row)
        saveItems()
    }
    
    //MARK: Add new Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        // создаем UITextField в который мы сохраним введеные данные пользователя в текстовое поле UIAlert
        var textField = UITextField()
        // создаем UIAlertController
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        // создаем действие для UIAlertController
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // создаем новый объект Item, что бы записать в него введеные данные пользователя, объект Item является объектом типа NSManagedObject, поэтому указываем контекст
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            // Добавляем этот newItem в массив itemArray что бы по новое пересоздать tableView
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
    
    //MARK: Save and Load Items
    
    // функция по сохранению контекста и обновления таблицы
    func saveItems() {
        do {
            // .save - Попытка зафиксировать несохраненные изменения в зарегистрированных объектах в родительском хранилище контекста.
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        // .reloadData - Перезагружает строки и разделы табличного представления.
        self.tableView.reloadData()
    }
    
    // загружаем данные из БД используя при необходимости дополнительный запрос уже со встроенной сортировкой и правилами фильтрации
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        // NSPredicate - Определение логических условий для ограничения поиска выборки или фильтрации в памяти.
        // фильтруем данные из БД по имени категории
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        // если была передана дополнительная фильтрация данных из БД, то выполняем и его
        if let addtionalPredicate = predicate {
            // .predicate - Предикат запроса на выборку. Экземпляр предиката ограничивает выбор объектов, которые должен извлечь экземпляр NSFetchRequest. Если предикат пуст — например, если это предикат AND, массив элементов которого не содержит предикатов, — предикат запроса устанавливается равным nil.
            // NSCompoundPredicate - Специализированный предикат, который оценивает логические комбинации других предикатов.
            // andPredicateWithSubpredicates - Возвращает новый предикат, формируемый с помощью операции И над предикатами в указанном массиве.
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, addtionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        do {
            // .fetch - Возвращает массив элементов указанного типа, которые соответствуют критериям запроса на выборку.
            itemArray = try context.fetch(request)
        } catch {
            print(error.localizedDescription)
        }
        tableView.reloadData()
    }
}

//MARK: - UISearchBarDelegate

extension ToDoListTableViewController: UISearchBarDelegate {
    
    // searchBarSearchButtonClicked - Сообщает делегату, что кнопка поиска была нажата.
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // NSFetchRequest - Описание критериев поиска, используемых для извлечения данных из постоянного хранилища и указываем тип данных которые будем запрашивать
        // Item.fetchRequest() - это сам запрос на выборку.
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        // NSPredicate - Определение логических условий для ограничения поиска выборки или фильтрации в памяти.
        // фильтруем данные из БД по тексту из searchBar
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        // .sortDescriptors - Дескрипторы сортировки запроса на выборку. Дескрипторы сортировки определяют, как должны быть упорядочены объекты, возвращаемые при выдаче NSFetchRequest, например, по фамилии, а затем по имени. Дескрипторы сортировки применяются в том порядке, в котором они появляются в массиве sortDescriptors (сериально в порядке с наименьшей точки массива-индекс-первый).
        // NSSortDescriptor - Неизменяемое описание того, как упорядочить набор объектов в соответствии со свойством, общим для всех объектов. ascending - по возрастанию
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        // загружаем данные передав в loadItems запрос для извлечения данных их БД (request) и правила фильтрации данных запрошенных из БД (predicate)
        loadItems(with: request, predicate: predicate)
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
