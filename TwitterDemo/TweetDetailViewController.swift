//
//  TweetDetailViewController.swift
//  TwitterDemo
//
//  Created by Angie Lal on 4/13/17.
//  Copyright © 2017 Angie Lal. All rights reserved.
//

import UIKit


class TweetDetailViewController: UIViewController, ReplyFromDetailDelegate, TweetDetailViewRetweetDelegate, TweetDetailViewFavDelegate {
    
    var tweet: Tweet?
    var replyTweet: Tweet?

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension

        tableView.reloadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ReplyTweetFromDetail" {
            let navigationController = segue.destination as! UINavigationController
            let replyTweetVC = navigationController.topViewController as? NewTweetViewController
            let screenname = replyTweet?.user?.screenname
            let replyToStatusId = replyTweet?.id
            replyTweetVC?.replyToUser = replyToStatusId ?? nil
            replyTweetVC?.user = User.currentUser
            replyTweetVC?.screenname = screenname as String?
        }
    }


}

extension TweetDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetDetailCell", for: indexPath) as! TweetDetailCell
        cell.replyDelegate = self
        cell.tweetData = tweet
        cell.tweetDetailFavDelegate = self
        cell.tweetDetailRetweetDelegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func replyButtonTapped(cell: TweetDetailCell) {
        replyTweet = tweet
    }
    
    func updateCellRetweetIconState(tweet: Tweet) {
        if tweet.isRetweeted! {
           // increaseRetweetCountAndImageColor(updatedCount: tweet.retweetCount)
        }
        else {
          //  decreaseRetweetCountandImageColor(updatedCount: tweet.retweetCount - 1)
        }
    }
    
    func updateCellFavIconState(tweet: Tweet) {
        if tweet.isFavorited! {
          //  increaseFavCountAndImageColor(updatedCount: tweet.favoritesCount)
            
        }else {
          //  decreaseFavCountandImageColor(updatedCount: tweet.favoritesCount)
        }
    }
//    
//    func decreaseFavCountandImageColor(updatedCount: Int) {
//        tweet?.favoritesCount = updatedCount
//        favCountLabel.text = String(describing: (tweet?.favoritesCount)!)
//        favButton.setImage(UIImage(named: "favgrey.png"), for: .normal)
//        isFavorited = false
//        
//    }
//    func increaseFavCountAndImageColor(updatedCount: Int) {
//        tweet?.favoritesCount = updatedCount
//        favCountLabel.text = String(describing: (tweet?.favoritesCount)!)
//        isFavorited = true
//        favButton.setImage(UIImage(named: "faved.png"), for: .normal)
//    }
//    
//    func decreaseRetweetCountandImageColor(updatedCount: Int) {
//        tweet?.retweetCount = updatedCount
//        retweetCountLabel.text = String(describing: (tweet?.retweetCount)!)
//    
//        retweetButton.setImage(UIImage(named: "rtgrey.png"), for: .normal)
//        isRetweeted = false
//        
//    }
//    func increaseRetweetCountAndImageColor(updatedCount: Int) {
//        tweet?.retweetCount = updatedCount
//        retweetCountLabel.text = String(describing: (tweet?.retweetCount)!)
//        isRetweeted = true
//        retweetButton.setImage(UIImage(named: "rted.png"), for: .normal)
//    }



}
