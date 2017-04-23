//
//  MentionsViewController.swift
//  TwitterDemo
//
//  Created by Angie Lal on 4/22/17.
//  Copyright © 2017 Angie Lal. All rights reserved.
//

import UIKit

class MentionsViewController: TweetsViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        TwitterClient.sharedInstance?.mentionsTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            for tweet in tweets {
                print(tweet.text!)
            }
            
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(MentionsViewController.refreshControlAction(_:)), for: UIControlEvents.valueChanged)
            
            // add refresh control to table view
            self.tableView.insertSubview(refreshControl, at: 0)
            // Reload the tableView now that there is new data
            self.tableView.reloadData()
            
        }, failure: { (error: Error) in
            print("error: \(error.localizedDescription)")
        })


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func refreshControlAction(_ refreshControl: UIRefreshControl) {
        
        TwitterClient.sharedInstance?.mentionsTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            // Reload the tableView now that there is new data
            self.tableView.reloadData()
            
            // Tell the refreshControl to stop spinning
            refreshControl.endRefreshing()
            
        }, failure: { (error: Error) in
            print("error: \(error.localizedDescription)")
        })
    }
//    
//    override func getTweets(refreshing : Bool, maxID: String?) {
//        twitterAPIService.getMentionsTimeline(maxID: maxID) {
//            (tweets: [Tweet]?, error: Error?) in
//            if let tweets = tweets {
//                print(tweets)
//                if self.isLoadingMoreData == .loadingMoreData {
//                    self.isLoadingMoreData = .notLoadingMoreData
//                    self.loadingMoreView!.stopAnimating()
//                    //removes the first element of the returned array as it is repeated
//                    var tweetsWithoutFirst = tweets
//                    tweetsWithoutFirst.remove(at: 0)
//                    self.tweetsArray.append(contentsOf: tweetsWithoutFirst)
//                }else{
//                    self.tweetsArray = tweets
//                    if refreshing {
//                        self.refreshControl.endRefreshing()
//                    }
//                }
//                self.tweetsTableView.reloadData()
//            }else{
//                print(error!.localizedDescription)
//            }
//        }
//    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
