//
//  ProfileCell.swift
//  TwitterDemo
//
//  Created by Angie Lal on 4/21/17.
//  Copyright © 2017 Angie Lal. All rights reserved.
//

import UIKit
import AFNetworking

class ProfileCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var smallRetweetImage: UIImageView!
    @IBOutlet weak var retweeterLabel: UILabel!
    @IBOutlet weak var favCountLabel: UILabel!
    
    
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
        
        var days = 0
        var hours = 0
        var minutes = 0
        var seconds = 0
        
        // Date() By itself will give us "now" date
        let now = Date()
        
        // We can ask the calendar to give us the hours and minutes between now and the date we parsed
        
        // Calendar can do all kinds of things with dates
        let calendar = Calendar(identifier: .gregorian)
        
        let components = calendar.dateComponents([.day, .hour, .minute, .second], from: date, to: now)
        
        // If getting the hours was succesful we can use them
        
        if components.day != nil {
            days = components.day!
        }
        
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
        
        let time = (days, hours, minutes, seconds)
        
        switch time {
        case let (days, hours, _, _) where (hours >= 24):
            return "\(days)d \(hours)h"
        case let (_, hours, minutes, _) where (hours > 0 && hours < 24 && minutes == 0):
            return "\(hours)h"
        case let (_, hours, minutes, _) where (hours == 0 && minutes > 0):
            return "\(minutes)m"
        case let (_, hours, minutes, seconds) where (hours == 0 && minutes == 0 && seconds > 0):
            return "\(seconds)s"
        default:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yy"
            let dateString = dateFormatter.string(from: date)
            return dateString
            
        }
    }

}
