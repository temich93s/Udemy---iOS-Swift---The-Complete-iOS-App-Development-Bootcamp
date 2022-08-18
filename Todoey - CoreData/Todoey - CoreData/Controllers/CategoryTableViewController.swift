//
//  CategoryTableViewController.swift
//  Todoey - CoreData
//
//  Created by Artem Solovev on 05.08.2022.
//
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {

    var categories = [Category]()
    
    // UIApplication - Централизованная точка контроля и координации для приложений, работающих в iOS. Каждое приложение для iOS имеет ровно один экземпляр UIApplication (или, очень редко, подкласс UIApplication). Когда приложение запускается, система вызывает функцию UIApplicationMain(). Помимо других задач, эта функция создает одноэлементный объект UIApplication, к которому вы обращаетесь с помощью shared.
    // .shared - синглтон нашего экземпляра приложения
    // .delegate - Каждое приложение должно иметь объект делегата приложения для ответа на сообщения, связанные с приложением. Например, приложение уведомляет своего делегата, когда приложение завершает запуск и когда его статус выполнения переднего плана или фона изменяется. Это и есть экземпляр AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        // создаем UITextField в который мы сохраним введеные данные пользователя в текстовое поле UIAlert
        var textField = UITextField()
        // создаем UIAlertController
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        // создаем действие для UIAlertController
        let action = UIAlertAction(title: "Add", style: .default) { (acton) in
            let  newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categories.append(newCategory)
            // сохраняем новую категорию в categories, добавляя его в БД
            self.saveCategory()
        }
        // добавляем экшн кнопки
        alert.addAction(action)
        // добавляем TextField нашему алерту и сохраняем введенные данные пользователем в заранее созданный UITextField
        alert.addTextField { (field) in
            field.placeholder = "Add new Category"
            textField = field
        }
        // отображаем на экране наш UIAlertController
        present(alert, animated: true)
    }
    
    //MARK: - TableView DataSource Methods
    
    // задаем количество строк в UITableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    // задаем ячейку для UITableView
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // .dequeueReusableCell - возвращает многократно используемую ячейку UITableView по указанному идентификатору
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    // didSelectRowAt - вызывается при нажатии на ячейку таблицы
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // осуществляем переход на ToDoListTableVC
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    // prepare - Уведомляет VC о предстоящем переходе.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // .destination - VC на который осуществляется переход (в данном случае это ToDoListTableViewController)
        let destinationVC = segue.destination as! ToDoListTableViewController
        // .indexPathForSelectedRow  - индекс, определяющий строку и раздел выбранной строки.
        if let indexPath = tableView.indexPathForSelectedRow {
            // устанавливаем категорию ToDoListTableViewController
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
    
    // сохраняем данные в БД
    func saveCategory() {
        do {
            // .save - Попытка зафиксировать несохраненные изменения в зарегистрированных объектах в родительском хранилище контекста.
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        tableView.reloadData()
    }
    
    // загружаем данные из БД
    func loadCategories() {
        // NSFetchRequest - Описание критериев поиска, используемых для извлечения данных из постоянного хранилища и указываем тип данных которые будем запрашивать
        // Item.fetchRequest() - это сам запрос на выборку.
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do {
            // .fetch - Возвращает массив элементов указанного типа, которые соответствуют критериям запроса на выборку.
            categories = try context.fetch(request)
        } catch {
            print(error.localizedDescription)
        }
    }
}
