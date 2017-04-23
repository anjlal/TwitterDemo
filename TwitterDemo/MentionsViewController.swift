//
//  MentionsViewController.swift
//  TwitterDemo
//
//  Created by Angie Lal on 4/22/17.
//  Copyright © 2017 Angie Lal. All rights reserved.
//

import UIKit

class MentionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tweets: [Tweet]?
    
    @IBOutlet weak var tableView: UITableView!
    
    // Refresh control for table view
    let refreshControl = UIRefreshControl()
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("TweetCell2", owner: self, options: nil)?.first as! TweetCell2
        cell.tweetData = tweets?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let tweets = tweets {
            return tweets.count
        } else {
            return 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Add refresh control to table view
        refreshControl.addTarget(self, action: #selector(fetchMentionsTimeline), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        fetchMentionsTimeline()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func fetchMentionsTimeline() {
        
        TwitterClient.sharedInstance?.mentionsTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            print("got the data")
        }, failure: { (error: Error) in
            print("error: \(error.localizedDescription)")
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
