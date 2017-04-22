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
    

    var userData: User? {
        didSet{
            tweetsCountLabel.text = String(describing: userData?.tweetsCount! ?? 0)
            followingCountLabel.text = String(describing: userData?.friendsCount! ?? 0)
            followersCountLabel.text = String(describing: userData?.followersCount! ?? 0)
            
            nameLabel.text = userData?.name as String?

            if let screenname = userData?.screenname {
                usernameLabel.text = String("@\(screenname)")
            }
            
            if let profileUrl = userData?.profileUrl {
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
