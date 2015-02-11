//
//  ViewController.swift
//  linmo
//
//  Created by Jie on 2/6/15.
//  Copyright (c) 2015 Jie. All rights reserved.
//

import UIKit
import Haneke

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func facebookLogIn(sender: UIButton) {
        
        var permissions = ["public_profile", "user_birthday"]
        
        PFFacebookUtils.logInWithPermissions(permissions, {
            (user: PFUser!, error: NSError!) -> Void in
            if user == nil {
                NSLog("Uh oh. The user cancelled the Facebook login.")
            } else if user.isNew {
                NSLog("User signed up and logged in through Facebook!")
                self.performSegueWithIdentifier("signInToAlreadySegue", sender: self)
            } else {
                NSLog("User logged in through Facebook!")
                self.performSegueWithIdentifier("signInToAlreadySegue", sender: self)
            }
        })
        
        checkAndSaveUser()
    }
    
    /* Check whether the user already exist in Parse table. */
    func checkAndSaveUser() -> Void {
        var query = PFQuery(className: "User")
        
       //  query.whereKey("id", equalTo: )
    }
    
    /* Save user facebook data into Parse "User" table */
    func saveUserData() -> Void {
        var user = PFObject(className: "User")
        
        var request = FBRequest.requestForMe();
        request.startWithCompletionHandler { (connction, result, error) -> Void in
            if(error == nil) {
                var userData: NSDictionary = result as NSDictionary
                
                user["id"] = userData["id"] as NSString
                user["firstName"] = userData["first_name"] as NSString
                user["lastName"] = userData["last_name"] as NSString
                user["gender"] = userData["gender"] as NSString
                
                user.saveInBackgroundWithBlock({ (success:Bool, error: NSError!) -> Void in
                    if(success) {
                        println("User has been saved into Parse successfully.")
                    } else {
                        println("Failed to save user data into Parse.")
                    }
                })
            }
        }
        
    }
    
    
    /*
    In Parse:
    1. User Table: userid, username, gender, profileurl, fluentlanguagues, tolearnlanguagues, friendslist, blocklist
    2. (birthday, workandeducation, interests, photosurllist) : all these need to get review from facebook
    */
    func getUserData() -> Void {
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
                    /*
                    self.profileImageView.image = image
                    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.width / 2
                    self.profileImageView.clipsToBounds = true
                    self.profileImageView.layer.borderWidth = 0.3
                    */
                }
            }
        }
    }
}

