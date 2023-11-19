//
//  ViewController.swift
//  TodoList
//
//  Created by Nguyen Van Son on 08/11/2023.
//

import UIKit
import RealmSwift
import ChameleonFramework
class TodoListViewController: SwipeTableViewController {
    let realm = try! Realm()
    var selectedCategory: Category? {
        didSet {
            loadData()
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    var todoItems: Results<TodoItem>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let colourHex = selectedCategory?.colour {
            title = selectedCategory?.name
            guard let navBar = navigationController?.navigationBar else {
                fatalError("Navigation controller does not exists")
            }
            if let navBarColour = UIColor(hexString: colourHex) {
                navBar.backgroundColor = navBarColour
                searchBar.barTintColor = navBarColour
                searchBar.searchTextField.backgroundColor = FlatWhite()
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(navBarColour, returnFlat: true)]
            }
           
        }
        
    }
//MARK: -Table view data source method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            if let colour = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(todoItems!.count)) {
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
            cell.accessoryType = item.done == true ? .checkmark : .none
            
        }else {
            cell.textLabel?.text = "No item"
        }
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write({
                    item.done = !item.done
                })
            } catch  {
                print("Error saving done status \(error)")
            }
        }
        self.tableView.reloadData()
    }
//MARK: - add item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add a todo item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default){ (action) in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                         let newItem = TodoItem()
                         newItem.title = textField.text!
                        newItem.createdDate = Date()
                         currentCategory.items.append(newItem)
                     }
                } catch {
                    print("Error saving new items \(error)")
                }
            }
            self.tableView.reloadData()
        }
        alert.addTextField {
            (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    //gia tri mac dinh neu khong co tham so request la TodoItem.fetchRequest()
    func loadData (){
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    override func updateModel(at indexPath: IndexPath) {
        if let todoItemForDeletion =  self.todoItems?[indexPath.row] {
            do {
                try self.realm.write({
                    self.realm.delete(todoItemForDeletion)
                })
            } catch  {
                print("error delete todo items\(error)")
            }
        }
    }
}

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath:"createdDate", ascending: true)
        tableView.reloadData()
        
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
