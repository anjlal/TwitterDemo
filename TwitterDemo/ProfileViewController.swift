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
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
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
        
        self.headerHeightConstraint.constant = self.maxHeaderHeight
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
        
        if indexPath.row == 0 {
           let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileStatsCell", for: indexPath) as! ProfileStatsCell
            cell.user = userData
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
            cell.tweetData = tweets?[indexPath.row] ?? nil
            return cell
        }
    }
    
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

    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        print("YOOOOOO")
//           headerView.backgroundColor = UIColor(red: 0.11, green: 0.63, blue: 0.95, alpha: 1.0)
////        let v = UIView()
////        v.backgroundColor = .white
////        let segmentedControl = UISegmentedControl(frame: CGRect(x: 10, y: 5, width: tableView.frame.width - 20, height: 30))
////        segmentedControl.insertSegment(withTitle: "One", at: 0, animated: false)
////        segmentedControl.insertSegment(withTitle: "Two", at: 1, animated: false)
////        segmentedControl.insertSegment(withTitle: "Three", at: 2, animated: false)
////        v.addSubview(segmentedControl)
////        return v
//        return headerView
//    }

//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
