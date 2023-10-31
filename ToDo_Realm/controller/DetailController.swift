//
//  DetailController.swift
//  ToDo_CoreData
//
//  Created by Ebbyy on 10/30/23.
//
//
import UIKit
import RealmSwift

class DetailController: SwipeTableViewController, UISearchBarDelegate {

    @IBOutlet weak var searhBar: UISearchBar!
    
    var lists: Results<ToDo>!
    var category: Category? {
        didSet {
            lists = RealmClass.Shared.loadToDo(category: category!)
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        searhBar.delegate = self
    }
    
    @objc
    private func resignKeyboard(){
        searhBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        lists = lists.filter("name CONTAINS[cd] %@", searchText).sorted(byKeyPath: "name", ascending: true)
        tableView.reloadData()
        
        if searchText == "" {
            lists = RealmClass.Shared.loadToDo(category: category!)
            tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        lists = lists.filter("name CONTAINS[cd] %@", searchBar.text ?? "" ).sorted(byKeyPath: "name", ascending: true)
        tableView.reloadData()
        
        if searchBar.text! == "" {
            lists = RealmClass.Shared.loadToDo(category: category!)
            tableView.reloadData()
            
            searhBar.resignFirstResponder()
        }
    }
    
    //data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = lists[indexPath.row].name
        if lists[indexPath.row].done {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        do{
            try RealmClass.Shared.realm.write {
                lists[indexPath.row].done = !lists[indexPath.row].done
            }
        } catch {
            print("not working")
        }
        
        tableView.reloadData()
    }
    
    //delegate
    
    @IBAction func addToDO(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "add todo", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        let saveButton = UIAlertAction(title: "Add", style: .default) { UIAlertAction in
            if let todo = textField.text, !todo.isEmpty {
                let item = ToDo()
                item.name = todo
                RealmClass.Shared.saveToDo(newToDo: item, category: self.category!)
                
                self.tableView.reloadData()
            }
        }
        
        alert.addAction(saveButton)
        
        present(alert, animated: true)
    }
    
    override func deleteModel(at indexPath: IndexPath) {
        RealmClass.Shared.deleteToDo(toDo: lists[indexPath.row])
        tableView.reloadData()
    }
    
}
