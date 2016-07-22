//
//  MusicVideoTVC.swift
//  MusicVideo
//
//  Created by Charles Swafford on 7/14/16.
//  Copyright © 2016 learn IOS 9. All rights reserved.
//

import UIKit

class MusicVideoTVC: UITableViewController {
    
    var videos = [Videos]()
    var filterSearch = [Videos]()
    
    let resultSearchController = UISearchController(searchResultsController: nil)
    
    var limit = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.reachabilityStatusChanged), name: "ReachStatusChanged", object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MusicVideoTVC.preferredFontChange), name: UIContentSizeCategoryDidChangeNotification, object: nil)

        reachabilityStatusChanged()
        
    }
    
    func preferredFontChange() {
        print("preferred Font has changed")
    }
    
    
    func didLoadData(videos: [Videos]) {
        print(reachabilityStatus)
        
        self.videos = videos
        
        for (index, item) in videos.enumerate() {
            print("\(index) name = \(item.vName)")
        }
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.redColor()]
        title = ("The iTunes Top \(limit) Music Videos")
        
        // Setup Search Controller
        
        //resultSearchController.searchResultsUpdater = self
        
        definesPresentationContext = true
        resultSearchController.dimsBackgroundDuringPresentation = false
        resultSearchController.searchBar.placeholder = "Search for Artist"
        resultSearchController.searchBar.searchBarStyle = UISearchBarStyle.Prominent
        
        // add the search bar to tableview
        tableView.tableHeaderView = resultSearchController.searchBar
        
        
        tableView.reloadData()
    }
    
    @IBAction func refresh(sender: UIRefreshControl) {
        refreshControl?.endRefreshing()
        runAPI()
    }
    
    func getAPICount() {
        if NSUserDefaults.standardUserDefaults().objectForKey("APICNT") != nil {
            let count = NSUserDefaults.standardUserDefaults().objectForKey("APICNT") as! Int
            limit = count
        }
        let formatter = NSDateFormatter()
        formatter.dateFormat = "E, dd MMM yyyy HH:mm:ss"
        let refreshDate = formatter.stringFromDate(NSDate())
        
        refreshControl?.attributedTitle = NSAttributedString(string: "\(refreshDate)")
    }
    
    func runAPI() {
        
        getAPICount()
        
        // Call API
        let api = APIManager()
        api.loadData("http://itunes.apple.com/us/rss/topmusicvideos/limit=\(limit)/json", completion: didLoadData)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "ReachStatusChanged", object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }
    
    
    
    func reachabilityStatusChanged() {
        
        switch reachabilityStatus {
        case NOACCESS:
          //  view.backgroundColor = UIColor.redColor()
            
            // It is possible the view has not loaded when we try to dislay the alert which will give this warning
            //
            //  Presenting view controllers on detached view controllers is discouraged
            //
            // The fix is to run this in the Main Queue -- NOT Sure Why
            //
            dispatch_async(dispatch_get_main_queue(), {
                
                let alert = UIAlertController(title: "No Internet Acess", message: "Please make sure you are connected to the Internet", preferredStyle: .Alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: { (action) in
                    print("Cancel")
                })
                let deleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: { (action) in
                    print("Delete")
                })
                let okAction = UIAlertAction(title: "Ok", style: .Default, handler: { (action) in
                    print("OK")
                })
                
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                alert.addAction(deleteAction)
                
                self.presentViewController(alert, animated: true, completion: nil)
            })
            
            //case WWAN:
            //    view.backgroundColor = UIColor.yellowColor()
            
        default:
           // view.backgroundColor = UIColor.greenColor()
            if videos.count > 0 {
                print("Do not refresh API")
            }
            else {
                runAPI()
            }
            
        }
    }
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if resultSearchController.active {
            return filterSearch.count
        }
        return videos.count
    }
    
    //
    // StoryBoard
    //
    private struct storyboard {
        static let cellResueIdentifier = "cell"
        static let seguelIdentifier = "musicDetail"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(storyboard.cellResueIdentifier, forIndexPath: indexPath) as! MusicVideoTableViewCell
        
        //
        // **** loads everything via "didSet" when cell.video is assigned ****
        //
        
        if resultSearchController.active {
            cell.video = filterSearch[indexPath.row]
        }
        else {
            cell.video = videos[indexPath.row]
        }
        
        
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
      override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        
        if segue.identifier == storyboard.seguelIdentifier {
            if let indexPath = tableView.indexPathForSelectedRow {
                
                let video: Videos
                
                if resultSearchController.active {
                    video = filterSearch[indexPath.row]
                }
                else {
                    video = videos[indexPath.row]
                }
                
                let dvc = segue.destinationViewController as! MusicVideoDetailVC
                dvc.videos = video
            }
        }
     }
    
}
