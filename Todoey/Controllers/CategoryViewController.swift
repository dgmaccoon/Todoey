//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Donal on 7/19/19.
//  Copyright © 2019 Donal MacCoon. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>? // Results are from realm

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        loadCategories()
        
        tableView.separatorStyle = .none
        
    }
    
    //MARK: - Tableview Data Source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1 // nil coalescing operator
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath) // gets Cell from superclass SwipeTableViewController
    
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
        
        var cellColor = categories?[indexPath.row].cellColor
        
        if cellColor == "" {
            cell.backgroundColor = UIColor.randomFlat // randomFlat is from ChameleonFramework
            cellColor = cell.backgroundColor?.hexValue()
            do {
                try realm.write {
                    categories?[indexPath.row].cellColor = cellColor!
                }
            } catch {
                print("Error setting item done status \(error)")
            }
        } else {
            cell.backgroundColor = UIColor.init(hexString: cellColor!)
        }
        
        
        return cell
        
    }
    
    //MARK: - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
    @IBAction func addCategoryButtonPressed(_ sender: UIBarButtonItem) {
        
        var textHolder = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textHolder.text!
            
            self.saveCategories(category: newCategory)
            
        }
        
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Add a new category"
            textHolder = alertTextfield
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        tableView.reloadData()
        
    }
    
    func saveCategories(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print ("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
        
    }
    
    
    func loadCategories() {
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
        
    }
    
    //MARK: - Delete data from swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category item \(error)")
            }
        }
    }
    
}
