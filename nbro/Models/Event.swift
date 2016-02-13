//
// Created by Casper Storm Larsen on 08/02/16.
// Copyright (c) 2016 Bob. All rights reserved.
//

import Foundation

struct Event {
    let name: String
    let startDate: NSDate
    
    init?(dictionary: NSDictionary) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
        guard let name = dictionary["name"] as? String,
            startDateString = dictionary["start_time"] as? String,
            startDate = dateFormatter.dateFromString(startDateString) else {
                return nil
        }
        
        self.name = name
        self.startDate = startDate
    }
    
}
