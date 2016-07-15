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
        musicImage.image = UIImage(named: "imageNotAvailable")
    }
}
