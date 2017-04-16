//
//  TweetDetailCell.swift
//  TwitterDemo
//
//  Created by Angie Lal on 4/14/17.
//  Copyright © 2017 Angie Lal. All rights reserved.
//

import UIKit

class TweetDetailCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var replyImage: UIImageView!
    @IBOutlet weak var retweetImage: UIImageView!
    @IBOutlet weak var favImage: UIImageView!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favCountLabel: UILabel!
    @IBOutlet weak var retweeterLabel: UILabel!
    @IBOutlet weak var smallRetweetImage: UIImageView!
    @IBOutlet weak var timestampLabel: UILabel!
    
    var user: User?
    var tweet: Tweet?
    var isFavorited = false
    var isRetweeted = false

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
        self.favImage.image = UIImage(named: "favgrey.png")
        self.replyImage.image = UIImage(named: "replygrey.png")
        self.retweetImage.image = UIImage(named: "rtgrey.png")
        profileImage.layer.cornerRadius = 3
        profileImage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
