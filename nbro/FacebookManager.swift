//
//  FacebookManager.swift
//  nbro
//
//  Created by Casper Storm Larsen on 03/02/16.
//  Copyright © 2016 Bob. All rights reserved.
//

import Foundation
import FBSDKLoginKit

class FacebookManager {
    class func logInWithReadPermissions(completion: (success: Bool) -> Void) {
        let loginManager = FBSDKLoginManager()
        loginManager.logInWithReadPermissions(["public_profile"], fromViewController: nil, handler: {
            (result: FBSDKLoginManagerLoginResult?, error: NSError?) -> Void in
            if result?.token != nil {
                completion(success: true)
            } else {
                completion(success: false)
            }
        })
    }
    
    class func authenticated() -> Bool {
        return FBSDKAccessToken.currentAccessToken() != nil
    }
    
    class func events(completion: (events: [Event]) -> Void) {
        let params = ["fields": "cover, name, description, place, start_time, end_time, type, updated_time, timezone, attending_count, maybe_count, noreply_count, interested_count"]
        let graphPath = eventGraphPath()

        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: graphPath, parameters: params)
        graphRequest.startWithCompletionHandler({
            (connection, result, error) -> Void in
            if let r = result {
                let data = r["data"] as! Array<NSDictionary>
                var events = data.map { (dict: NSDictionary) -> Event? in
                    return Event(dictionary: dict)
                    }.flatMap { $0 }
                events.sortInPlace({ $0.startDate.compare($1.startDate) == NSComparisonResult.OrderedAscending })
                completion(events: events)
            }
        })
    }
    
    class func user(completion: (user: User) -> Void) {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "name"])
        graphRequest.startWithCompletionHandler({
            (connection, result, error) -> Void in
            guard let dict = result as? NSDictionary, user = User(dictionary: dict) else {
                return
            }
            completion(user: user)
        })
    }
    
    // MARK: Helpers
    
    private class func currentDateString(format: String) -> String {
        let date = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.stringFromDate(date)
    }
    
    private class func eventGraphPath() -> String {
        let dateString = currentDateString("yyyy-MM-dd")
        let nbroGroupId = "108900355842020"
        let limit = "999"
        let path = nbroGroupId + "/events" + "?since=" + dateString + "&limit=" + limit
        return path
    }
}