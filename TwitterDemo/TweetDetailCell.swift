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
    
    var tweetData: Tweet? {
        didSet{
            let user = tweetData?.user
            nameLabel.text = tweetData?.user?.name as String?
            tweetLabel.text = tweetData?.text as String?
            
            if let profileUrl = user?.profileUrl {
                self.profileImage.setImageWith(profileUrl as URL)
            }
            
            if let screenname = user?.screenname {
                screennameLabel.text = String("@\(screenname)")
            }
    
//            if let since = tweetData?.timestamp?.timeIntervalSinceNow {
//                let hours = round(since / 3600.0) * -1.0
//                if hours < 24 {
//                    timestampLabel.text = "\(Int(hours))H"
//                } else {
//                    timestampLabel.text = "\(tweetData?.timestamp)"
//                }
//            }
            
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
