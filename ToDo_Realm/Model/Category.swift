//
//  Category.swift
//  ToDo_Realm
//
//  Created by Ebbyy on 10/31/23.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    
    let items = List<ToDo>()
}
