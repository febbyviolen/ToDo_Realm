//
//  Realm.swift
//  ToDo_Realm
//
//  Created by Ebbyy on 10/31/23.
//

import Foundation
import RealmSwift

class RealmClass {
    static let Shared = RealmClass()
    let realm = try! Realm()
    
    func saveCategory(newCategory: Category) {
        do {
            try realm.write {
                realm.add(newCategory)
            }
        } catch {
            print("Error writting \(error)")
        }
    }
    
    func loadCategory() -> Results<Category> {
        return realm.objects(Category.self)
    }
    
    func deleteCategory(category: Category) {
        do {
            try realm.write {
                realm.delete(category)
            }
        } catch {
            print("error deleting")
        }
    }
    
    func saveToDo(newToDo: ToDo, category: Category) {
        do {
            try realm.write {
                category.items.append(newToDo)
            }
        } catch {
            print("Error writting \(error)")
        }
    }
    
    func loadToDo(category: Category) -> Results<ToDo> {
        return category.items.sorted(byKeyPath: "name", ascending: true)
    }
    
    func deleteToDo(toDo: ToDo) {
        do {
            try realm.write {
                realm.delete(toDo)
            }
        } catch {
            print("error deleting")
        }
    }
    
}
