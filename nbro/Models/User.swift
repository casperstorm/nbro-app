//
//  User.swift
//  nbro
//
//  Created by Casper Storm Larsen on 25/02/16.
//  Copyright © 2016 Bob. All rights reserved.
//

import Foundation

struct User {
    let id: String
    let name: String
    
    init?(dictionary: NSDictionary) {
        guard let name = dictionary["name"] as? String,
            id = dictionary["id"] as? String else {
                return nil
        }
        
        self.id = id
        self.name = name
    }
}
