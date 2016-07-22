//
//  MusicVideoDetailVC.swift
//  MusicVideo
//
//  Created by Charles Swafford on 7/20/16.
//  Copyright © 2016 learn IOS 9. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import LocalAuthentication

class MusicVideoDetailVC: UIViewController {

    var videos: Videos!
    
    var securitySwitch: Bool = false
    
    @IBOutlet weak var vName: UILabel!

    @IBOutlet weak var videoImage: UIImageView!
    
    @IBOutlet weak var vGenre: UILabel!
    
    @IBOutlet weak var vPrice: UILabel!
    
    @IBOutlet weak var vRights: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        title = videos.vArtist
        vName.text = videos.vName
        vPrice.text = videos.vPrice
        vRights.text = videos.vRights
        vGenre.text = videos.vGenre
        
        if videos.vImageData != nil {
            videoImage.image = UIImage(data: videos.vImageData!)
        }
        else {
            videoImage.image = UIImage(named: "imageNotAvailable")
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MusicVideoDetailVC.preferredFontChange), name: UIContentSizeCategoryDidChangeNotification, object: nil)
        

    }
    
    
    func preferredFontChange() {
        vName.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        vPrice.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        vGenre.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        
        vRights.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIContentSizeCategoryDidChangeNotification, object: nil)    }


    @IBAction func socialMedia(sender: UIBarButtonItem) {
    
        securitySwitch = NSUserDefaults.standardUserDefaults().boolForKey("SecSetting")

        switch securitySwitch {
        case true:
            touchIdCheck()
        default:
            shareMedia()
        }

    }
    
    func touchIdCheck() {
        
        // Create an alert
        let alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "continue", style: UIAlertActionStyle.Cancel, handler: nil))
        
        // create the Local Authentication Context
        let context = LAContext()
        var touchIDError: NSError?
        let reasonString = "Touch-Id authentication is needed to share info on Social Media"
        
        // Checj if we can access local device authentication
        if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &touchIDError) {
            // Check what the authentication response was
            context.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString, reply: { (success, policyError) in
                if success {
                    // User authenticated using local device authentication successfully
                    dispatch_async(dispatch_get_main_queue(), { 
                        [unowned self] in self.shareMedia()
                    })
                }
                else {
                    alert.title = "Unsuccessful!"
                    
                    switch LAError(rawValue: policyError!.code)! {
                    
                    case .AppCancel:
                        alert.message = "Authentication was canceled by the application"
                        
                    case .AuthenticationFailed:
                        alert.message = "The user failed to provide valid credentials"
                        
                    case .PasscodeNotSet:
                        alert.message = "Passcode is not set on the device"
                        
                    case .SystemCancel:
                        alert.message = "Authentication was cancelled by the system"
                        
                    case .TouchIDLockout:
                        alert.message = "Too many failed attempts"
                        
                    case .UserCancel:
                        alert.message = "You canceled the request"
                        
                    case .UserFallback:
                        alert.message = "Password not accepted, must use Touch-ID"
                        
                    default:
                        alert.message = ""
                    }
                    
                    // Show the alert
                    dispatch_async(dispatch_get_main_queue(), { 
                        [unowned self] in self.presentViewController(alert, animated: true, completion: nil)
                    })
                }
            })
        }
        else {
            // Unable to access Local device authentication
            
            // Set error Title
            alert.title = "Error"
            
            // Set the error alerrt message with more info
            switch LAError(rawValue: touchIDError!.code)! {
           
            case .TouchIDNotEnrolled:
                alert.message = "Touch ID is not enrolled"
                
            case .TouchIDNotAvailable:
                alert.message = "Touch ID is not available on the device"

            case .PasscodeNotSet:
                alert.message = "Passcode has not been set"

            case .InvalidContext:
                    alert.message = "The context is invalid"

            default:
                alert.message = "Local authentication not available"

            }
            // Show Alert
            dispatch_async(dispatch_get_main_queue(), { 
                [unowned self] in self.presentViewController(alert, animated: true, completion: nil)
            })
        }
    }
    
    func shareMedia() {
    
        let activity1 = "Have you had the opportunity to see this Music Video?"
        let activity2 = ("\(videos.vName) by \(videos.vArtist)")
        let activity3 = "Watch it and tell me what you think?"
        let activity4 = videos.vLinkToiTunes
        let activity5 = "(Share with the Music Video App - Step It UP!)"
        
        let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [activity1, activity2, activity3, activity4, activity5], applicationActivities: nil)
        
        
        
        activityViewController.completionWithItemsHandler = {
            (activity, success, items, error) in
            
            if activity == UIActivityTypeMail {
                print("email selected")
            }
        }
        
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func playVideo(sender: UIBarButtonItem) {
        
        let url = NSURL(string: videos.vVideoUrl)!
        let player = AVPlayer(URL: url)
        let playerViewControler = AVPlayerViewController()
        playerViewControler.player = player
        
        self.presentViewController(playerViewControler, animated: true) {
                playerViewControler.player?.play()

        }
    }
    

}
