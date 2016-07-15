//
//  MusicVideoTableViewCell.swift
//  MusicVideo
//
//  Created by Charles Swafford on 7/15/16.
//  Copyright © 2016 learn IOS 9. All rights reserved.
//

import UIKit

class MusicVideoTableViewCell: UITableViewCell {

    var video: Videos? {
        didSet {
            updateCell()
        }
    }
    
    @IBOutlet weak var musicImage: UIImageView!

    @IBOutlet weak var rank: UILabel!
    
    @IBOutlet weak var musicTitle: UILabel!
    
    func updateCell() {
        musicTitle.text = video?.vName
        rank.text = "\(video!.vRank)"
        //musicImage.image = UIImage(named: "imageNotAvailable")
        
        if video!.vImageData != nil {
            print("Get data from array ...")
            musicImage.image = UIImage(data: video!.vImageData!)
        }
        else {
            getVideoImage(video!, imageView: musicImage)
            print("get image from background thread")
        }
    }
    
    
    func getVideoImage(video: Videos, imageView: UIImageView) {
        // Background Thread
        // DISPATCH_QUEUE_PRIORITY_HIGH Items dispatched to the queue will run at high
        // priority, i.e. the queue will schedule for execution before any default
        // priority or low priority queue.
        
        // DISPATCH_QUEUE_PRIORITY_LOW Items dispatched to the queue will run at the
        // default priority, i.e. the queue will schedule for execution after all high
        // priority queues have been scheduled, but before low priority queue.
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let data = NSData(contentsOfURL: NSURL(string: video.vImageUrl)!)
            
            var video = video
            var image: UIImage?
            if data != nil {
                video.vImageData = data
                image = UIImage(data: data!)
            }
            
            // move back to Main Queue
            dispatch_async(dispatch_get_main_queue(), { 
                imageView.image = image
            })
            
        }
    }
}
