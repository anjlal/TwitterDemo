//
//  TweetCell.swift
//  TwitterDemo
//
//  Created by Angie Lal on 4/12/17.
//  Copyright © 2017 Angie Lal. All rights reserved.
//

import UIKit
import AFNetworking

protocol FavoriteDelegate {
    func favoritedTweet(tweet: Tweet, cell: TweetCell)
    func unfavoritedTweet(tweet: Tweet, cell: TweetCell)
}

protocol  RetweetDelegate {
    func retweetedTweet(tweet: Tweet, cell: TweetCell)
    func unretweetedTweet(tweet: Tweet, cell: TweetCell)
}

class TweetCell: UITableViewCell {
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var retweetImage: UIImageView!
    @IBOutlet weak var replyImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var smallRetweetImage: UIImageView!
    @IBOutlet weak var retweeterLabel: UILabel!
    @IBOutlet weak var favCountLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    
    var favTweetDelegate: FavoriteDelegate?
    var retweetDelegate: RetweetDelegate?
    
    var user: User?
    var tweet: Tweet?
    var isFavorited = false
    var isRetweeted = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImage.layer.cornerRadius = 3
        profileImage.clipsToBounds = true

        replyImage.image = UIImage(named: "replygrey.png")
    }
    
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
            
            isFavorited = (tweet?.isFavorited as Bool?)!
            
            if let profileUrl = user?.profileUrl {
                self.profileImage.setImageWith(profileUrl as URL)
            }
            
            if let screenname = user?.screenname {
                usernameLabel.text = String("@\(screenname)")
            }
           
            timestampLabel.text = timestampConverter(date: tweetData?.timestamp! as! Date)
            


        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func timestampConverter(date: Date) -> String {
        
        var hours = 0
        var minutes = 0
        var seconds = 0
        
        // Date() By itself will give us "now" date
        let now = Date()
        
        // We can ask the calendar to give us the hours and minutes between now and the date we parsed
        
        // Calendar can do all kinds of things with dates
        let calendar = Calendar(identifier: .gregorian)
        
        let components = calendar.dateComponents([.hour, .minute, .second], from: date, to: now)
        
        // If getting the hours was succesful we can use them
        if  components.hour != nil {
            hours = components.hour!
        }
        
        // same with minutes
        if components.minute != nil {
            minutes = components.minute!
        }
        
        if components.second != nil {
            seconds = components.second!
        }
            
        let time = (hours, minutes, seconds)
        
        switch time {
        case let (hours, minutes, _) where (hours > 0 && minutes > 0):
            return "\(hours)h \(minutes)m"
        case let (hours, minutes, _) where (hours > 0 && minutes == 0):
            return "\(hours)h"
        case let (hours, minutes, _) where (hours == 0 && minutes > 0):
            return "\(minutes)m"
        case let (hours, minutes, seconds) where (hours == 0 && minutes == 0 && seconds > 0):
            return "\(seconds)s"
        default:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yy"
            let dateString = dateFormatter.string(from: date)
            return dateString
            
        }
    }
    
    func decreaseFavCountandImageColor() {
        if ((tweet?.favoritesCount)! - 1 < 0) {
            favCountLabel.text = String(0)
        } else {
            favCountLabel.text = String((tweet?.favoritesCount)! - 1)
        }
        isFavorited = false

    }
    func increaseFavCountAndImageColor() {
        favCountLabel.text = String((tweet?.favoritesCount)! + 1)
        isFavorited = true
        //likeButton.setImage(UIImage(named: "like-red"), for: .normal)
    }
    
    func decreaseRetweetCountandImageColor() {
        if ((tweet?.retweetCount)! - 1 < 0) {
            retweetCountLabel.text = String(0)
        } else {
            retweetCountLabel.text = String((tweet?.retweetCount)! - 1)
        }
        isRetweeted = false
        
    }
    func increaseRetweetCountAndImageColor() {
        retweetCountLabel.text = String((tweet?.retweetCount)! + 1)
        isRetweeted = true
        //likeButton.setImage(UIImage(named: "like-red"), for: .normal)
    }

    
    @IBAction func onFavorite(_ sender: Any) {
        if isFavorited {
            self.favTweetDelegate?.unfavoritedTweet(tweet: tweetData!, cell: self)
        } else {
            self.favTweetDelegate?.favoritedTweet(tweet: tweetData!, cell: self)
        }
    }
    @IBAction func onRetweet(_ sender: Any) {
        if isRetweeted {
            self.retweetDelegate?.unretweetedTweet(tweet: tweetData!, cell: self)
        } else {
            self.retweetDelegate?.retweetedTweet(tweet: tweetData!, cell: self)
        }
    }

}
