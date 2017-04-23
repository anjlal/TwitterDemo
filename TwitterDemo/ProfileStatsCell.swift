//
//  ProfileStatsCell.swift
//  TwitterDemo
//
//  Created by Angie Lal on 4/21/17.
//  Copyright © 2017 Angie Lal. All rights reserved.
//

import UIKit

class ProfileStatsCell: UITableViewCell {

    @IBOutlet weak var tweetsCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    

    var user: User? {
        didSet{

            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = NumberFormatter.Style.decimal
            tweetsCountLabel.text = numberFormatter.string(from: NSNumber(value: (user?.tweetsCount)!))
            followingCountLabel.text = numberFormatter.string(from: NSNumber(value: (user?.friendsCount)!))
            followersCountLabel.text = numberFormatter.string(from: NSNumber(value: (user?.followersCount)!))
            
            nameLabel.text = user?.name as String?

            if let screenname = user?.screenname {
                usernameLabel.text = String("@\(screenname)")
            }
            
            if let profileUrl = user?.profileUrl {
                self.profileImage.setImageWith(profileUrl as URL)
            }
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

}
