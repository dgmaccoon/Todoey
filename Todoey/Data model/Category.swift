//
//  Category.swift
//  Todoey
//
//  Created by Donal on 7/26/19.
//  Copyright © 2019 Donal MacCoon. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name: String = ""
    let items = List<Item>() // Defines forward relationship between Category and Items
}
