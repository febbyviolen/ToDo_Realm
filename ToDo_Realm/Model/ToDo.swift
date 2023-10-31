//
//  Model.swift
//  ToDo_Realm
//
//  Created by Ebbyy on 10/31/23.
//

import Foundation
import RealmSwift

class ToDo: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var done: Bool = false
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
