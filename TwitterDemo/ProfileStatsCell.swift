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
            tweetsCountLabel.text = String(describing: user?.tweetsCount! ?? 0)
            followingCountLabel.text = String(describing: user?.friendsCount! ?? 0)
            followersCountLabel.text = String(describing: user?.followersCount! ?? 0)
            
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
