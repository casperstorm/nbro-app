//
//  FacebookManager.swift
//  nbro
//
//  Created by Casper Storm Larsen on 03/02/16.
//  Copyright © 2016 Bob. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import FBSDKCoreKit

class FacebookManager {
    class func logInWithReadPermissions(completion: (success: Bool, error: NSError?) -> Void) {
        let loginManager = FBSDKLoginManager()
        loginManager.logInWithReadPermissions(["public_profile"], fromViewController: nil, handler: {
            (result: FBSDKLoginManagerLoginResult?, error: NSError?) -> Void in
            if result?.token != nil {
                completion(success: true, error: nil)
            } else if error != nil {
                completion(success: false, error: error)
            } else {
                completion(success: false, error: nil)
            }
        })
    }
    
    class func authenticated() -> Bool {
        return FBSDKAccessToken.currentAccessToken() != nil
    }
    
    class func events(completion: (events: [Event]) -> Void,  failure: (Void -> Void)) {
        let params = ["fields": "cover, name, description, place, start_time, end_time, type, updated_time, timezone, attending_count, maybe_count, noreply_count, interested_count"]
        let graphPath = eventGraphPath()

        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: graphPath, parameters: params)
        graphRequest.startWithCompletionHandler({
            (connection, result, error) -> Void in
            if let error = error {
                failure()
            } else if let r = result {
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
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "name, email"])
        graphRequest.startWithCompletionHandler({
            (connection, result, error) -> Void in
            guard let dict = result as? NSDictionary, user = User(dictionary: dict) else {
                return
            }
            completion(user: user)
        })
    }
    
    class func requestPermission(permissions: Array<String>, completion:(success: Bool, error: NSError?) -> Void) {
        let loginManager = FBSDKLoginManager()
        loginManager.logInWithPublishPermissions(permissions, fromViewController: nil, handler: {
            (result: FBSDKLoginManagerLoginResult?, error: NSError?) -> Void in
            
            if result?.token != nil {
                completion(success: true, error: nil)
            } else if error != nil {
                completion(success: false, error: error)
            } else {
                completion(success: false, error: nil)
            }
        })
    }
    
    private class func userHasPermission(permission: String) -> Bool {
        let permissions = FBSDKAccessToken.currentAccessToken().permissions
        return permissions.contains(permission)
    }
    
    class func userHasRSVPEventPermission() -> Bool {
        let rsvp = "rsvp_event"
        return FacebookManager.userHasPermission(rsvp)
    }
    
    private class func handleEventRSVP(event: Event, path: String, completion:(success: Bool, error: NSError?) -> Void) {
        let rsvp = "rsvp_event"
        let hasPermissionAccess = userHasRSVPEventPermission()
        
        if !hasPermissionAccess {
            // No RSVP permission in local stored token.
            // Request the permission, and call this function again.
            FacebookManager.requestPermission([rsvp], completion: { (success, error) in
                if(!success || error != nil) {
                    completion(success: false, error: error)
                } else {
                    FacebookManager.attentEvent(event, completion: completion)
                }
            })
        } else {
            // Permission was found in local stored token.
            let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: path, parameters: ["fields": ""], HTTPMethod: "POST")
            graphRequest.startWithCompletionHandler({
                (connection, result, error) -> Void in
                
                // If error exsist try to handle it.
                if(error != nil) {
                    // Error codes are based on: https://developers.facebook.com/docs/graph-api/using-graph-api#errors
                    // Unpack the graph-error-code
                    guard let code = error.userInfo[FBSDKGraphRequestErrorGraphErrorCode] as? Int else {
                        return
                    }
                    
                    switch code {
                    case 102:
                        // Login status or access token has expired, been revoked, or is otherwise invalid
                        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                        appDelegate.presentLoginViewController()
                        break
                    case 200...299:
                        // Permission is either not granted or has been removed
                        self.recoverLostRSVPPermission(event, completion: completion)
                        break
                    case 10:
                        // Permission is either not granted or has been removed
                        self.recoverLostRSVPPermission(event, completion: completion)
                        break
                    default:
                        // If we can't handle it, throw error.
                        completion(success: false, error: error)
                        break
                    }
                } else {
                    // If no error, try to unpack result and return success var
                    guard let dict = result as? NSDictionary, success = dict["success"] as? Bool else {
                        completion(success: false, error: error)
                        return
                    }
                    completion(success: success, error: error)
                }
            })
        }
    }
    
    class func declineEvent(event: Event, completion:(success: Bool, error: NSError?) -> Void)  {
        let path = "/\(event.id)/declined"
        FacebookManager.handleEventRSVP(event, path: path, completion: completion)

    }
    
    class func attentEvent(event: Event, completion:(success: Bool, error: NSError?) -> Void)  {
        let path = "/\(event.id)/attending"
        FacebookManager.handleEventRSVP(event, path: path, completion: completion)
    }

    private class func recoverLostRSVPPermission(event: Event, completion:(success: Bool, error: NSError?) -> Void) {
        FacebookManager.requestPermission(["rsvp_event"], completion: { (success, error) in
            if(!success || error != nil) {
                completion(success: false, error: error)
            } else {
                FacebookManager.attentEvent(event, completion: completion)
            }
        })
    }
    
    class func isAttendingEvent(event: Event, completion:(attending: Bool) -> Void) {
        FacebookManager.user { (user) in
            let path = "/\(event.id)/attending/\(user.id)"
            let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: path, parameters: ["fields": ""])
            graphRequest.startWithCompletionHandler({
                (connection, result, error) -> Void in
                guard let dict = result as? NSDictionary, data = dict["data"] as? NSArray else {
                    completion(attending: false)
                    return
                }
                
                completion(attending: data.count > 0)
            })
        }
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