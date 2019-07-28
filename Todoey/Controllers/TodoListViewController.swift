//
//  ViewController.swift
//  Todoey
//
//  Created by Donal on 7/15/19.
//  Copyright © 2019 Donal MacCoon. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: SwipeTableViewController {
    
    var todoItems: Results<Item>?
    
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    // MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath) // gets Cell from superclass SwipeTableViewController
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
            
        } else {
            cell.textLabel?.text = "No Items Added Yet"
        }
    
        return cell
        
    }
    
    // MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error setting item done status \(error)")
            }
        
        tableView.deselectRow(at: indexPath, animated: true)
            
//        tableView.reloadData()
        
        }
    }
    
    // MARK - Add New Todo Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {

        var textHolder = UITextField()

        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textHolder.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print ("Error saving new items \(error)")
                }
               
            }
            
            self.tableView.reloadData()

        }

        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Create new item"
            textHolder = alertTextfield
        }

        alert.addAction(action)

        present(alert, animated: true, completion: nil)

    }
    
    //MARK - Model Manipulation Methods
    func loadItems() {

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()

    }
    
    //MARK: - Delete Swipe Method
    override func updateModel(at indexPath: IndexPath) {
        
        if let itemForDeletion = self.todoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
                }
            } catch {
                print("Error deleting todo item \(error)")
            }
            
//            tableView.reloadData()
            
        }
    }


} // End class TodoListViewController

//MARK: - Search bar methods
extension TodoListViewController : UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchBar.text?.count == 0 {
            loadItems()

            // We update UI elements on the main thread so user will see the changes
            DispatchQueue.main.async {
                searchBar.resignFirstResponder() // searchbar should no longer be selected
            }

        }
    }

} // End of extension TodoListViewController

