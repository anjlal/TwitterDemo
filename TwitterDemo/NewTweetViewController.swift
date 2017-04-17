//
//  NewTweetViewController.swift
//  TwitterDemo
//
//  Created by Angie Lal on 4/15/17.
//  Copyright © 2017 Angie Lal. All rights reserved.
//

import UIKit

protocol AddTweetDelegate {
    func addTweet(tweet: Tweet)
}

class NewTweetViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var charCountDownLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    var user: User?
    var replyToUser: Int?
    var screenname: String?
    
    var delegate: AddTweetDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        
         self.navigationController?.navigationBar.tintColor = UIColor(red: 0.11, green: 0.63, blue: 0.95, alpha: 1.0)
        
        let logo = UIImage(named: "logo.png")
        let imageView = UIImageView(image: logo)
        imageView.contentMode = .scaleAspectFit // set imageview's content mode
        self.navigationItem.titleView = imageView
        
        nameLabel.text = user?.name as String?
        screennameLabel.text = "@\(user?.screenname as String? ?? "")"
        if let profileUrl = user?.profileUrl {
            self.profileImage.setImageWith(profileUrl as URL)
        }
        profileImage.layer.cornerRadius = 3
        profileImage.clipsToBounds = true
        
        if let screenname = screenname {
            textView.textColor = .black
            textView.text = "@\(screenname)"
        } else {
            textView.text = "What's happening?"
        }
        textView.font = UIFont(name: (textView.font?.fontName)!, size: 17)
        textView.textColor = .lightGray
        
        navigationItem.rightBarButtonItem?.isEnabled = false

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func addNewTweet() -> Tweet {
        let currentUser = User.currentUser
        
        let userDictionary = ["name": currentUser?.name, "screen_name": currentUser?.screenname, "profile_image_url_https": currentUser?.profileUrl, "description": currentUser?.tagline]
        let user = User(dictionary: userDictionary as NSDictionary)
        
        let tweetDictionary = ["text": textView.text, "created_at": Date(), "retweet_count": 0, "favorite_count": 0, "user": user] as [String : Any]
        let newTweet = Tweet(dictionary: tweetDictionary as NSDictionary)
        return newTweet
    }
    
    @IBAction func onTweet(_ sender: Any) {
        let statusId = replyToUser ?? nil
        // post message
        TwitterClient.sharedInstance?.postTweetMessage(textView.text!, in_reply_to_status_id: statusId, completionHandler: { (response) in
            if (response["isSuccessful"] != nil) {
                let newTweet = self.addNewTweet()
                self.delegate?.addTweet(tweet:newTweet)
                self.dismiss(animated: true, completion: nil)
            }
            else{
                print("could not post tweet")
            }
        })
        
    }
    
    @IBAction func onCancel(_ sender: Any) {
        textView.resignFirstResponder()
        dismiss(animated: true, completion: nil)
     
    }

}

extension NewTweetViewController {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if(text == "\n") {
//            if let screenname = screenname {
//               // textView.textColor = .black
//               // textView.text = "@\(screenname)"
//            }
            textView.resignFirstResponder()
            return false
        }
        var screennameLen = 0
        //guard let text = textView.text else { return true }
        if let screenname = screenname {
            screennameLen = screenname.characters.count + 2
        }
        let length = text.characters.count - range.length - screennameLen
                // if you want to limit to 140 charakters
        // you need to return true and <= 140
        return length <= 140 // To just allow up to 140 characters
    }
    
    func textViewDidChange(_ textView: UITextView) {
        var screennameLen = 0
        if let screenname = screenname {
            screennameLen = screenname.characters.count + 2
        }
        let len = textView.text.characters.count - screennameLen
        if len < 0 {
            charCountDownLabel.text = String(140)
        } else {
            charCountDownLabel.text = String(format:"%i", (140-len))
            if len > 140 {
                charCountDownLabel.textColor = UIColor.red
                self.navigationItem.rightBarButtonItem?.isEnabled = false
            } else if len == 0 || textView.text == "What's happening?" {
                charCountDownLabel.textColor = UIColor.darkGray
                self.navigationItem.rightBarButtonItem?.isEnabled = false
            } else {
                charCountDownLabel.textColor = UIColor.darkGray
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            }
        }
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            if let screenname = screenname {
                textView.text = "@\(screenname)"
            } else {
               textView.text = ""
            }
            textView.textColor = .black
        }
    }
    

    
}
