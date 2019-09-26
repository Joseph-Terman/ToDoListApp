//
//  Item.swift
//  Todo List
//
//  Created by Joe on 4/23/19.
//  Copyright © 2019 Joe. All rights reserved.
//

import Foundation
import RealmSwift

//subclassing realm object
class Item : Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated: Date?
    
    //Inverse releationship: each item has a parent category of type Category from property items
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
