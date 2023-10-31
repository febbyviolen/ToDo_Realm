//
//  ViewController.swift
//  ToDo_CoreData
//
//  Created by Ebbyy on 10/30/23.
//

import UIKit
import RealmSwift

class CategoryController: SwipeTableViewController {

    var categoryList: Results<Category>?
    var selectedCategory: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        categoryList = RealmClass.Shared.loadCategory()
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailView" {
            if let VC = segue.destination as? DetailController {
                VC.category = selectedCategory!
            }
        }
    }
    
    //datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categoryList?[indexPath.row].name
        return cell
    }
    
    //delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCategory = categoryList?[indexPath.row]
        self.performSegue(withIdentifier: "showDetailView", sender: self)
    }
    
    @IBAction func addCategory(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "add category", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        let saveButton = UIAlertAction(title: "Add", style: .default) { UIAlertAction in
            if let categoryName = textField.text, !categoryName.isEmpty {
                
                let newCategory = Category()
                newCategory.name = categoryName
            
                RealmClass.Shared.saveCategory(newCategory: newCategory)
                self.categoryList = RealmClass.Shared.loadCategory()
                self.tableView.reloadData()
            }
        }
        
        alert.addAction(saveButton)
        
        present(alert, animated: true)
    }
    
    override func deleteModel(at indexPath: IndexPath) {
        RealmClass.Shared.deleteCategory(category: categoryList![indexPath.row])
        tableView.reloadData()
    }
    
}
