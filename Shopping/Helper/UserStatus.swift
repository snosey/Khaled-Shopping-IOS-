//
//  UserStatus.swift
//  Shopping
//
//  Created by Naggar on 11/11/17.
//  Copyright © 2017 Haseboty. All rights reserved.
//

import Foundation


struct UserStatus {
    
    static var login: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.UserData.logged)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: Constants.UserData.logged)
        }
    }
    
    static var username: String {
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.UserData.username)
            UserDefaults.standard.synchronize()
        }
        
        get {
            return UserDefaults.standard.string(forKey: Constants.UserData.username)!
        }
    }
    
    static var email: String {
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.UserData.email)
            UserDefaults.standard.synchronize()
            
        }
        get {
            return UserDefaults.standard.string(forKey: Constants.UserData.email)!
        }
    }
    
    static var password: String {
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.UserData.password)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: Constants.UserData.password)!
        }
    }
    
    static var clientID: String {
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.UserData.clientID)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: Constants.UserData.clientID)!
        }
    }
    
    static var userID: String {
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.UserData.userID)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: Constants.UserData.userID)!
        }
    }
    
    static var isLoggedByFaceOrGoogle: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.UserData.loggedFaceOrGoogle)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: Constants.UserData.loggedFaceOrGoogle)
        }        
    }
    
}
