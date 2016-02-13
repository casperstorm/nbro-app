//
// Created by Casper Storm Larsen on 08/02/16.
// Copyright (c) 2016 Bob. All rights reserved.
//

import Foundation
import CoreLocation

struct Event {
    
    enum DateFormat {
        case Date(includeYear: Bool)
        case Time
        
        private static var dateformatters = [String:NSDateFormatter]()
        
        private func dateFormat() -> String {
            switch self {
            case Date(let includeYear):
                return "dd. MMM" + (includeYear ? " yyyy" : "")
            case Time:
                return "HH:mm"
            }
        }
        
        func dateFormatter() -> NSDateFormatter {
            let format = dateFormat()
            
            if let dateFormatter = DateFormat.dateformatters[format] {
                return dateFormatter
            } else {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = format
                DateFormat.dateformatters[format] = dateFormatter
                return dateFormatter
            }
            
        }
    }
    
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
    
    func formattedStartDate(dateFormat: DateFormat) -> String {
        let dateFormatter = dateFormat.dateFormatter()
        return dateFormatter.stringFromDate(startDate)
    }
}
