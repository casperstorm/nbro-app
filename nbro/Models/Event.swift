//
// Created by Casper Storm Larsen on 08/02/16.
// Copyright (c) 2016 Bob. All rights reserved.
//

import Foundation

class Event {
    var name: String?
    var startDate: NSDate?
    
    convenience init(_ dictionary: Dictionary<String, AnyObject>) {
        self.init()
        self.name = dictionary["name"] as? String
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
        let dateTime = dictionary["start_time"] as? String
        self.startDate = dateFormatter.dateFromString(dateTime!)
    }
    
}
