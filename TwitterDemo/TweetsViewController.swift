////
//  TweetsViewController.swift
//  TwitterDemo
//
//  Created by Angie Lal on 4/12/17.
//  Copyright © 2017 Angie Lal. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, FavoriteDelegate, RetweetDelegate, AddTweetDelegate, ReplyDelegate {
    
    var tweets: [Tweet]!
    var replyTweet: Tweet?
    var profile: User?
    var notified = false

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.navigationController?.navigationBar.tintColor = UIColor(red: 0.11, green: 0.63, blue: 0.95, alpha: 1.0)
    
 
        
        fetchHomeTimeline()
        //NotificationCenter.default.addObserver(self,
//                                               selector: #selector(catchNotification),
//                                               name: NSNotification.Name(rawValue: "MentionsNotification"),
//                                               object: nil)
        //print("ending: \(notified)")
//        
//        print("******\(notified)")
//        if notified {
//            print("Yep, notified")
//            fetchMentionsTimeline()
//        } else {
//            fetchHomeTimeline()
//        }
        
//        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
//            self.tweets = tweets
//            for tweet in tweets {
//                print(tweet.text!)
//            }
//            
//            let refreshControl = UIRefreshControl()
//            refreshControl.addTarget(self, action: #selector(TweetsViewController.refreshControlAction(_:)), for: UIControlEvents.valueChanged)
//            
//            // add refresh control to table view
//            self.tableView.insertSubview(refreshControl, at: 0)
//            // Reload the tableView now that there is new data
//            self.tableView.reloadData()
//            
//        }, failure: { (error: Error) in
//            print("error: \(error.localizedDescription)")
//        })

        // Do any additional setup after loading the view.
        let logo = UIImage(named: "logo.png")
        let imageView = UIImageView(image: logo)
        imageView.contentMode = .scaleAspectFit // set imageview's content mode
        self.navigationItem.titleView = imageView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func reloadData() {
//        print("FINAL\(notified)")
//    }
    
    func fetchHomeTimeline() {
        
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            for tweet in tweets {
                print(tweet.text!)
            }
            
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(TweetsViewController.refreshControlAction(_:)), for: UIControlEvents.valueChanged)
            
            // add refresh control to table view
            self.tableView.insertSubview(refreshControl, at: 0)
            // Reload the tableView now that there is new data
            self.tableView.reloadData()
            
        }, failure: { (error: Error) in
            print("error: \(error.localizedDescription)")
        })

        
    }
    
    func fetchMentionsTimeline() {
        
        TwitterClient.sharedInstance?.mentionsTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            for tweet in tweets {
                print(tweet.text!)
            }
            
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(TweetsViewController.refreshControlActionForMentions(_:)), for: UIControlEvents.valueChanged)
            
            // add refresh control to table view
            self.tableView.insertSubview(refreshControl, at: 0)
            // Reload the tableView now that there is new data
            self.tableView.reloadData()
            
        }, failure: { (error: Error) in
            print("error: \(error.localizedDescription)")
        })
        //notified = false

    }
//
//    func catchNotification() {
//        print("I've been notified")
//        notified = true
//        print("What am I now? \(notified)")
//    }
    
    func addTweet(tweet: Tweet) {
        tweets.insert(tweet, at: 0)
        print("got here")
        tableView.reloadData()
    }

    
    @IBAction func onLogoutButton(_ sender: Any) {
        TwitterClient.sharedInstance?.logout()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "ComposeTweet" {
            let navigationController = segue.destination as! UINavigationController
            let newTweetVC = navigationController.topViewController as! NewTweetViewController
            newTweetVC.user = User.currentUser
            
        } else if segue.identifier == "ReplyTweet" {
           let navigationController = segue.destination as! UINavigationController
            let replyTweetVC = navigationController.topViewController as? NewTweetViewController
            let screenname = replyTweet?.user?.screenname
            let replyToStatusId = replyTweet?.id
            replyTweetVC?.replyToUser = replyToStatusId ?? nil
            replyTweetVC?.user = User.currentUser
            replyTweetVC?.screenname = screenname as String?
            
            
        } else if segue.identifier == "Profile" {
//            let navVC = segue.destination as! UINavigationController
//            let profileVC = navVC.topViewController as! ProfileViewController
//            let backItem = UIBarButtonItem()
//            backItem.title = "Back"
//            navigationItem.backBarButtonItem = backItem
//            
//            if let profile = profile {
//                print("****profile \(profile)")
//                profileVC.userData = profile
           // }
            
            let profileViewController = segue.destination as! ProfileViewController
            if let profile = profile {
                print("****profile \(profile)")
                profileViewController.userData = profile
            }
            
        } else {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let tweet = tweets[(indexPath?.row)!]
            
            let detailViewController = segue.destination as? TweetDetailViewController
            detailViewController?.tweet = tweet
            print(detailViewController?.tweet?.isFavorited! ?? false)
        }
    }

    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        
        TwitterClient.sharedInstance?.mentionsTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            for tweet in tweets {
                print(tweet.text!)
            }
            
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(TweetsViewController.refreshControlAction(_:)), for: UIControlEvents.valueChanged)
            
            // add refresh control to table view
            self.tableView.insertSubview(refreshControl, at: 0)
            // Reload the tableView now that there is new data
            self.tableView.reloadData()
            
        }, failure: { (error: Error) in
            print("error: \(error.localizedDescription)")
        })
        
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            // Reload the tableView now that there is new data
            self.tableView.reloadData()
            
            // Tell the refreshControl to stop spinning
            refreshControl.endRefreshing()
            
        }, failure: { (error: Error) in
            print("error: \(error.localizedDescription)")
        })
        
    }
    
    

}

