//
//  ViewController.swift
//  LoginScreenApp
//


import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var username_input: UITextField!
    @IBOutlet var password_input: UITextField!
    @IBOutlet var login_button: UIButton!
    
    @IBOutlet var first_name_s_input: UITextField!
    @IBOutlet var last_name_s_input: UITextField!
    @IBOutlet var email_s_input: UITextField!
    @IBOutlet var username_s_input: UITextField!
    @IBOutlet var password_s_input: UITextField!
    @IBOutlet var password_confirm_s_input: UITextField!
    @IBOutlet var sign_up_button: UIButton!
    
    
    var login_session:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func unwind(_ segue: UIStoryboardSegue) {}
    
    @IBAction func DoLogin(_ sender: AnyObject) {
        login_now(username:username_input.text!, password: password_input.text!)
    }
    
    
    func login_now(username:String, password:String)
    {
        ClientsAPI.authLoginPost(body: LoginRequest(username: username, password: password)){data, error in
            if(error == nil)
            {
                print(HTTPCookieStorage.shared.cookies!)
                self.performSegue(withIdentifier: "EnterApp", sender: self)
            }
            else
            {
                print("error: \(String(describing: error))")
            }
        }
        
    }

    @IBAction func DoSignUp(_ sender: AnyObject) {
        if(!(first_name_s_input.text!).isEmpty &&
            !(last_name_s_input.text!).isEmpty &&
            !(email_s_input.text!).isEmpty &&
            !(username_s_input.text!).isEmpty &&
            !(password_s_input.text!).isEmpty &&
            !(password_confirm_s_input.text!).isEmpty)
        {
            signup_now(firstName: first_name_s_input.text!, lastName: last_name_s_input.text!, email: email_s_input.text!, username: username_s_input.text!, password: password_s_input.text!, passwordConfirm: password_confirm_s_input.text!)
        }
        // else make needed feilds red
    }
    
    func signup_now(firstName:String, lastName:String, email:String, username:String, password:String, passwordConfirm:String)
    {
        ClientsAPI.authSignupPost(body: SignUpRequest(firstName: firstName, lastName: lastName, email: email, username: username, password: password, passwordConfirmation: passwordConfirm)){data, error in
            if(error == nil)
            {
                self.performSegue(withIdentifier: "unwindToSignIn", sender: self)
            }
            else
            {
                print("error: \(String(describing: error))")
            }
        }
    }
}

extension UITextField{
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }

    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        self.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction()
    {
        self.resignFirstResponder()
    }
}
