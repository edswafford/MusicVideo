//
//  ViewController.swift
//  MusicVideo
//
//  Created by Charles Swafford on 7/8/16.
//  Copyright © 2016 learn IOS 9. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var videos = [Videos]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Call API
        let api = APIManager()
        api.loadData("http://itunes.apple.com/us/rss/topmusicvideos/limit=10/json", completion: didLoadData)
    }

    func didLoadData(videos: [Videos]) {
    
        self.videos = videos
        
        for (index, item) in videos.enumerate() {
            print("\(index) name = \(item.vName)")
        }
/* 
 ******  Alert Example
 */
        
//        let alert = UIAlertController(title: (result), message: nil, preferredStyle: .Alert)
//        let okAction = UIAlertAction(title: "OK", style: .Default) { action -> Void in
//            // do something if you want
//        }
//        alert.addAction(okAction)
//        self.presentViewController(alert, animated: true, completion: nil)
    }
    

}

