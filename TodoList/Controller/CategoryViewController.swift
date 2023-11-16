//
//  CategoryViewController.swift
//  TodoList
//
//  Created by Nguyen Van Son on 13/11/2023.
//

import UIKit
import RealmSwift
class CategoryViewController: SwipeTableViewController {
    
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let realm = try! Realm()
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
       
    }
    
    //MARK: - TableView Datasoure Method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let category = categories?[indexPath.row]
        cell.textLabel?.text = category?.name ?? "No category"
        return cell
    }
    //MARK: - TableView Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    //MARK: - TableView manipulation methods
    func save(category: Category){
        do {
//           try context.save()
            try realm.write({
                realm.add(category)
            })
        } catch {
            print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    func loadData (){
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    override func updateModel(at indexPath: IndexPath) {
        if let categorieForDeletion =  self.categories?[indexPath.row] {
            do {
                try self.realm.write({
                    self.realm.delete(categorieForDeletion)
                })
            } catch  {
                print("error delete category\(error)")
            }
        }
    }
    
    // MARK: - Add new categories
    @IBAction func addCategoryPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Category Name", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default){(action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            self.save(category: newCategory)
        }
        alert.addTextField {
            (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}

