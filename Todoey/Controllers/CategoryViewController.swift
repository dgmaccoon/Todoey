//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Donal on 7/19/19.
//  Copyright © 2019 Donal MacCoon. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categories = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }
    
    //MARK: - Tableview Data Source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row].name
        
        return cell
        
    }
    
    //MARK: - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // print("didSelectRowAt \(indexPath)")

        performSegue(withIdentifier: "goToItems", sender: self)
        
        // tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
    @IBAction func addCategoryButtonPressed(_ sender: UIBarButtonItem) {
        
        var textHolder = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            // what will happen once the user clicks the Add Item button on our UIAlert
            
            // in parens is simply tapping the AppDelegate class so we can access persistentContainer
            
            let newCategory = Category(context: self.context)
            newCategory.name = textHolder.text!
            
            self.categories.append(newCategory) // self needed bc inside a closure -- "in" keyword
            
            self.saveCategories()
            
        }
        
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Add a new category"
            textHolder = alertTextfield
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveCategories() {
        
        do {
            try context.save()
        } catch {
            print ("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
        
    }
    
    
    func loadItems(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        // with is variable name to use externally
        // request is variable name used internally
        // Item.fetchRequest() is the default it no variable is passed into the function
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
        
    }
    
}
