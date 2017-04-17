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

protocol ReplyDelegate {
    func replyButtonTapped(cell: TweetCell)
}

class TweetCell: UITableViewCell
{

    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var smallRetweetImage: UIImageView!
    @IBOutlet weak var retweeterLabel: UILabel!
    @IBOutlet weak var favCountLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    
    var favTweetDelegate: FavoriteDelegate?
    var retweetDelegate: RetweetDelegate?
    var replyDelegate: ReplyDelegate?
    
    var user: User?
    var tweet: Tweet?
    var isFavorited = false
    var isRetweeted = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImage.layer.cornerRadius = 3
        profileImage.clipsToBounds = true
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
            
            isRetweeted = (tweet?.isRetweeted as Bool?)!
            
            isFavorited = (tweet?.isFavorited as Bool?)!
            if isFavorited {
                favButton.setImage(UIImage(named: "faved.png"), for: .normal)
            }
            
            if isRetweeted {
                retweetButton.setImage(UIImage(named: "rted.png"), for: .normal)
            }
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
    
    func decreaseFavCountandImageColor(updatedCount: Int) {
        tweet?.favoritesCount = updatedCount
        //if ((tweet?.favoritesCount)! < 0) {
        //    favCountLabel.text = String(0)
        //} else {
            favCountLabel.text = String(describing: (tweet?.favoritesCount)!)
        //}
        favButton.setImage(UIImage(named: "favgrey.png"), for: .normal)
        isFavorited = false

    }
    func increaseFavCountAndImageColor(updatedCount: Int) {
        tweet?.favoritesCount = updatedCount
        favCountLabel.text = String(describing: (tweet?.favoritesCount)!)
        isFavorited = true
        favButton.setImage(UIImage(named: "faved.png"), for: .normal)
    }
    
    func decreaseRetweetCountandImageColor(updatedCount: Int) {
        tweet?.retweetCount = updatedCount
        //if ((tweet?.retweetCount)! < 0) {
        //    retweetCountLabel.text = String(0)
       // } else {
            retweetCountLabel.text = String(describing: (tweet?.retweetCount)!)
      //  }
        retweetButton.setImage(UIImage(named: "rtgrey.png"), for: .normal)
        isRetweeted = false
        
    }
    func increaseRetweetCountAndImageColor(updatedCount: Int) {
        tweet?.retweetCount = updatedCount
        retweetCountLabel.text = String(describing: (tweet?.retweetCount)!)
        isRetweeted = true
        retweetButton.setImage(UIImage(named: "rted.png"), for: .normal)
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
    @IBAction func onReply(_ sender: Any) {
        replyDelegate?.replyButtonTapped(cell: self)
    }

}
