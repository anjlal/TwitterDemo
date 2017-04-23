//
//  ProfileViewController.swift
//  TwitterDemo
//
//  Created by Angie Lal on 4/20/17.
//  Copyright © 2017 Angie Lal. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var profileBannerImage: UIImageView!
   // @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var profileDescriptionLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tweetsCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var headerView: UIView!
    let maxHeaderHeight: CGFloat = 160
    let minHeaderHeight: CGFloat = 80
    var previousScrollOffset: CGFloat = 0
    var tweets: [Tweet]!
    var userScreenname: String?
    var bannerUrl: URL?
    var userData: User? {
        didSet {
            reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.navigationController?.navigationBar.tintColor = UIColor(red: 0.11, green: 0.63, blue: 0.95, alpha: 1.0)
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor(red: 0.11, green: 0.63, blue: 0.95, alpha: 1.0)]
        
        //scrollView.delegate = self
        //scrollView.contentSize = CGSize(width: self.view.bounds.width * 2, height: 33)
//        scrollView.contentSize = CGSize(width:self.scrollView.frame.width * 4, height:self.scrollView.frame.height)
//        scrollView.isPagingEnabled = true
//        scrollView.showsHorizontalScrollIndicator = false
//        scrollView.addSubview(profileDescriptionLabel)
        pageControl.currentPage = 0
        
        setup()
        
        //self.headerHeightConstraint.constant = self.maxHeaderHeight

        //profileBannerImage.setImageWith(userData?.profileBannerUrl as! URL)
        
//        self.automaticallyAdjustsScrollViewInsets = false
//        
//        let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100))
//        header.backgroundColor = .red
//        tableView.tableHeaderView = header
        
        if bannerUrl !=  nil {
            profileBannerImage.setImageWith(bannerUrl!)
        }

        userData = userData ?? User.currentUser
        userScreenname = userScreenname ?? User.currentUser?.screenname! as String?
        
        reloadData()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
    
    func setup() {
        
        profileImage.layer.cornerRadius = 3
        profileImage.clipsToBounds = true
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        if userData == nil {
            userData = User.currentUser
        }
        tweetsCountLabel.text = numberFormatter.string(from: NSNumber(value: (userData?.tweetsCount)!))
        followingCountLabel.text = numberFormatter.string(from: NSNumber(value: (userData?.friendsCount)!))
        followersCountLabel.text = numberFormatter.string(from: NSNumber(value: (userData?.followersCount)!))
        
        nameLabel.text = userData?.name as String?
        profileDescriptionLabel.text = userData?.tagline as String? ?? ""
        profileDescriptionLabel.isHidden = true
        
        if let screenname = userData?.screenname {
            usernameLabel.text = String("@\(screenname)")
        }
        
        if let profileUrl = userData?.profileUrl {
            self.profileImage.setImageWith(profileUrl as URL)
        }
    }

    func fetchUserTimeline() {
        TwitterClient.sharedInstance?.userTimeline(userScreenname!, success: { (tweets: [Tweet]) in
            self.tweets = tweets
            for tweet in tweets {
                print(tweet.text!)
            }
            
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(ProfileViewController.refreshControlAction(_:)), for: UIControlEvents.valueChanged)
            
            // add refresh control to table view
            self.tableView.insertSubview(refreshControl, at: 0)
            // Reload the tableView now that there is new data
            self.tableView.reloadData()
            
        }, failure: { (error: Error) in
            print("error: \(error.localizedDescription)")
        })
    }
    
    func reloadData() {
        if let udata = userData {
            userScreenname = udata.screenname! as String
            bannerUrl = udata.profileBannerUrl
            
            fetchUserTimeline()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
        cell.tweetData = tweets?[indexPath.row] ?? nil
        cell.user = userData
        return cell
    }
    @IBAction func onPage(_ sender: Any) {
        
        if self.pageControl.currentPage == 0 {
            UIView.transition(with: nameLabel,
                              duration: 0.5,
                              options: [.transitionFlipFromRight],
                              animations: {
                                self.nameLabel.isHidden = false
                                self.usernameLabel.isHidden = false
                                self.profileDescriptionLabel.isHidden = true
            }, completion: nil)

        } else {
            UIView.transition(with: profileDescriptionLabel,
                              duration: 0.5,
                              options: [.transitionFlipFromLeft],
                              animations: {
                                
                                self.nameLabel.isHidden = true
                                self.usernameLabel.isHidden = true
                                self.profileDescriptionLabel.isHidden = false
            }, completion: nil)
        }
       
        
        
//                                let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
//                                let blurEffectView = UIVisualEffectView(effect: blurEffect)
//                                blurEffectView.frame = self.profileBannerImage.bounds
//                                blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//                                self.profileBannerImage.addSubview(blurEffectView)
       

    }
//    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        // Test the offset and calculate the current page after scrolling ends
//        let pageWidth:CGFloat = scrollView.frame.width
//        let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
//        // Change the indicator
//        self.pageControl.currentPage = Int(currentPage);
//        // Change the text accordingly
//        if Int(currentPage) == 0{
//            profileDescriptionLabel.text = ""
//        }else  {
//            profileDescriptionLabel.text = userData?.tagline as String? ?? ""
//        }
//    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        
        TwitterClient.sharedInstance?.userTimeline(userScreenname!, success: { (tweets: [Tweet]) in
            self.tweets = tweets
            // Reload the tableView now that there is new data
            self.tableView.reloadData()
            
            // Tell the refreshControl to stop spinning
            refreshControl.endRefreshing()
            
        }, failure: { (error: Error) in
            print("error: \(error.localizedDescription)")
        })
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
