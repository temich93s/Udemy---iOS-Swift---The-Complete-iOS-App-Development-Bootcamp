//
//  CategoryTableVC.swift
//  Todoey - Realm
//
//  Created by Artem Solovev on 06.08.2022.
//

import UIKit
// фреймворк для работы с Realm
import RealmSwift

class CategoryTableVC: UITableViewController {

    // создаем объект Realm для доступа к БД Realm
    let realm = try! Realm()
    
    // Results — это автоматически обновляемый тип контейнера в Realm, возвращаемый из объектных запросов. Результаты можно запрашивать с помощью тех же предикатов, что и List<Element>, и вы можете связывать запросы для дальнейшей фильтрации результатов запроса.
    // Создаем экземпляр объекта модели Realm, что бы загрузить в него данные из БД Realm, а именно все экземпляры типа Category. Данные в categories обновляются автоматически, так как свойства в Category, помечены @objc dynamic
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // загружаем данные из БД Realm
        loadCategories()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        // создаем UITextField в который мы сохраним введеные данные пользователя в текстовое поле UIAlert
        var textField = UITextField()
        // создаем UIAlertController
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        // создаем действие для UIAlertController
        let action = UIAlertAction(title: "Add", style: .default) { (acton) in
            let  newCategory = Category()
            newCategory.name = textField.text!
            // сохраняем новую категорию в categories, добавляя его в БД Realm
            self.saveCategory(category: newCategory)
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
        return categories?.count ?? 1
    }
    
    // задаем ячейку для UITableView
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // .dequeueReusableCell - возвращает многократно используемую ячейку UITableView по указанному идентификатору
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"
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
        // .destination - VC на который осуществляется переход (в данном случае это ToDoListTableVC)
        let destinationVC = segue.destination as! ToDoListTableVC
        // .indexPathForSelectedRow  - индекс, определяющий строку и раздел выбранной строки.
        if let indexPath = tableView.indexPathForSelectedRow {
            // устанавливаем категорию ToDoListTableVC
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
    
    func saveCategory(category: Category) {
        do {
            // .write - Выполняет действия, содержащиеся в данном блоке внутри транзакции записи. Для каждого файла Realm одновременно может быть открыта только одна транзакция записи. Транзакции записи не могут быть вложенными. Вызовы записи из экземпляров Realm для того же файла Realm в других потоках или других процессах будут блокироваться до тех пор, пока текущая транзакция записи не завершится или не будет отменена. Вы можете пропустить уведомление определенных блоков уведомлений об изменениях, внесенных в эту транзакцию записи, передав связанные с ними токены уведомлений. Это в первую очередь полезно, когда транзакция записи сохраняет изменения, уже внесенные в пользовательский интерфейс, и вы не хотите, чтобы блок уведомлений пытался повторно применить те же изменения.
            try realm.write() {
                // добавляет объект в Realm. Если объект с таким же первичным ключом уже существует в этой области, он обновляется значениями свойств из этого объекта. Добавление объекта в Realm также добавит все дочерние отношения, на которые ссылается этот объект. Этот метод может быть вызван только во время транзакции записи.
                realm.add(category)
            }
        } catch {
            print(error.localizedDescription)
        }
        tableView.reloadData()
    }
    
    func loadCategories() {
        // .objects - Возвращает все объекты указанного типа, хранящиеся в Realm.
        categories = realm.objects(Category.self)
    }
}
