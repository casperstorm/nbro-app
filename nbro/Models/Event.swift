//
// Created by Casper Storm Larsen on 08/02/16.
// Copyright (c) 2016 Bob. All rights reserved.
//

import Foundation
import CoreLocation

struct Event {
    let name: String
    let startDate: NSDate
    let latitude: CLLocationDegrees?
    let longitude: CLLocationDegrees?
    let locationName: String
    
    init?(dictionary: NSDictionary) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
        let startDateString = dictionary["start_time"] as? String ?? ""
        
        guard let name = dictionary["name"] as? String,
            startDate = dateFormatter.dateFromString(startDateString),
            latitude = dictionary["place"]?["location"]??["latitude"] as? CLLocationDegrees,
            longitude = dictionary["place"]?["location"]??["longitude"] as? CLLocationDegrees else {
                return nil
        }
        
        self.name = name
        self.startDate = startDate
        self.latitude = latitude
        self.longitude = longitude
        self.locationName = dictionary["place"]?["name"] as? String ?? "-"
    }
    
    func formattedStartTime() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd. MMM"
        
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        
        let dateString = dateFormatter.stringFromDate(self.startDate)
        let timeString = timeFormatter.stringFromDate(self.startDate)
        let combinedString = dateString + " at " + timeString
        return combinedString.uppercaseString
    }
}
