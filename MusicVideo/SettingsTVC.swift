//
//  SettingsTVC.swift
//  MusicVideo
//
//  Created by Charles Swafford on 7/20/16.
//  Copyright © 2016 learn IOS 9. All rights reserved.
//

import UIKit
import MessageUI
import LocalAuthentication

protocol SettingViewControllerDelegate {
    func updateImageQuality()
}

class SettingsTVC: UITableViewController, MFMailComposeViewControllerDelegate {
    
    var delegate: SettingViewControllerDelegate?
    
    @IBOutlet weak var aboutDisplay: UILabel!
    
    @IBOutlet weak var feedbackDisplay: UILabel!
    
    @IBOutlet weak var securityDisplay: UILabel!
    
    @IBOutlet weak var bestImageDisplay: UILabel!
    
    @IBOutlet weak var bestImageQuality: UISwitch!
    
    @IBOutlet weak var APICnt: UILabel!
    
    @IBOutlet weak var touchId: UISwitch!
    
    @IBOutlet weak var sliderCnt: UISlider!
    
    @IBOutlet weak var numberOfVideoDisplay: UILabel!
    
    @IBOutlet weak var dragSliderDisplay: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Settings"
        
        tableView.alwaysBounceVertical = false
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SettingsTVC.preferredFontChange) , name: UIContentSizeCategoryDidChangeNotification, object: nil)
        
        touchId.on = NSUserDefaults.standardUserDefaults().boolForKey("SecSetting")
        bestImageQuality.on = NSUserDefaults.standardUserDefaults().boolForKey("ImageQuality")

        
        if(NSUserDefaults.standardUserDefaults().objectForKey("APICNT") != nil) {
            let theValue = NSUserDefaults.standardUserDefaults().objectForKey("APICNT") as! Int
            APICnt.text = "\(theValue)"
            sliderCnt.value = Float(theValue)
        }
        else {
            sliderCnt.value = 10.0
            APICnt.text = ("\(Int(sliderCnt.value))")
        }
        
        
        // create the Local Authentication Context
        let context = LAContext()
        var touchIDError: NSError?
        
        // Check if we can access local device authentication
        if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &touchIDError) {
            touchId.enabled = true
        }
        else {
            touchId.enabled = false
        }
    }
    
    
    @IBAction func valueChanged(sender: UISlider) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(Int(sliderCnt.value), forKey: "APICNT")
        APICnt.text = "\(Int(sliderCnt.value))"
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
    
    
    @IBAction func imageQuality(sender: UISwitch) {
        let defaults = NSUserDefaults.standardUserDefaults()
        if bestImageQuality.on {
            defaults.setBool(bestImageQuality.on, forKey: "ImageQuality")
         }
        else {
            defaults.setBool(false, forKey: "ImageQuality")
        }
        delegate?.updateImageQuality()
    }
    
    func preferredFontChange() {
        aboutDisplay.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        feedbackDisplay.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        securityDisplay.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        bestImageDisplay.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        APICnt.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        numberOfVideoDisplay.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        dragSliderDisplay.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 && indexPath.row == 1 {
            let mailComposeViewController = configureMail()
            
            if MFMailComposeViewController.canSendMail() {
                self.presentViewController(mailComposeViewController, animated: true, completion: nil)
            }
            else {
                // No email account setup
                mailAlert()
            }
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    func configureMail() -> MFMailComposeViewController {
        
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setBccRecipients([""])
        mailComposeVC.setCcRecipients([""])
        mailComposeVC.setToRecipients(["edswafford@mchsi.com"])
        mailComposeVC.setSubject("Music Video Feedback")
        mailComposeVC.setMessageBody("Hi Ed,\n\nI would like to share the following feedback...\n", isHTML: false)
        
        return mailComposeVC
    }
    
    
    func mailAlert() {
        let alertController: UIAlertController = UIAlertController(title: "Alert", message: "No e-mail account has been setup for Phone", preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "OK", style: .Default) { action  in
            // do something
        }
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        switch result.rawValue {
        case MFMailComposeResultCancelled.rawValue:
            print("mail canceled")
            
        case MFMailComposeResultSaved.rawValue:
            print("Mail saved")
            
        case MFMailComposeResultSent.rawValue:
            print("Mail sent")
            
        case MFMailComposeResultFailed.rawValue:
            print("Mail failed")

        default:
            print("Unknown Issue")
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }
    
    
}
