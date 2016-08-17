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
    let imageURL: NSURL
    
    init?(dictionary: NSDictionary) {
        guard let name = dictionary["name"] as? String,
            id = dictionary["id"] as? String,
            photo = dictionary["picture"] as? NSDictionary,
            photoData = photo["data"] as? NSDictionary,
            photoString = photoData["url"] as? String else {
                return nil
        }
                
        self.imageURL = NSURL(string: photoString)!
        self.id = id
        self.name = name
    }
}
