//
//  TweetCell.swift
//  TwitterDemo
//
//  Created by Angie Lal on 4/12/17.
//  Copyright © 2017 Angie Lal. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    @IBOutlet weak var usernameLabel: UILabel!

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var tweetLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var tweetData: Tweet? {
        didSet{
            let user = tweetData?.user
            self.tweetLabel.text = self.tweetData?.text as String?
            
            if let profileUrl = user?.profileUrl{
                self.profileImage.setImageWith(profileUrl as URL)
            }

        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
