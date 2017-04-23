//
//  User.swift
//  TwitterDemo
//
//  Created by Angie Lal on 4/11/17.
//  Copyright © 2017 Angie Lal. All rights reserved.
//

import UIKit
import Foundation

class User: NSObject {

    var userId: Int?
    var name: NSString?
    var screenname: NSString?
    var profileUrl: NSURL?
    var tagline: NSString?
    var dictionary: NSDictionary?
    var followersCount: Int?
    var friendsCount: Int?
    var favoritesCount: Int?
    var tweetsCount: Int?
    var profileBannerUrl: URL?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        userId = dictionary["user_id"] as? Int
        
        name = dictionary["name"] as? NSString
        screenname = dictionary["screen_name"] as? NSString
        
        if let profileUrlString = dictionary["profile_image_url_https"] as? String {
            profileUrl = URL(string: profileUrlString) as NSURL?
        }

        if let profileBannerUrlString = dictionary["profile_banner_url"] as? String {
            profileBannerUrl = URL(string: profileBannerUrlString + "/600x200")
        }
        
        tagline = dictionary["description"] as? String as NSString?
        
        followersCount = dictionary["followers_count"] as? Int
        friendsCount = dictionary["friends_count"] as? Int
        favoritesCount = dictionary["favourites_count"] as? Int
        tweetsCount = dictionary["statuses_count"] as? Int

    }
    
    static let userDidLogoutNotification = "UserDidLogout"
    static var _currentUser: User?

    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: "currentUserData") as? Data
                if let userData = userData {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        set(user) {
            
            _currentUser = user
            let defaults = UserDefaults.standard
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.removeObject(forKey: "currentUserData")
            }
            defaults.synchronize()
        }
    }
}
