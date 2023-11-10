//
//  ViewController.swift
//  TodoList
//
//  Created by Nguyen Van Son on 08/11/2023.
//

import UIKit

class TodoListViewController: UITableViewController {
    var itemArray = [TodoItem]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        .first?.appendingPathComponent("Item.plist")
    override func viewDidLoad() {
        super.viewDidLoad()
        readData()
        // Do any additional setup after loading the view.
    }
    
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
        tableView.deselectRow(at: indexPath, animated: true)
        saveItems()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add a todo item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default){ (action) in
            let newItem = TodoItem()
            newItem.title = textField.text!
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
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.dataFilePath!)
        } catch {
            print("Error encoding item array")
        }
        self.tableView.reloadData()
    }
    func readData (){
        
        do {
            let data = try Data(contentsOf: dataFilePath!)
            let decoder = PropertyListDecoder()
            itemArray = try decoder.decode([TodoItem].self, from: data)
        } catch  {
            print("read file error \(error)")
        }
    }
}

