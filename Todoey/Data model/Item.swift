//
//  Item.swift
//  Todoey
//
//  Created by Donal on 7/26/19.
//  Copyright © 2019 Donal MacCoon. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    
    let parentCategory = LinkingObjects(fromType: Category .self, property: "items")
    
}
