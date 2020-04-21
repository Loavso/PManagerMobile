//
//  AccountViewController.swift
//  PManager
//
//  Created by Lauryn Landkrohn on 4/18/20.
//  Copyright © 2020 Lauryn Landkrohn. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {
    
    @IBOutlet weak var oldPasswordContainer: UITextField!
    @IBOutlet weak var newPasswordContainer: UITextField!
    @IBOutlet weak var confirmPasswordContainer: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func DoChangePassword(_ sender: Any) {
        if(!oldPasswordContainer.text!.isEmpty &&
            !newPasswordContainer.text!.isEmpty &&
            !confirmPasswordContainer.text!.isEmpty)
        {
            changePassword(oldPassword: oldPasswordContainer.text!, newPassword: newPasswordContainer.text!, confirmPassword: confirmPasswordContainer.text!)
        }
    }
    
    func changePassword(oldPassword: String, newPassword:String, confirmPassword: String)
    {
        let cookie = HTTPCookieStorage.shared.cookies![0]
        ClientsAPI.authUserInfoGet(accessToken: cookie.value) { data, error in
            if(error == nil)
            {
                ClientsAPI.authChangePasswordPost(body: ChangePasswordRequest(username: (data?.username!)!, newPassword: newPassword, newPasswordConfirmation: confirmPassword, oldPassword: oldPassword, resetToken: ""), accessToken: cookie.value) { data, error in
                    if(error == nil)
                    {
                        print("Success")
                        self.oldPasswordContainer.text = ""
                        self.newPasswordContainer.text = ""
                        self.confirmPasswordContainer.text = ""
                    }
                    else
                    {
                        print("Error: \(error)")
                    }
                }
            }
            else
            {
                print("Error: \(error)")
            }
        }
    }
}
