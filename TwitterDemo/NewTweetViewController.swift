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
    var delegate: AddTweetDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        
        nameLabel.text = user?.name as String?
        screennameLabel.text = "@\(user?.screenname as String? ?? "")"
        if let profileUrl = user?.profileUrl {
            self.profileImage.setImageWith(profileUrl as URL)
        }
        profileImage.layer.cornerRadius = 3
        profileImage.clipsToBounds = true
        //textField.becomeFirstResponder()
        
        textView.text = "What's happening?"
        textView.font = UIFont(name: (textView.font?.fontName)!, size: 17)
        textView.textColor = .lightGray
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    
//    func setupCharCounterLabelInNavBar() {
//        if let navigationBar = self.navigationController?.navigationBar {
//            
//            charCounterLabel = UILabel(frame: CGRect(x: navigationBar.frame.width-120, y: (navigationBar.frame.height - 20)/2, width: 40, height: 20))
//            charCounterLabel.text = "140"
//            charCounterLabel.textColor = UIColor(red: 242/255, green: 239/255, blue: 239/255, alpha: 1)
//            charCounterLabel.font = UIFont(name: charCounterLabel.font.fontName, size: 14)
//            navigationBar.addSubview(charCounterLabel)
//            
//        }
//    }
//    
//    func removeCharCountLabel() {
//        charCounterLabel.removeFromSuperview()
//    }

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
        
        // post message
        TwitterClient.sharedInstance?.postTweetMessage(textView.text!, in_reply_to_status_id: nil, completionHandler: { (response) in
            if (response["isSuccessful"] != nil) {
                let newTweet = self.addNewTweet()
                self.delegate?.addTweet(tweet:newTweet)
                self.navigationController?.popViewController(animated: true)
            }
            else{
                print("could not post tweet")
            }
        })
        
    }
    
    @IBAction func onCancel(_ sender: Any) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
               print("here")
        }
     
    }

}

extension NewTweetViewController {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        guard let text = textView.text else { return true }
        let length = text.characters.count + text.characters.count - range.length
        
        let count = 140 - length
        
        // set the .text property of your UILabel to the live created String
        charCountDownLabel.text = String(count)
        
        // if you want to limit to 140 charakters
        // you need to return true and <= 140
        
        return length <= 140 // To just allow up to 140 characters
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
}
