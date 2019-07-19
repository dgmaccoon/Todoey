//
//  Item.swift
//  Todoey
//
//  Created by Donal on 7/18/19.
//  Copyright © 2019 Donal MacCoon. All rights reserved.
//

import Foundation

class Item: Codable {
    // Codable means conforms to Encodable (means that it can be encoded into a plist, etc. but then this class needs normal variable types) and decodable
    // Encoding: turning music into vinyl disk
    // Decoder: plays record and turns it into music
    var title : String = ""
    var done : Bool = false
}