extension TweetsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        cell.tweetData = tweets?[indexPath.row] ?? nil
        cell.favTweetDelegate = self
        cell.retweetDelegate = self
        cell.replyDelegate = self
        cell.profileImage.tag = indexPath.row
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTap))
        cell.profileImage.addGestureRecognizer(gestureRecognizer)
        cell.profileImage.isUserInteractionEnabled = true
        cell.profileImage.tag = indexPath.row
        
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }
    
    func onTap(_ sender: UITapGestureRecognizer) {
        if let tappedRow = sender.view?.tag {
            let tweet = tweets[tappedRow]
            if let retweetedStatus = tweet.retweetedStatus {
                //tweet = Tweet(dictionary: retweetedStatus)
                profile = User(dictionary: retweetedStatus["user"] as! NSDictionary)
            } else {
                if let tappedUser = tweet.user {
                    profile = tappedUser
                }
            }
        }
    
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ProfileNotification"), object: nil)
        //NotificationCenter.default.post(name: Notification.Name("ProfileNotification"), object: nil, userInfo: ["profile": profile!])
        performSegue(withIdentifier: "Profile", sender: self)
        
    }
    
    func favoritedTweet(tweet: Tweet, cell: TweetCell) {
        TwitterClient.sharedInstance?.favoriteTweet(tweet.id!, success: { (tweet) in
                cell.increaseFavCountAndImageColor(updatedCount: tweet.favoritesCount)
        }, failure: { (error) in
            print(error)
        })
    }
    
    func unfavoritedTweet(tweet: Tweet, cell: TweetCell) {
        TwitterClient.sharedInstance?.unfavoriteTweet(tweet.id!, success: { (tweet) in
                cell.decreaseFavCountandImageColor(updatedCount:  tweet.favoritesCount)
        }, failure: { (error) in
            print(error)
        })
    }
    
    func retweetedTweet(tweet: Tweet, cell: TweetCell) {
        TwitterClient.sharedInstance?.retweetMessage(tweet.id!, success: { (tweet) in
            cell.increaseRetweetCountAndImageColor(updatedCount: tweet.retweetCount)
        }, failure: { (error) in
            print(error)
        })
    }
    
    func unretweetedTweet(tweet: Tweet, cell: TweetCell) {
        TwitterClient.sharedInstance?.unretweetMessage(tweet.id!, success: { (tweet) in
            cell.decreaseRetweetCountandImageColor(updatedCount: tweet.retweetCount-1)
        }, failure: { (error) in
            print(error)
        })
    }
    
    func replyButtonTapped(cell: TweetCell) {
        let indexPath = self.tableView.indexPathForRow(at: cell.center)!
        replyTweet = tweets![indexPath.row]
    }
    
    func loadMentions() {
        print("WOOOOOOOO")
        fetchMentionsTimeline()
    }
    
    func refreshControlActionForMentions(_ refreshControl: UIRefreshControl) {
        
        
        TwitterClient.sharedInstance?.mentionsTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            for tweet in tweets {
                print(tweet.text!)
            }
            
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(TweetsViewController.refreshControlActionForMentions(_:)), for: UIControlEvents.valueChanged)
            
            // add refresh control to table view
            self.tableView.insertSubview(refreshControl, at: 0)
            // Reload the tableView now that there is new data
            self.tableView.reloadData()
            
        }, failure: { (error: Error) in
            print("error: \(error.localizedDescription)")
        })
        
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            // Reload the tableView now that there is new data
            self.tableView.reloadData()
            
            // Tell the refreshControl to stop spinning
            refreshControl.endRefreshing()
            
        }, failure: { (error: Error) in
            print("error: \(error.localizedDescription)")
            })
    }
}
