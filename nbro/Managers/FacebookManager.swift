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
    class func logInWithReadPermissions(_ completion: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        let loginManager = FBSDKLoginManager()
        loginManager.logIn(withReadPermissions: ["public_profile", "user_events"], from: nil, handler: {
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
    
    class func logout() {
        FBSDKLoginManager().logOut()
    }
    
    class func authenticated() -> Bool {
        return FBSDKAccessToken.current() != nil
    }
    
    class func detailedEvent(_ event: Event, completion: @escaping (_ result: NSDictionary) -> Void) {
        let params = ["fields": "attending_count, interested_count"]
        let graphPath = event.id
        let graphRequest: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: graphPath, parameters: params)
        graphRequest.start(completionHandler: {
            (connection, result, error) -> Void in
            guard let resultDict = result as? NSDictionary else {
                return
            }
            completion(resultDict)
        })
    }
    
    class func attendeesForEvent(_ event: Event, completion: @escaping (_ result: NSDictionary) -> Void) {
        profilesForEvent(event, params: ["fields": "attending.limit(999){name,picture.width(400)}"], completion: completion)
    }
    
    class func interestedForEvent(_ event: Event, completion: @escaping (_ result: NSDictionary) -> Void) {
        profilesForEvent(event, params: ["fields": "maybe.limit(999){name,picture.width(400)}"], completion: completion)
    }
    
    fileprivate class func profilesForEvent(_ event: Event, params: [String:String], completion: @escaping (_ result: NSDictionary) -> Void) {
        let graphPath = event.id
        let graphRequest: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: graphPath, parameters: params)
        graphRequest.start(completionHandler: {
            (connection, result, error) -> Void in
            guard let resultDict = result as? NSDictionary else {
                return
            }
            completion(resultDict)
        })
    }
    
    class func NBROEvents(_ completion: @escaping (_ events: [Event]) -> Void,  failure: @escaping ((Void) -> Void)) {
        let params = ["fields": "cover, name, description, place, start_time, end_time, type, updated_time, timezone, attending_count, maybe_count, noreply_count, interested_count"]
        let graphPath = eventGraphPath()

        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: graphPath, parameters: params)
        graphRequest.start(completionHandler: {
            (connection, result, error) -> Void in
            if error != nil {
                failure()
            } else if let r = result {
                guard let data = r["data"] as? Array<NSDictionary> else {
                    completion([])
                    return
                }
                var events = data.map { (dict: NSDictionary) -> Event? in
                    return Event(dictionary: dict)
                    }.flatMap { $0 }
                events.sort(by: { $0.startDate.compare($1.startDate) == ComparisonResult.orderedAscending })
                completion(events: events)
            }
        })
    }
    
    class func userEvents(_ completion: @escaping (_ events: [Event]) -> Void,  failure: @escaping ((Void) -> Void)) {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "events.limit(100)"])
        graphRequest.start(completionHandler: {
            (connection, result, error) -> Void in
            if error != nil {
                failure()
            } else if let r = result as? NSDictionary {
                guard let e = r["events"] as? NSDictionary, let data = e["data"] as? Array<NSDictionary> else {
                    completion([])
                    return
                }
                var events = data.map { (dict: NSDictionary) -> Event? in
                    return Event(dictionary: dict)
                    }.flatMap { $0 }
                events.sort(by: { $0.startDate.compare($1.startDate as Date) == ComparisonResult.orderedAscending })
                completion(events)
            }
        })
    }
    
    class func user(_ completion: @escaping (_ user: FacebookProfile) -> Void) {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/me", parameters: ["fields" : "name, picture.width(600)"])
        graphRequest.start(completionHandler: {
            (connection, result, error) -> Void in
            guard let dict = result as? NSDictionary, let user = FacebookProfile(dictionary: dict) else {
                return
            }
            completion(user)
        })
    }
    
    class func requestPermission(_ permissions: Array<String>, completion:@escaping (_ success: Bool, _ error: NSError?) -> Void) {
        let loginManager = FBSDKLoginManager()
        loginManager.logIn(withPublishPermissions: permissions, from: nil, handler: {
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
    
    fileprivate class func userHasPermission(_ permission: String) -> Bool {
        let permissions = FBSDKAccessToken.current().permissions
        return permissions!.contains(permission)
    }
    
    class func userHasRSVPEventPermission() -> Bool {
        let rsvp = "rsvp_event"
        return FacebookManager.userHasPermission(rsvp)
    }
    
    fileprivate class func handleEventRSVP(_ event: Event, path: String, completion:@escaping (_ success: Bool, _ error: NSError?) -> Void) {
        let rsvp = "rsvp_event"
        let hasPermissionAccess = userHasRSVPEventPermission()
        
        if !hasPermissionAccess {
            // No RSVP permission in local stored token.
            // Request the permission, and call this function again.
            FacebookManager.requestPermission([rsvp], completion: { (success, error) in
                if(!success || error != nil) {
                    completion(false, error)
                } else {
                    FacebookManager.attentEvent(event, completion: completion)
                }
            })
        } else {
            // Permission was found in local stored token.
            let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: path, parameters: ["fields": ""], httpMethod: "POST")
            graphRequest.start(completionHandler: {
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
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
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
                        completion(false, error as NSError?)
                        break
                    }
                } else {
                    // If no error, try to unpack result and return success var
                    guard let dict = result as? NSDictionary, let success = dict["success"] as? Bool else {
                        completion(false, error as NSError?)
                        return
                    }
                    completion(success, error as NSError?)
                }
            })
        }
    }
    
    class func declineEvent(_ event: Event, completion:@escaping (_ success: Bool, _ error: NSError?) -> Void)  {
        let path = "/\(event.id)/declined"
        FacebookManager.handleEventRSVP(event, path: path, completion: completion)

    }
    
    class func attentEvent(_ event: Event, completion:@escaping (_ success: Bool, _ error: NSError?) -> Void)  {
        let path = "/\(event.id)/attending"
        FacebookManager.handleEventRSVP(event, path: path, completion: completion)
    }

    fileprivate class func recoverLostRSVPPermission(_ event: Event, completion:@escaping (_ success: Bool, _ error: NSError?) -> Void) {
        FacebookManager.requestPermission(["rsvp_event"], completion: { (success, error) in
            if(!success || error != nil) {
                completion(false, error)
            } else {
                FacebookManager.attentEvent(event, completion: completion)
            }
        })
    }
    
    class func isAttendingEvent(_ event: Event, completion:@escaping (_ attending: Bool) -> Void) {
        FacebookManager.user { (user) in
            let path = "/\(event.id)/attending/\(user.id)"
            let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: path, parameters: ["fields": ""])
            graphRequest.start(completionHandler: {
                (connection, result, error) -> Void in
                guard let dict = result as? NSDictionary, let data = dict["data"] as? NSArray else {
                    completion(false)
                    return
                }
                
                completion(data.count > 0)
            })
        }
    }
 
    // MARK: Helpers
    
    fileprivate class func currentDateString(_ format: String) -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    fileprivate class func eventGraphPath() -> String {
        let dateString = currentDateString("yyyy-MM-dd")
        let nbroGroupId = "108900355842020"
        let limit = "999"
        let path = nbroGroupId + "/events" + "?since=" + dateString + "&limit=" + limit
        return path
    }
}
