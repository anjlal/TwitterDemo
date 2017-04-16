//
//  TwitterClient.swift
//  TwitterDemo
//
//  Created by Angie Lal on 4/11/17.
//  Copyright © 2017 Angie Lal. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
        
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?

    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")! as URL!, consumerKey: valueForAPIKey(named:"CONSUMER_KEY"), consumerSecret: valueForAPIKey(named: "CONSUMER_SECRET"))
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()){
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            
            success(user)
        }, failure: { (task: URLSessionDataTask?, error: Error?) -> Void in
            failure(error!)
        })
    }
    
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()){
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetWithArray(dictionaries: dictionaries)
            success(tweets)
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            failure(error)
        })
    }
    
    func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance?.deauthorize()
        TwitterClient.sharedInstance?.fetchRequestToken(
            withPath: "oauth/request_token",
            method: "GET",
            callbackURL: NSURL(string: "mytwitterdemo://oauth") as URL!,
            scope: nil,
            success: { (requestToken: BDBOAuth1Credential?) -> Void in
                if let token = requestToken?.token {
                    let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(token)")!
                    
                    UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
                    print("\(token)")
                }
        }) { (error: Error?) -> Void in
            print("error: \(error?.localizedDescription)")
            self.loginFailure?(error!)
        }
    }
    
    func logout(){
        User.currentUser = nil
        deauthorize()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
    }
    
    func handleOpenUrl(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in
            self.currentAccount(success: { (user: User) in
                User.currentUser = user
                print("user: \(User.currentUser)")
                self.loginSuccess?()
            }, failure: { (error: Error) in
                self.loginFailure?(error)
            })
            
        }) { (error: Error?) in
            print("error: \(error!.localizedDescription)")
            self.loginFailure?(error!)
        }
    }
    
    func retweetMessage(_ id: Int, success: @escaping (Tweet) -> Void, failure: @escaping (NSError) -> Void){
        post("1.1/statuses/retweet/\(id).json", parameters: nil, progress: nil, success: { (operation, response) in
            let tweet = Tweet(dictionary: response as! NSDictionary)
            success(tweet)
        }) { (operation, error) in
            print("error when retweet: \(error.localizedDescription)")
            failure(error as NSError)
        }
    }
    
    func unretweetMessage(_ id: Int, success: @escaping (Tweet) -> Void, failure: @escaping (NSError) -> Void){
        post("1.1/statuses/unretweet/\(id).json", parameters: nil, progress: nil, success: { (operation, response) in
            let tweet = Tweet(dictionary: response as! NSDictionary)
            success(tweet)
        }) { (operation, error) in
            print("error when retweet: \(error.localizedDescription)")
            failure(error as NSError)
        }
    }
    
    func favoriteTweet(_ id: Int, success: @escaping (Tweet) -> Void, failure: @escaping (NSError) -> Void) {
        let parameters = ["id": id]
        post("1.1/favorites/create.json", parameters: parameters, progress: nil, success: { (operation, response) in
            let tweet = Tweet(dictionary: response as! NSDictionary)
            success(tweet)
        }) { (operation, error) in
            print("error when favorite a tweet: \(error.localizedDescription)")
            failure(error as NSError)
        }
    }
    
    func unfavoriteTweet(_ id: Int, success: @escaping (Tweet) -> Void, failure: @escaping (NSError) -> Void) {
        let parameters = ["id": id]
        
        post("1.1/favorites/destroy.json", parameters: parameters, progress: nil, success: { (operation, response) in
            let tweet = Tweet(dictionary: response as! NSDictionary)
            success(tweet)
        }) { (operation, error) in
            print("Failed to unfavorite tweet. \(error.localizedDescription)")
            failure(error as NSError)
        }
        
    }
    
    func postTweetMessage(_ tweetMessage: String!, in_reply_to_status_id: Int?, completionHandler: @escaping ([String: Any]) -> Void) {
        
        var parameters: [String: String] = ["status": tweetMessage]
        
        if let id = in_reply_to_status_id {
            parameters["in_reply_to_status_id"] = String(id)
        }
        
        post("1.1/statuses/update.json", parameters: parameters, progress: nil, success: { (operation, response) in
            completionHandler(["isSuccessful": true, "responseObject": response as Any])
        }) { (operation, error) in
            print("error when post a new tweet: \(error.localizedDescription)")
            completionHandler(["error": error.localizedDescription])
        }
        
    }
}
