//
//  WebServicesLogin.swift
//  Shopping
//
//  Created by Naggar on 11/11/17.
//  Copyright © 2017 Haseboty. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RappleProgressHUD

extension WebServices {
    
    // MARK: - Login
    class func login(userName: String , password: String , completion: @escaping (_ success: Bool , _ Msg: String?) -> Void) {
        
        // RappleActivityIndicatorView.startAnimatingWithLabel("Loading...", attributes: RappleModernAttributes)
        
        activityIndicatorView.startAnimation()
        
        let parameters = [
            "username" : userName ,
            "password" : password
        ]
        
        Alamofire.request(Constants.Services.login, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            
            .responseJSON { (response) in
                
                activityIndicatorView.stopAnimation()
                
                
                switch(response.result) {
                    
                    
                case .failure(let error) :
                    print("Error")
                    
                    completion(false , error.localizedDescription)
                    
                case .success(let val) :
                    let json = JSON(val)
                    
                    if json["sucess"] == false {
                        completion(false , "Username or password is not valid!")
                    } else {
                        
                        // SAVE data to UserDefaults to use it later
                        UserStatus.login = true
                        UserStatus.username = userName
                        UserStatus.password = password
                        
                        
                        if let email = json["email"].string {
                            UserStatus.email = email
                            print(email)
                            
                        }
                        if let userID = json["id"].string {
                            UserStatus.clientID = userID
                            print(userID)
                            
                            
                        }
                        if let id_user = json["id_user"].string {
                            UserStatus.userID = id_user
                            
                        }
                        
                        completion(true , "Login successfully")
                        
                    }
                }
        }
        
    }
    
    
    // MARK: - Forget Password
    class func forgetPassword(email: String , completion: @escaping (_ success: Bool , _ Msg: String) -> Void) {
        
        let parameters = [
            "email" : email
        ]
        
        // RappleActivityIndicatorView.startAnimatingWithLabel("Loading...", attributes: RappleModernAttributes)
        
        activityIndicatorView.startAnimation()
        
        Alamofire.request(Constants.Services.forgetPassword, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            
            
            .responseJSON { (response) in
                activityIndicatorView.stopAnimation()
                
                switch(response.result){
                    
                case .failure(let err) :
                    print(err)
                    completion(false , err.localizedDescription)
                    
                case .success(let val) :
                    let json = JSON(val)
                    print(json)
                    
                    if json["sucess"] == true {
                        completion(true , "Username and Password is sent to your email")
                    } else {
                        completion(false , "Email is not exist!")
                    }
                    
                }
        }
    }
    
    // MARK: - SignUp
    class func signUp(email: String , userName: String , passWord: String , completion: @escaping (_ success: Bool , _ Msg: String) -> Void) {
        
        let parameters = [
            "username" : userName ,
            "email" : email ,
            "password" : passWord
        ]
        
        // RappleActivityIndicatorView.startAnimatingWithLabel("Loading...", attributes: RappleModernAttributes)
        
        activityIndicatorView.startAnimation()
        
        Alamofire.request(Constants.Services.signUp , method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            
            .responseJSON { (response) in
                
                activityIndicatorView.stopAnimation()
                
                switch(response.result) {
                    
                case .failure(let err) :
                    print(err)
                    completion(false , err.localizedDescription)
                    
                    
                case .success(let val) :
                    let json = JSON(val)
                    if json["sucess"] == true {
                        completion(true , "Registration success")
                    } else {
                        completion(false , "Username is aleady exist")
                    }
                }
        }
    }
    
    
}
