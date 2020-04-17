//
//  ViewController.swift
//  LoginScreenApp
//


import UIKit

class ViewController: UIViewController {

    
    let login_url = "http://34.73.25.235/auth/login"
    let checksession_url = "http://www.kaleidosblog.com/tutorial/login/api/CheckSession"
    let clientAPI = ClientsAPI()

    
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
        
        
        let preferences = UserDefaults.standard
//        if preferences.object(forKey: "access_token") != nil
//        {
//            login_session = preferences.object(forKey: "access_token") as! String
//            check_session()
//        }
//        else
//        {
//            LoginToDo()
//        }


    }

    @IBAction func unwind(_ segue: UIStoryboardSegue) {}
    
    @IBAction func DoLogin(_ sender: AnyObject) {
       
        if(login_button.titleLabel?.text == "Logout")
        {
            let preferences = UserDefaults.standard
            preferences.removeObject(forKey: "session")
            
            LoginToDo()
        }
        else{
            login_now(username:username_input.text!, password: password_input.text!)
        }
        
    }
    
    
    func login_now(username:String, password:String)
    {
        ClientsAPI.authLoginPost(body: LoginRequest(username: username, password: password)){data, error in
            if(error == nil)
            {
                print(HTTPCookieStorage.shared.cookies!)
            }
            else
            {
                print("error: \(String(describing: error))")
            }
        }
        
    }

    @IBAction func DoSignUp(_ sender: AnyObject) {
        if((first_name_s_input.text!).isEmpty ||
            !(last_name_s_input.text!).isEmpty ||
            !(email_s_input.text!).isEmpty ||
            !(username_s_input.text!).isEmpty ||
            !(password_s_input.text!).isEmpty ||
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
    
    func check_session()
    {
        let post_data: NSDictionary = NSMutableDictionary()
        
        
        post_data.setValue(login_session, forKey: "access_token")
        
        let url:URL = URL(string: checksession_url)!
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        var paramString = ""
        
        
        for (key, value) in post_data
        {
            paramString = paramString + (key as! String) + "=" + (value as! String) + "&"
        }
        
        request.httpBody = paramString.data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (
            data, response, error) in
            
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                
                return
            }

            
            let json: Any?
            
            do
            {
                json = try JSONSerialization.jsonObject(with: data!, options: [])
            }
            catch
            {
                return
            }
           
            guard let server_response = json as? NSDictionary else
            {
                return
            }
            
            if let response_code = server_response["response_code"] as? Int
            {
                if(response_code == 200)
                {
                    DispatchQueue.main.async(execute: self.LoginDone)
                    

                }
                else
                {
                    DispatchQueue.main.async(execute: self.LoginToDo)
                }
            }
            
            
            
        })
        
        task.resume()
        
        
    }

    
    
    
    
    func LoginDone()
    {
        username_input.isEnabled = false
        password_input.isEnabled = false
        
        login_button.isEnabled = true


        login_button.setTitle("Logout", for: .normal)
    }
    
    func LoginToDo()
    {
        username_input.isEnabled = true
        password_input.isEnabled = true
        
        login_button.isEnabled = true

        
        login_button.setTitle("Login", for: .normal)
    }
}

