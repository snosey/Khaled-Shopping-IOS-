//
//  WebServicesMessages.swift
//  Shopping
//
//  Created by Naggar on 11/28/17.
//  Copyright © 2017 Haseboty. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RappleProgressHUD


extension WebServices {
    
    class func getInbox(completion: @escaping (_ success: Bool , _ messages: [Message]?) -> Void) {
        
        let parameters  = [
            "id" : UserStatus.clientID
        ]

        // RappleActivityIndicatorView.startAnimatingWithLabel("Loading...", attributes: RappleModernAttributes)

        activityIndicatorView.startAnimation()
        
        Alamofire.request(Constants.Services.inboxMessages, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
        
        
            .responseJSON { (response) in
                
                activityIndicatorView.stopAnimation()
                
                switch(response.result) {
                case .failure(let err) :
                    print(err)
                    completion(false , nil)
                    
                case .success(let val) :
                    print(val)
                    let json = JSON(val)
                    
                    var returnedMessages = [Message]()
                    for eachChat in json.array! {
                        
                        returnedMessages.append(Message(json: eachChat))
                        
                    }
                    
                    completion(true , returnedMessages)
                }
        }
    }
    
    class func getClientChat(_ idReciever: String , _ idProduct: String , completion: @escaping (_ success: Bool , _ messages: [Message]?) -> Void) {

        let parameters  = [
            "id_recieve" : idReciever ,
            "id_product" : idProduct ,
            "id_sent" : UserStatus.clientID
        ]
        
        // RappleActivityIndicatorView.startAnimatingWithLabel("Loading...", attributes: RappleModernAttributes)
        
        activityIndicatorView.startAnimation()
        
        Alamofire.request(Constants.Services.getChat, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
        
        
        
            .responseJSON { (response) in
                activityIndicatorView.stopAnimation()
                
                switch(response.result) {
                    
                case .failure(let err) :
                    print(err)
                    completion(false , nil)
                    
                case .success(let val):
                    let json = JSON(val)
                    
                    let jsonData = json["data"].array!
                    
                    var returnedMessages = [Message]()
                    
                    let senderName = json["sender_name"].string!
                    let sender_logo = json["sender_logo"].string!
                    let reciver_name = json["reciver_name"].string!
                    let reciver_logo = json["reciver_logo"].string!
                    
                    for eachMessage in jsonData {
                        let idSent = eachMessage["id_sent"].string!
                        returnedMessages.append(Message(json: eachMessage, senderName, sender_logo, reciver_name, reciver_logo, idSent))
                    }                    
                    
                    completion(true , returnedMessages)
                }
        }   
    }
    
    
    class func seeClientMessages(id: String , completion: @escaping (_ success: Bool , _ Msg: String?) -> Void) {
        
        let parameters = [
            "id[]" : id
        ]
        
        Alamofire.request(Constants.Services.seeMessage, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
        
            .responseJSON { (response) in
                
                switch(response.result) {
                    
                case .failure(let err) :
                    print(err)
                    completion(false , err.localizedDescription)
                    
                case .success(let val) :
                    let json = JSON(val)
                    
                    if json["sucess"].bool == true {
                        completion(true,  nil)
                    } else {
                        completion(false , "Error in SeeingMessages")
                    }
                }
        }
        
    }
    
    class func sendMessage(_ id_recieve: String , _ message: String , _ productID: String , completion: @escaping (_ success: Bool , _ Msg: String?) -> Void) {
        
        let parameters = [
            "message" : message ,
            "id_recieve" : id_recieve ,
            "id_sent" : UserStatus.clientID ,
            "id_product" : productID
        ]
        
        // RappleActivityIndicatorView.startAnimatingWithLabel("Loading...", attributes: RappleModernAttributes)
        
        activityIndicatorView.startAnimation()
        
        Alamofire.request(Constants.Services.addMessage , method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
        

            .responseJSON { (response) in
                
                activityIndicatorView.stopAnimation()
                
                switch(response.result) {
                    
                case .failure(let err) :
                    print(err)
                    completion(false , err.localizedDescription)
                    
                case .success(let val) :
                    let json = JSON(val)
                    
                    if json["sucess"].bool == true {
                        completion(true , nil)
                    } else {
                        completion(false , "Error while send Message!")
                    }
                }
        }
    }
}
