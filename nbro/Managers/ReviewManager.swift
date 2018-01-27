//
//  ReviewManager.swift
//  nbro
//
//  Created by Casper Rogild Storm on 27/01/2018.
//  Copyright © 2018 Bob. All rights reserved.
//

import Foundation
import StoreKit

class ReviewManager {
    static let runIncrementerSetting = "nbrorunning.numberOfRuns"
    static let minimumRunCount = 2
    
    class func incrementAppRuns() {
        let defaults = UserDefaults()
        let runs = getRunCounts() + 1
        defaults.setValuesForKeys([runIncrementerSetting: runs])
        defaults.synchronize()
    }
    
    class func showReview() {
        let runs = getRunCounts()
        if (runs > minimumRunCount) {
            print("Has requested review!")
            SKStoreReviewController.requestReview()
        } else {
            print("Runs are not enough to request review!")
        }
        
    }
    
    fileprivate class func getRunCounts() -> Int {
        let defaults = UserDefaults()
        let runs = defaults.integer(forKey: runIncrementerSetting)
        return runs
    }
}
