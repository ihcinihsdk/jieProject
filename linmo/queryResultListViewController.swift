//
//  queryResultListViewController.swift
//  linmo
//
//  Created by Jie on 2/9/15.
//  Copyright (c) 2015 Jie. All rights reserved.
//

import Foundation
import UIKit
import Haneke

class queryResultListViewController : UIViewController {
    
    var profileImageView: UIImageView!
    
    override func viewDidLoad() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: "logout")
        
        profileImageView = UIImageView()
        profileImageView.frame = CGRect(x: view.frame.width / 2 - 50, y: 80, width: 100, height: 100)
        profileImageView.contentMode = .ScaleAspectFit
        view.addSubview(profileImageView)
        
        getUserData()

    }
    
    
    /*
        In Parse:
        1. User Table: userid, username, gender, birthday, profileurl, fluentlanguagues, tolearnlanguagues, friendslist, blocklist
        2. (workandeducation, interests, photosurllist) : all these need to get review from facebook
    */
    func getUserData() {
        var request = FBRequest.requestForMe();
        request.startWithCompletionHandler { (connction, result, error) -> Void in
            if(error == nil) {
                var userData: NSDictionary = result as NSDictionary
                
                var userId: NSString = userData["id"] as NSString
                var userName: NSString = userData["name"] as NSString
                var userGender: NSString = userData["gender"] as NSString
                
                var userPicUrlString: NSString = NSString(format: "https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", userId)
                var userPicUrl: NSURL = NSURL(string: userPicUrlString)!
                
                let cache = Shared.imageCache
                let fetcher = NetworkFetcher<UIImage>(URL: userPicUrl)
                cache.fetch(fetcher: fetcher).onSuccess { image in
                    self.profileImageView.image = image
                    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.width / 2
                    self.profileImageView.clipsToBounds = true
                    self.profileImageView.layer.borderWidth = 0.3
                }
            }
        }
    }
    
    func logout() {
        PFUser.logOut()
    }
    
}




