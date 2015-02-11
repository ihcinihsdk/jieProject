//
//  LoginJudgeController.swift
//  linmo
//
//  Created by Jie on 2/7/15.
//  Copyright (c) 2015 Jie. All rights reserved.
//

import UIKit

class LoginJudgeViewController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if(PFUser.currentUser() != nil && PFFacebookUtils.isLinkedWithUser(PFUser.currentUser())) {
            self.performSegueWithIdentifier("alreadySignInSegue", sender: self)
        } else {
            self.performSegueWithIdentifier("signInSegue", sender: self)
        }
    }
}