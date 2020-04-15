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
    
    var login_session:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


        username_input.text = "<string>"
        password_input.text = "<string>s"
        
        
        let preferences = UserDefaults.standard
        if preferences.object(forKey: "access_token") != nil
        {
            login_session = preferences.object(forKey: "access_token") as! String
            check_session()
        }
        else
        {
            LoginToDo()
        }


    }


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
                print("error \(error)")
            }
        }
        
//        let post_data: NSDictionary = NSMutableDictionary()
//
//        post_data.setValue(username, forKey: "username")
//        post_data.setValue(password, forKey: "password")
//
//        let url:URL = URL(string: login_url)!
//        let session = URLSession.shared
//
//        let request = NSMutableURLRequest(url: url)
//        request.httpMethod = "POST"
//        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
//
//        var paramString = ""
//
//
//        for (key, value) in post_data
//        {
//            paramString = paramString + (key as! String) + "=" + (value as! String) + "&"
//        }
//
//        request.httpBody = paramString.data(using: String.Encoding.utf8)
//
//        let task = session.dataTask(with: request as URLRequest, completionHandler: {
//        (
//            data, response, error) in
//
//            print(response!)
//            guard let _:Data = data, let _:URLResponse = response as? HTTPURLResponse , error == nil else {
//                print("data error")
//                return
//            }
//
//
//            let json: Any?
//
//            do
//            {
//                json = try JSONSerialization.jsonObject(with: data!, options: [])
//            }
//            catch
//            {
//                print("unexpected json error \(error)")
//                return
//            }
//
//
//            guard let server_response = json as? NSDictionary else
//            {
//                print("Server response error")
//                return
//            }
//
//
//            if let data_block = server_response["data"] as? NSDictionary
//            {
//                if let session_data = data_block["access_token"] as? String
//                {
//                    self.login_session = session_data
//
//                    let preferences = UserDefaults.standard
//                    preferences.set(session_data, forKey: "access_token")
//
//                    DispatchQueue.main.async(execute: self.LoginDone)
//                }
//            }
//
//
//
//        })
//
//        task.resume()
            

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

