//
//  CategoryViewController.swift
//  Todo List
//
//  Created by Joe on 4/23/19.
//  Copyright © 2019 Joe. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    //variable for checking if randomInt is repeating
    var entropy = 0
    
    let realm = try! Realm()
    var categories: Results<Category>?
    let otherCategories = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
        tableView.separatorStyle = .none
    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Nil Coalescing Operator
        //if categories is not nill, return count, but if it is nil, then return 1
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row]{
            let color = UIColor(hexString: category.color)//.darken(byPercentage: CGFloat(0.05))
            cell.textLabel?.text = category.name ?? "No Categories Yet"
            cell.backgroundColor = color
            //cell.backgroundColor = UIColor(hexString: category.color ?? "1D9BF6")
            cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
        }
//        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
//        cell.backgroundColor = UIColor(hexString: categories?[indexPath.row].color)
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //MARK: - Data Manuipulation Methods
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category context \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadCategory() {
        categories = realm.objects(Category.self)
    }
    
    //MARK: - Delete Data from swipe
    //override the updatemodel method
    override func updateModel(at indexPath: IndexPath) {
        //optional binding
        if let deletedCategory = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(deletedCategory)
                }
            } catch {
                print("Error deleting category \(error)")
            }
            //self.tableView.reloadData()
        }
    }
    
    //MARK: - Add new Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
       
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add New Category", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            
            //color array for scheme
            var colorArray = ColorSchemeOf(ColorScheme.analogous , color: FlatSkyBlue(), isFlatScheme: true)
            let randomInt = Int.random(in: 0...(colorArray.count - 1))
            
            //saving randomInt value to be entropy value
            if self.entropy != randomInt{
                self.entropy = randomInt
            } else {
                colorArray.remove(at: randomInt)
            }
            newCategory.color = colorArray[randomInt].hexValue()
            self.save(category: newCategory)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    
    
}

