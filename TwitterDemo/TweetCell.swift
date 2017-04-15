//
//  TweetCell.swift
//  TwitterDemo
//
//  Created by Angie Lal on 4/12/17.
//  Copyright © 2017 Angie Lal. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var favoriteImage: UIImageView!
    @IBOutlet weak var retweetImage: UIImageView!
    @IBOutlet weak var replyImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var smallRetweetImage: UIImageView!
    @IBOutlet weak var retweeterLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImage.layer.cornerRadius = 3
        profileImage.clipsToBounds = true
        smallRetweetImage.image = UIImage(named: "rtgrey.png")
        retweetImage.image = UIImage(named: "rtgrey.png")
        replyImage.image = UIImage(named: "replygrey.png")
        favoriteImage.image = UIImage(named: "favgrey.png")
    }
    
    var tweetData: Tweet? {
        didSet{
            let user = tweetData?.user
            
            nameLabel.text = tweetData?.user?.name as String?
            tweetLabel.text = tweetData?.text as String?
            
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
            //print("\(minutes) minutes ago")
        }
        
        if components.second != nil {
            seconds = components.second!
            //print("\(seconds) seconds ago")
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

}
