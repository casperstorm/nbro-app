//
// Created by Casper Storm Larsen on 08/02/16.
// Copyright (c) 2016 Bob. All rights reserved.
//

import Foundation
import CoreLocation
import AFDateHelper

struct Event {
    
    enum DateFormat {
        case date(includeYear: Bool)
        case time
        indirect case relative(fallback: DateFormat)
        
        fileprivate static var dateformatters = [String:DateFormatter]()
        
        func formattedStringFromDate(_ date: Foundation.Date) -> String {
            switch self {
            case .date(_):
                return dateString(date, dateFormat: self)
            case .time:
                return dateString(date, dateFormat: self)
            case .relative(let fallback):
                if(date.isTomorrow()) {
                    return "Tomorrow"
                } else if(date.isToday()) {
                    return "Today"
                } else {
                    return dateString(date, dateFormat: fallback)
                }
            }
        }
        
        fileprivate func dateString(_ date: Foundation.Date, dateFormat: DateFormat) -> String {
            let format = formatFromDateFormat(dateFormat)
            let dateFormatter = self.dateFormatter(format)
            return dateFormatter.string(from: date)
        }
        
        fileprivate func formatFromDateFormat(_ format: DateFormat) -> String {
            switch format {
            case .date(let includeYear):
                return "dd. MMM" + (includeYear ? " yyyy" : "")
            case .time:
                return "HH:mm"
            default:
                return ""
            }
        }
        
        fileprivate func dateFormatter(_ format: String) -> DateFormatter {
            if let dateFormatter = DateFormat.dateformatters[format] {
                return dateFormatter
            } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = format
                DateFormat.dateformatters[format] = dateFormatter
                return dateFormatter
            }
            
        }
    }
    
    enum RSVPStatus {
        case attending
        case unsure
        case unknown
    }
    
    let id: String
    let name: String
    let startDate: Date
    let latitude: CLLocationDegrees?
    let longitude: CLLocationDegrees?
    let locationName: String
    let description: String
    let rsvp: RSVPStatus?
    let eventTimes: Array<NSDictionary>?
    
    init?(_ event: Event, dictionary: NSDictionary) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
       let startDateString = dictionary["start_time"] as? String ?? ""
        
        guard let id = dictionary["id"] as? String,
            let startDate = dateFormatter.date(from: startDateString) else {
            return nil
        }
        
        self.id = id
        self.name = event.name
        self.startDate = startDate
        self.latitude = event.latitude
        self.longitude = event.longitude
        self.locationName = event.locationName
        self.description = event.description
        self.rsvp = event.rsvp
        self.eventTimes = nil
    }
    
    init?(dictionary: NSDictionary) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
        let startDateString = dictionary["start_time"] as? String ?? ""
        
        guard let name = dictionary["name"] as? String,
            let startDate = dateFormatter.date(from: startDateString),
            let eventTimes = dictionary["event_times"] as? Array<NSDictionary>,
            let latitude = dictionary.value(forKeyPath: "place.location.latitude") as? CLLocationDegrees,
            let longitude = dictionary.value(forKeyPath: "place.location.longitude") as? CLLocationDegrees,
            let description = dictionary["description"] as? String,
            let id = dictionary["id"] as? String else {
                return nil
        }
        
        self.id = id
        self.name = name
        self.startDate = startDate
        self.latitude = latitude
        self.longitude = longitude
        self.locationName = dictionary.value(forKeyPath: "place.name") as? String ?? "-"
        self.description = description
        self.eventTimes = eventTimes
        
        if let rsvp = dictionary["rsvp_status"] as? String {
            if(rsvp == "attending") {
                self.rsvp = .attending
            } else if (rsvp == "unsure") {
                self.rsvp = .unsure
            } else {
                self.rsvp = .unknown
            }
        } else {
            self.rsvp = .unknown
        }
    }
    
    func formattedStartDate(_ dateFormat: DateFormat) -> String {
        return dateFormat.formattedStringFromDate(self.startDate)
    }
}

extension Event: Equatable {}

func ==(lhs: Event, rhs: Event) -> Bool {
    return lhs.id == rhs.id
}
