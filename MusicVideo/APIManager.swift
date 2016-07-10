//
//  APIManager.swift
//  MusicVideo
//
//  Created by Charles Swafford on 7/9/16.
//  Copyright © 2016 learn IOS 9. All rights reserved.
//

import Foundation

struct APIManager {
    
    func loadData(urlString: String, completion: (result: String) -> Void) {
        
        // set up for no caches
        let config = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        let url = NSURL(string: urlString)!
        
        let task = session.dataTaskWithURL(url) {
            (data, response, error) -> Void in
            
            if error != nil {
                dispatch_async(dispatch_get_main_queue()) {
                    completion(result: (error!.localizedDescription))
                }
            }
            else {
                
                // JSON Serialization
                do {
                    // .AllowFragments - top level object is not Array or Dictionary.
                    // Any type of string or value
                    // NSJSONSerialization requires the Do / Try / Catch
                    // Converts the NSData into JSON Object and cast it to a Dictionary
                    
                    if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? JSONDictionary {
                        print(json)
                        
                        let priority = DISPATCH_QUEUE_PRIORITY_HIGH
                        dispatch_async(dispatch_get_global_queue(priority, 0)) {
                            dispatch_async(dispatch_get_main_queue()) {
                                completion(result: "JSONSerialization Sucessful")
                            }
                        }
                    }
                }
                catch {
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(result: "error in NAJSONSerialization")
                    }
                }
            }
        }
        task.resume()
    }
}