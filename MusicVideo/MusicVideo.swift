//
//  MusicVideo.swift
//  MusicVideo
//
//  Created by Charles Swafford on 7/10/16.
//  Copyright © 2016 learn IOS 9. All rights reserved.
//

import Foundation

struct videos {
    
    private var _vName: String
    private var _vImageUrl: String
    private var _vVideoUrl: String
    
    
    var vName: String {
        return _vName
    }
    
    var vImageUrl: String {
        return _vImageUrl
    }
    
    var vVideoUrl: String {
        return _vVideoUrl
    }
    
    init(data: JSONDictionary) {
        
        // If we do not initialize all properties we will get error messages
        // Return from initializer without initializing all stored properties
        
        // Video Name
        if let name = data["im:name"] as? JSONDictionary,
            vName = name["label"] as? String {
            _vName = vName
        }
        else {
            _vName = ""
        }
        
        // Video Image
        if let imageArray = data["im:image"] as? JSONArray,
            imageDict = imageArray[2] as? JSONDictionary,
            image = imageDict["label"] as? String {
            _vImageUrl = image.stringByReplacingOccurrencesOfString("100x100", withString: "600x600")
        }
        else {
            _vImageUrl = ""
        }
        
        // Video Url
        if let videoLink = data["link"] as? JSONArray,
            videoDict = videoLink[1] as? JSONDictionary,
            videoHref = videoDict["attributes"] as? JSONDictionary,
            videoUrl = videoHref["href"] as? String {
                _vVideoUrl = videoUrl
        }
        else {
            _vVideoUrl = ""
        }
    }
}