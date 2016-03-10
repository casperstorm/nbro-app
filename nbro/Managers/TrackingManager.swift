//
//  TrackingManager.swift
//  nbro
//
//  Created by Casper Storm Larsen on 25/02/16.
//  Copyright © 2016 Bob. All rights reserved.
//

import Foundation
import UIKit
import Crashlytics

class TrackingManager {
    enum TrackingEvent {
        case AttendEvent
        case SkippedLogin
        case Logout
        
        case VisitEventInFacebook
        case VisitAppStore
        case VisitInstagram
        case VisitFacebook
        
        case ViewEventList
        case ViewEventDetail
        case ViewAbout
        case ViewCredits
        case ViewLogin
    }
    
    class func trackUser() {
        FacebookManager.user({ (user) in
            Crashlytics.sharedInstance().setUserIdentifier(user.id)
            Crashlytics.sharedInstance().setUserName(user.name)
        })
    }
    
    class func trackEvent(event: TrackingEvent) {
        switch event {
        case .AttendEvent:
            FBSDKAppEvents.logEvent("AttendedEvent")
        case .VisitEventInFacebook:
            FBSDKAppEvents.logEvent("VisitEventInFacebook")
        case .VisitAppStore:
            FBSDKAppEvents.logEvent("VisitAppStore")
        case .VisitInstagram:
            FBSDKAppEvents.logEvent("VisitInstagram")
        case .VisitFacebook:
            FBSDKAppEvents.logEvent("VisitFacebook")
        case .ViewEventList:
            FBSDKAppEvents.logEvent("ViewEventList")
        case .ViewEventDetail:
            FBSDKAppEvents.logEvent("ViewEventDetail")
        case .ViewAbout:
            FBSDKAppEvents.logEvent("ViewAbout")
        case .ViewCredits:
            FBSDKAppEvents.logEvent("ViewCredits")
        case .ViewLogin:
            FBSDKAppEvents.logEvent("ViewLogin")
        case .SkippedLogin:
            FBSDKAppEvents.logEvent("SkippedLogin")
        case .Logout:
            FBSDKAppEvents.logEvent("Logout")
        }
        
    }
}