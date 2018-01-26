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
        case attendEvent
        case skippedLogin
        case logout
        
        case visitEventInFacebook
        case visitAppStore
        case visitInstagram
        case visitFacebook
        
        case viewEventList
        case viewEventDetail
        case viewAbout
        case viewAppIcons
        case viewUser
        case viewCredits
        case viewLogin
        case viewAttendees
    }
    
    class func trackUser() {
        FacebookManager.user({ (user) in
            guard let user = user else { return }
            Crashlytics.sharedInstance().setUserIdentifier(user.id)
            Crashlytics.sharedInstance().setUserName(user.name)
        })
    }
    
    class func trackEvent(_ event: TrackingEvent) {
        switch event {
        case .attendEvent:
            FBSDKAppEvents.logEvent("AttendedEvent")
        case .visitEventInFacebook:
            FBSDKAppEvents.logEvent("VisitEventInFacebook")
        case .visitAppStore:
            FBSDKAppEvents.logEvent("VisitAppStore")
        case .visitInstagram:
            FBSDKAppEvents.logEvent("VisitInstagram")
        case .visitFacebook:
            FBSDKAppEvents.logEvent("VisitFacebook")
        case .viewEventList:
            FBSDKAppEvents.logEvent("ViewEventList")
        case .viewEventDetail:
            FBSDKAppEvents.logEvent("ViewEventDetail")
        case .viewAbout:
            FBSDKAppEvents.logEvent("ViewAbout")
        case .viewCredits:
            FBSDKAppEvents.logEvent("ViewCredits")
        case .viewLogin:
            FBSDKAppEvents.logEvent("ViewLogin")
        case .skippedLogin:
            FBSDKAppEvents.logEvent("SkippedLogin")
        case .logout:
            FBSDKAppEvents.logEvent("Logout")
        case .viewUser:
            FBSDKAppEvents.logEvent("ViewUser")
        case .viewAttendees:
            FBSDKAppEvents.logEvent("ViewAttendees")
        case .viewAppIcons:
            FBSDKAppEvents.logEvent("viewAppIcons")
        }
        
    }
}
