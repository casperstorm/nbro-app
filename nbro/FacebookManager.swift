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
        FBSDKLoginManager().logInWithReadPermissions(["email"], fromViewController: nil, handler: {
            (result: FBSDKLoginManagerLoginResult!, error: NSError!) -> Void in
            if let _ = result {
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
        let nbro = "108900355842020"
        let params = ["fields": "cover, name, description, place, start_time, end_time, type, updated_time, timezone, attending_count, maybe_count, noreply_count, interested_count"]

        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: nbro+"/events?since=2016-02-10&limit=999", parameters: params)
        graphRequest.startWithCompletionHandler({
            (connection, result, error) -> Void in
            if let r = result {
                //let paging = r["paging"]
                let data = r["data"] as! Array<AnyObject>
                var events: [Event] = []
                for event in data {
                    events.append(Event.init(event as! Dictionary<String, AnyObject>))
                }
                
                events.sortInPlace({ $0.startDate!.compare($1.startDate!) == NSComparisonResult.OrderedAscending })
                completion(events: events)
            }
        })
    }
}