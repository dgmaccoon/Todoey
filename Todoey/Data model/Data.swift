//
//  Data.swift
//  Todoey
//
//  Created by Donal on 7/26/19.
//  Copyright © 2019 Donal MacCoon. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
}
