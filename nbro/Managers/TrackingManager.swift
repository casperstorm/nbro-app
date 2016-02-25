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
    class func trackUser() {
        FacebookManager.user({ (user) in
            Crashlytics.sharedInstance().setUserIdentifier(user.id)
            Crashlytics.sharedInstance().setUserName(user.name)
        })
    }
}