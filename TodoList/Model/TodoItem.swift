//
//  TodoItem.swift
//  TodoList
//
//  Created by Nguyen Van Son on 15/11/2023.
//

import Foundation
import RealmSwift
class TodoItem: Object{
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var createdDate: Date?
    let parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
