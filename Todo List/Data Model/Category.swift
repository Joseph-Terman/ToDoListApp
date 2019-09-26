//
//  Category.swift
//  Todo List
//
//  Created by Joe on 4/23/19.
//  Copyright © 2019 Joe. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    //dynamic var monitors for changes during runtime
    @objc dynamic var name : String = ""
    @objc dynamic var color : String = ""
    
    //Forward Relationship: Inside each Category, items points to a list of Items
    let items = List<Item>()
}
