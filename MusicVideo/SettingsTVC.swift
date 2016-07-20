//
//  SettingsTVC.swift
//  MusicVideo
//
//  Created by Charles Swafford on 7/20/16.
//  Copyright © 2016 learn IOS 9. All rights reserved.
//

import UIKit

class SettingsTVC: UITableViewController {

    @IBOutlet weak var aboutDisplay: UILabel!
    
    @IBOutlet weak var feedbackDisplay: UILabel!
    
    @IBOutlet weak var securityDisplay: UILabel!
    
    @IBOutlet weak var bestImageDisplay: UILabel!
    
    @IBOutlet weak var APICnt: UILabel!
    
    @IBOutlet weak var touchId: UISwitch!
    
    @IBOutlet weak var sliderCnt: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "settings"
        
        tableView.alwaysBounceVertical = false
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SettingsTVC.preferredFontChange) , name: UIContentSizeCategoryDidChangeNotification, object: nil)

        touchId.on = NSUserDefaults.standardUserDefaults().boolForKey("SecSetting")
    }

    
    @IBAction func touchIdSecurity(sender: UISwitch) {
        let defaults = NSUserDefaults.standardUserDefaults()
        if touchId.on {
            defaults.setBool(touchId.on, forKey: "SecSetting")
        }
        else {
            defaults.setBool(false, forKey: "SecSetting")
        }        
    }
    
    
    func preferredFontChange() {
        aboutDisplay.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        feedbackDisplay.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        securityDisplay.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        bestImageDisplay.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        APICnt.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }
    

}
