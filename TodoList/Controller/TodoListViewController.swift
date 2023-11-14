//
//  ViewController.swift
//  TodoList
//
//  Created by Nguyen Van Son on 08/11/2023.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var itemArray = [TodoItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
//MARK -Table view data source method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done == true ? .checkmark : .none
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
//        itemArray[indexPath.row].setValue("o kia ", forKey: "title")
        tableView.deselectRow(at: indexPath, animated: true)
        saveItems()
    }
//MARK - add item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add a todo item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default){ (action) in
//            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//                return
//            }
//            let context = appDelegate.persistentContainer.viewContext
          
            
            let newItem = TodoItem(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            self.itemArray.append(newItem)
            self.saveItems()
           
        }
        alert.addTextField {
            (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    func saveItems (){
        do {
           try context.save()
//            let data = try encoder.encode(self.itemArray)
//            try data.write(to: self.dataFilePath!)
        } catch {
            print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    //gia tri mac dinh neu khong co tham so request la TodoItem.fetchRequest()
    func loadData (with request: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()){
        do {
            itemArray = try context.fetch(request)
        } catch  {
            print("read file error \(error)")
        }
        tableView.reloadData()
    }
    
}

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        request.predicate = NSPredicate(format:"title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadData(with: request)
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
