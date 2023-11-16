//
//  Category.swift
//  TodoList
//
//  Created by Nguyen Van Son on 15/11/2023.
//

import Foundation
import RealmSwift
class Category: Object{
    @objc dynamic var name: String = ""
    let items = List<TodoItem>()
}

