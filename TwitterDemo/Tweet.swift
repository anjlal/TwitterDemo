//
//  Tweet.swift
//  TwitterDemo
//
//  Created by Angie Lal on 4/11/17.
//  Copyright © 2017 Angie Lal. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var text: NSString?
    var timestamp: NSDate?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    
    init(dictionary: NSDictionary) {
        let userDictionary = dictionary["user"] as? NSDictionary
        if let userDictionary = userDictionary {
            user = User(dictionary: userDictionary)
        }
        text = (dictionary["text"] as? NSString?)!
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favorites_count"] as? Int) ?? 0
        
        let timestampString = dictionary["created_at"] as? String

        if let timestampString = timestampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampString) as NSDate?
        }
        
    }
    
    class func tweetWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictonary in dictionaries {
            let tweet = Tweet(dictionary: dictonary)
            tweets.append(tweet)
        }
        return tweets
    }
}
