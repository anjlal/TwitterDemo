//
//  TweetsViewController.swift
//  TwitterDemo
//
//  Created by Angie Lal on 4/12/17.
//  Copyright © 2017 Angie Lal. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, FavoriteDelegate, RetweetDelegate, AddTweetDelegate {
    
    var tweets: [Tweet]!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var replyImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        
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
    
    func addTweet(tweet: Tweet) {
        tweets.insert(tweet, at: 0)
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
            
            } else {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let tweet = tweets[(indexPath?.row)!]
            
            let detailViewController = segue.destination as? TweetDetailViewController
            detailViewController?.tweet = tweet
        }
    }

    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(_ refreshControl: UIRefreshControl) {

        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
//            for tweet in tweets {
//                print(tweet.text!)
//            }
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
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }
    
    func favoritedTweet(tweet: Tweet, cell: TweetCell) {
        TwitterClient.sharedInstance?.favoriteTweet(tweet.id!, success: { (tweet) in
                cell.increaseFavCountAndImageColor()
        }, failure: { (error) in
            print(error)
        })
    }
    
    func unfavoritedTweet(tweet: Tweet, cell: TweetCell) {
        TwitterClient.sharedInstance?.unfavoriteTweet(tweet.id!, success: { (tweet) in
                cell.decreaseFavCountandImageColor()
        }, failure: { (error) in
            print(error)
        })
    }
    
    func retweetedTweet(tweet: Tweet, cell: TweetCell) {
        TwitterClient.sharedInstance?.retweetMessage(tweet.id!, success: { (tweet) in
            cell.increaseRetweetCountAndImageColor()
        }, failure: { (error) in
            print(error)
        })
    }
    
    func unretweetedTweet(tweet: Tweet, cell: TweetCell) {
        TwitterClient.sharedInstance?.unretweetMessage(tweet.id!, success: { (tweet) in
            cell.decreaseRetweetCountandImageColor()
        }, failure: { (error) in
            print(error)
        })
    }
}
