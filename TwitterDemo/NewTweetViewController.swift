//
//  NewTweetViewController.swift
//  TwitterDemo
//
//  Created by Angie Lal on 4/15/17.
//  Copyright © 2017 Angie Lal. All rights reserved.
//

import UIKit

class NewTweetViewController: UIViewController {

    @IBOutlet weak var charCountDownLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        
        nameLabel.text = user?.name as String?
        screennameLabel.text = user?.screenname as String?
        if let profileUrl = user?.profileUrl {
            self.profileImage.setImageWith(profileUrl as URL)
        }
        profileImage.layer.cornerRadius = 3
        profileImage.clipsToBounds = true
        textField.becomeFirstResponder()
        
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

}

extension NewTweetViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else { return true }
        let length = text.characters.count + string.characters.count - range.length
        
        let count = 140 - length
        
        // set the .text property of your UILabel to the live created String
        charCountDownLabel.text = String(count)
        
        // if you want to limit to 140 charakters
        // you need to return true and <= 140
        
        return length <= 140 // To just allow up to 140 characters
    }
    
}
