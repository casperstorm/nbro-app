//
// Created by Casper Storm Larsen on 08/02/16.
// Copyright (c) 2016 Bob. All rights reserved.
//

import Foundation
import CoreLocation
import AFDateHelper

struct Event {
    
    enum DateFormat {
        case Date(includeYear: Bool)
        case Time
        case Relative
        
        private static var dateformatters = [String:NSDateFormatter]()
        
        func formattedStringFromDate(date: NSDate) -> String {
            switch self {
            case Date(_):
                let format = formatFromDateFormat(self)
                let dateFormatter = self.dateFormatter(format)
                return dateFormatter.stringFromDate(date)
            case Time:
                let format = formatFromDateFormat(self)
                let dateFormatter = self.dateFormatter(format)
                return dateFormatter.stringFromDate(date)
            case Relative:
                if(date.isTomorrow()) {
                    return "Tomorrow"
                } else if(date.isToday()) {
                    return "Today"
                } else {
                    let format = formatFromDateFormat(.Date(includeYear: true))
                    let dateFormatter = self.dateFormatter(format)
                    return dateFormatter.stringFromDate(date)
                }
            }
        }
        
        private func formatFromDateFormat(format: DateFormat) -> String {
            switch format {
            case Date(let includeYear):
                return "dd. MMM" + (includeYear ? " yyyy" : "")
            case Time:
                return "HH:mm"
            default:
                return ""
            }
        }
        
        private func dateFormatter(format: String) -> NSDateFormatter {
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
        return dateFormat.formattedStringFromDate(self.startDate)
    }
}
