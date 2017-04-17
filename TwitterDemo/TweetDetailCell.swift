//
//  TweetDetailCell.swift
//  TwitterDemo
//
//  Created by Angie Lal on 4/14/17.
//  Copyright © 2017 Angie Lal. All rights reserved.
//

import UIKit

protocol TweetDetailViewRetweetDelegate {
    func updateCellRetweetIconState(tweet: Tweet)
}

protocol TweetDetailViewFavDelegate {
    func updateCellFavIconState(tweet: Tweet)
}

protocol ReplyFromDetailDelegate {
    func replyButtonTapped(cell: TweetDetailCell)
}

class TweetDetailCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favCountLabel: UILabel!
    @IBOutlet weak var retweeterLabel: UILabel!
    @IBOutlet weak var smallRetweetImage: UIImageView!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favButton: UIButton!
    
    var user: User?
    var tweet: Tweet?
    var isFavorited = false
    var isRetweeted = false
    
    var replyDelegate: ReplyFromDetailDelegate?
    var tweetDetailRetweetDelegate: TweetDetailViewRetweetDelegate?
    var tweetDetailFavDelegate: TweetDetailViewFavDelegate?
    
    var count = 0

    var tweetData: Tweet? {
        didSet{
            if let retweetedStatus = tweetData?.retweetedStatus {
                smallRetweetImage.isHidden = false
                smallRetweetImage.image = UIImage(named: "rtgrey.png")
                retweeterLabel.text = "\(tweetData?.user?.screenname as String? ?? "") retweeted"
                retweeterLabel.isHidden = false
                tweet = Tweet(dictionary: retweetedStatus)
                user = User(dictionary: retweetedStatus["user"] as! NSDictionary)
            } else {
                if tweetData?.user != nil {
                    user = (tweetData?.user)!
                    tweet = tweetData!
                    retweeterLabel.isHidden = true
                    smallRetweetImage.isHidden = true
                    
                }
            }
            
            nameLabel.text = user?.name as String?
            tweetLabel.text = tweet?.text as String?
            favCountLabel.text = String(describing: tweet?.favoritesCount ?? 0)
            retweetCountLabel.text = String(describing: tweet?.retweetCount ?? 0)
            
            isFavorited = (tweet?.isFavorited!)!
            if isFavorited {
                favButton.setImage(UIImage(named: "faved.png"), for: .normal)
            } else {
                favButton.setImage(UIImage(named: "favgrey.png"), for: .normal)
            }
            
            isRetweeted = (tweet?.isRetweeted!)!
            if isRetweeted {
                retweetButton.setImage(UIImage(named: "rted.png"), for: .normal)

            } else {
                retweetButton.setImage(UIImage(named: "rtgrey.png"), for: .normal)
            }


            if let profileUrl = user?.profileUrl {
                self.profileImage.setImageWith(profileUrl as URL)
            }
            
            if let screenname = user?.screenname {
                screennameLabel.text = String("@\(screenname)")
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = DateFormatter.Style.short
            dateFormatter.dateStyle = DateFormatter.Style.short
            timestampLabel.text = dateFormatter.string(from: tweetData?.timestamp! as! Date)
            
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImage.layer.cornerRadius = 3
        profileImage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onRetweet(_ sender: Any) {

        if isRetweeted {
            TwitterClient.sharedInstance?.unretweetMessage((tweet?.id!)!, success: { (tweet) in
                DispatchQueue.main.async {
                    tweet.isRetweeted = false
                    self.isRetweeted = false
                    self.retweetCountLabel.text =  String(tweet.retweetCount - 1)
                    self.retweetButton.setImage(UIImage(named: "rtgrey.png"), for: .normal)
                    self.tweetDetailRetweetDelegate?.updateCellRetweetIconState(tweet: tweet)
                }
                
            }, failure: { (error) in
                print(error)
            })
            
        }else {
            TwitterClient.sharedInstance?.retweetMessage((tweet?.id!)!, success: { (tweet) in
                DispatchQueue.main.async {
                    tweet.isRetweeted = true
                    self.isRetweeted = true
                    self.retweetCountLabel.text =  String(tweet.retweetCount)
                    self.retweetButton.setImage(UIImage(named: "rted"), for: .normal)
                    self.tweetDetailRetweetDelegate?.updateCellRetweetIconState(tweet: tweet)
                }
            }, failure: { (error) in
                print(error)
            })
        }
    }
    
    @IBAction func onFavorite(_ sender: Any) {

        if isFavorited {
            TwitterClient.sharedInstance?.unfavoriteTweet((tweet?.id!)!, success: { (tweet) in
                DispatchQueue.main.async {
                    tweet.isFavorited = false
                    self.isFavorited = false
                    self.favCountLabel.text =  String(tweet.favoritesCount)
                    self.favButton.setImage(UIImage(named: "favgrey.png"), for: .normal)
                    self.tweetDetailFavDelegate?.updateCellFavIconState(tweet: tweet)
                }
            }, failure: { (error) in
                print(error)
            })
        }
        else {
            TwitterClient.sharedInstance?.favoriteTweet((tweet?.id!)!, success: { (tweet) in
                DispatchQueue.main.async {
                    tweet.isFavorited = true
                    self.isFavorited = true
                    self.favCountLabel.text =  String(tweet.favoritesCount)
                    self.favButton.setImage(UIImage(named: "faved.png"), for: .normal)
                    self.tweetDetailFavDelegate?.updateCellFavIconState(tweet: tweet)
                }
            }, failure: { (error) in
                print(error)
            })
        }
    }
    
    @IBAction func onReply(_ sender: Any) {
        replyDelegate?.replyButtonTapped(cell: self)
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //if segue.identifier == "ReplyTweet" {
          //  let vc = segue.destination as! NewTweetViewController
            //vc.tweet = tweet
      //  }
    }
    
}
