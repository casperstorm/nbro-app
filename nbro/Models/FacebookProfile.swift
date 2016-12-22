//
//  User.swift
//  nbro
//
//  Created by Casper Storm Larsen on 25/02/16.
//  Copyright © 2016 Bob. All rights reserved.
//

import Foundation

struct FacebookProfile {
    let id: String
    let name: String
    let imageURL: URL
    
    init?(dictionary: NSDictionary) {
        guard let name = dictionary["name"] as? String,
            let id = dictionary["id"] as? String,
            let photo = dictionary["picture"] as? NSDictionary,
            let photoData = photo["data"] as? NSDictionary,
            let photoString = photoData["url"] as? String else {
                return nil
        }
                
        self.imageURL = URL(string: photoString)!
        self.id = id
        self.name = name
    }
}
