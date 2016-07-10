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
    private var _vRights: String
    private var _vPrice: String
    private var _vImageUrl: String
    private var _vArtist: String
    private var _vVideoUrl: String
    private var _vImid: String
    private var _vGenre: String
    private var _vLinkToiTunes: String
    private var _vReleaseDate: String
    
    
    var vName: String {
        return _vName
    }
    var vRights: String {
        return _vRights
    }
    
    var vPrice: String {
        return _vPrice
    }

    var vImageUrl: String {
        return _vImageUrl
    }
    
    var vArtist: String {
        return _vArtist
    }

    var vVideoUrl: String {
        return _vVideoUrl
    }

    var vImid: String {
        return _vImid
    }
    var vGenre: String {
        return _vGenre
    }
    var vLinkToiTunes: String {
        return _vLinkToiTunes
    }
    var vReleaseDate: String {
        return _vReleaseDate
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
        
        // Rights
        if let rights = data["rights"] as? JSONDictionary,
            vRights = rights["label"] as? String {
            _vRights = vRights
        }
        else {
            _vRights = ""
        }
 
        // Price
        if let price = data["im:price"] as? JSONDictionary,
            vPrice = price["label"] as? String {
            _vPrice = vPrice
        }
        else {
            _vPrice = ""
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
        
        // Artist
        if let artist = data["im:artist"] as? JSONDictionary,
            vArtist = artist["label"] as? String {
            _vArtist = vArtist
        }
        else {
            _vArtist = ""
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
        
        // ID & iTunes Link
        _vImid = ""
        _vLinkToiTunes = ""
        if let id = data["id"] as? JSONDictionary {
            // ID
            if let vId = id["attributes"] as? JSONDictionary,
                vImid = vId["im:id"] as? String {
                _vImid = vImid
            }
            // iTunes Link
            if let vLinkToiTunes = id["label"] as? String {
                _vLinkToiTunes = vLinkToiTunes
            }
        }
        
        
        // Genre
        if let category = data["category"] as? JSONDictionary,
            attrib = category["attributes"] as? JSONDictionary,
            vGenre = attrib["term"] as? String {
            _vGenre = vGenre
        }
        else {
            _vGenre = ""
        }
        
        // Release Date
        if let releaseDate = data["im:releaseDate"] as? JSONDictionary,
            attrib = releaseDate["attributes"] as? JSONDictionary,
            vReleaseDate = attrib["label"] as? String {
            _vReleaseDate = vReleaseDate
        }
        else {
            _vReleaseDate = ""
        }
    }
}