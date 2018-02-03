//
//  WebServicesProfile.swift
//  Shopping
//
//  Created by Naggar on 11/23/17.
//  Copyright © 2017 Haseboty. All rights reserved.
//

import Foundation
import Alamofire
import RappleProgressHUD
import SwiftyJSON

extension WebServices {
    
    class func getUserInfo(completion: @escaping (_ success: Bool ,_ userName: String? , _ name: String? , _ phone: String? , _ logo: String? , _ about: String?) -> Void) {
        
        let parameters = [
            "id" : UserStatus.clientID
        ]
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Loading...", attributes: RappleModernAttributes)

        Alamofire.request(Constants.Services.editClientData, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
        
            .responseJSON { (response) in
                
                RappleActivityIndicatorView.stopAnimation()
                
                switch(response.result) {
                    
                case .failure(let err) :
                    print(err)
                    completion(false , nil , nil , nil , nil , nil)
                    
                case .success(let val) :
                    let json = JSON(val)
                    
                    if let username = json["username"].string {
                        if let phone = json["phone"].string {
                            if let logo = json["logo"].string {
                                if let about = json["about"].string {
                                    if let name = json["name"].string {
                                        completion(true , username , name , phone , logo , about)
                                        return
                                    }
                                }
                            }
                        }
                    }
                    
                    completion(false , nil , nil , nil , nil , nil)
                    
                }
                
        }
        
        
    }
    
    class func updateProfile(name: String , logo: String , phone: String , about: String , completion: @escaping (_ success: Bool) -> Void) {
        
        let parameters = [
            "id" : UserStatus.clientID ,
            "username" : UserStatus.username ,
            "name" : name ,
            "password" : UserStatus.password ,
            "email" : UserStatus.email ,
            "logo" : logo ,
            "phone" : phone ,
            "about" : about
        ]
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Loading...", attributes: RappleModernAttributes)
        
        Alamofire.request(Constants.Services.updateClient, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)

            .responseJSON { (response) in
                
                RappleActivityIndicatorView.stopAnimation()
                
                switch(response.result) {
                    
                case .failure(let err) :
                    print(err)
                    completion(false)
                    
                case .success(let val) :
                    let json = JSON(val)
                    
                    if json["sucess"].bool == true {
                        completion(true)
                    } else {
                        completion(false)
                    }
                    
                }
        }
        
    }
    
    class func clientProfileData(id_of_client: String , completion: @escaping (_ success: Bool , _ name: String? , _ about: String? , _ phone: String? , _ logo: String? , _ follow: String? , _ followers: String? , _ review: String? , _ stars: String? , _ isFollow: String?) -> Void) {
        
        let parameters = [
            "id" : id_of_client ,
            "id_follower" : UserStatus.clientID
        ]
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Loading...", attributes: RappleModernAttributes)

        Alamofire.request(Constants.Services.clientData, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
        
            .responseJSON { (response) in
                
                RappleActivityIndicatorView.stopAnimation()
                

                switch(response.result) {
                    
                case .failure(let err) :
                    print(err.localizedDescription)
                    completion(false , nil , nil , nil , nil , nil , nil , nil , nil , nil)
                    
                case .success(let val) :

                    let json = JSON(val)
                    print(json)
                    
                    let name = json["name"].string ?? "Mohamed"
                    let about = json["about"].string ?? "about"
                    let phone = json["phone"].string ?? "phone"
                    let logo = json["logo"].string ?? "logo"
                    let follow = json["follow"].string ?? "follow"
                    let followers = json["followers"].string ?? "followers"
                    let review = json["review"].string ?? "0"
                    let stars = json["stars"].string ?? "0"
                    let isFollow = json["isFollow"].string ?? "false"
                    
                    
                    completion(true , name , about , phone , logo , follow , followers , review , stars , isFollow)
                    
                }
        }
        
    }
    
    class func updateFollow(clientID: String , state: String , completion: @escaping (_ success: Bool , _ Msg: String?) -> Void) {
        
        print(clientID)
        
        
        let parameters = [
            "id_follower" : UserStatus.clientID ,
            "id_client" : clientID ,
            "state" : state
        ]
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Loading...", attributes: RappleModernAttributes)
        
        Alamofire.request(Constants.Services.updateFollow, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
        
            .responseJSON { (response) in
                
                RappleActivityIndicatorView.stopAnimation()
                
                switch(response.result) {
                    
                case .failure(let err) :
                    print(err)
                    completion(false , err.localizedDescription)
                    
                case .success(let val) :
                    let json = JSON(val)
                    
                    print(json)
                    
                    if json["sucess"].bool == true {
                        completion(true , nil)
                    } else {
                        completion(false , "Error , While Follow this person")
                    }
                }
        }
    }
    
    class func getFollowing(idClient: String , completion: @escaping (_ success: Bool , _ cells: [(String , String , String , String , String)]?) -> Void) {
        
        print(idClient)

        let parameters = [
            "id" : idClient ,
            "id_follower" : UserStatus.clientID
        ]
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Loading...", attributes: RappleModernAttributes)

        Alamofire.request(Constants.Services.clientFollowing, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
        
        
            .responseJSON { (response) in
                
                RappleActivityIndicatorView.stopAnimation()
                
                switch(response.result) {
                    
                case .failure(let err) :
                    print(err)
                    
                    completion(false , nil)
                    
                    
                case .success(let val):
                    let json = JSON(val)
                    
                    print(json)
                    
                    
                    var returnedData = [(String , String , String , String , String)]()
                    for eachFollow in json.array! {
                        
                        if let name = eachFollow["name"].string {
                            if let logo = eachFollow["logo"].string {
                                if let followers = eachFollow["followers"].string {
                                    if let isFollow = eachFollow["isFollow"].string {
                                        if let id = eachFollow["id"].string {
                                            returnedData.append((name , logo , followers , isFollow , id))
                                        }
                                    }
                                }
                            }
                        }
                    }
                    completion(true , returnedData)
                }
                
        }
    }
    
    class func getFollowers(idClient: String , completion: @escaping (_ success: Bool , _ cells: [(String , String , String , String , String)]?) -> Void) {
        
        print(idClient)
        
        
        let parameters = [
            "id" : idClient ,
            "id_follower" : UserStatus.clientID
        ]
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Loading...", attributes: RappleModernAttributes)
        
        Alamofire.request(Constants.Services.clientFollowers, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            
            .responseJSON { (response) in
                
                RappleActivityIndicatorView.stopAnimation()
                
                switch(response.result) {
                    
                case .failure(let err) :
                    print(err)
                    
                    completion(false , nil)
                    
                    
                case .success(let val):
                    let json = JSON(val)
                    
                    print(json)
                    
                    var returnedData = [(String , String , String , String , String)]()
                    for eachFollow in json.array! {
                        
                        if let name = eachFollow["name"].string {
                            if let logo = eachFollow["logo"].string {
                                if let followers = eachFollow["followers"].string {
                                    if let isFollow = eachFollow["isFollow"].string {
                                        if let id = eachFollow["id"].string {
                                            returnedData.append((name , logo , followers , isFollow , id))
                                        }
                                    }
                                }
                            }
                        }
                        
                    }
                    completion(true , returnedData)
                    
                }
        }
    }
    class func getReviews(idClient: String , completion: @escaping (_ success: Bool , _ reviews: [Review]?) -> Void) {
        
        let parameters = [
            "id_client" : idClient
        ]
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Loading...", attributes: RappleModernAttributes)

        
        Alamofire.request(Constants.Services.clientReviewData, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
        
            .responseJSON { (response) in
                
                RappleActivityIndicatorView.stopAnimation()
                
                switch(response.result) {
                    
                case .failure(let err) :
                    print(err)
                    completion(false , nil)
                    
                case .success(let val) :
                    let json = JSON(val)
                    print(json)
                    
                    
                    var returnedReviews = [Review]()
                    for eachReview in json.array! {
                        
                        returnedReviews.append(Review(json: eachReview))
                    }
                    
                    completion(true , returnedReviews)
                    
                }
        }
    }
    
    class func deleteReview(idComment: String , completion: @escaping (_ success: Bool , _ Msg: String?) -> Void) {
        
        print(idComment)
        
        let parameters = [
            "id" : idComment
        ]
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Loading...", attributes: RappleModernAttributes)

        Alamofire.request(Constants.Services.deleteReview, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
        
            .responseJSON { (response) in
                
                RappleActivityIndicatorView.stopAnimation()
                
                switch(response.result) {
                    
                case .failure(let err ) :
                    print(err)
                    completion(false , err.localizedDescription)
                    
                case .success(let val) :
                    let json = JSON(val)
                    
                    print(json)
                    
                    
                    if json["sucess"].bool == true {
                        
                        completion(true , nil)
                        
                    } else {
                        completion(false , "Failed to delete Review!")
                    }
                }
        }
    }
    
    class func addReview(idClient: String , rate: String , data: String , completion: @escaping (_ success: Bool , _ Msg: String?) -> Void)  {
        
        let parameters: [String : Any] = [
            "id_client" : idClient ,
            "data": data ,
            "rate" : rate ,
            "id_rate_client" : UserStatus.clientID
        ]
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Loading...", attributes: RappleModernAttributes)
        
        
        Alamofire.request(Constants.Services.addReview, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)

        
            .responseJSON { (response) in
                
                RappleActivityIndicatorView.stopAnimation()
                
                switch (response.result) {
                    
                case .failure(let err) :
                    print(err)
                    completion(false , err.localizedDescription)
                    
                case .success(let val) :

                    let json = JSON(val)
                    
                    if json["sucess"].bool == true {
                        completion(true , nil)
                    } else {
                        completion(false , "Error , while add your Review!")
                    }
                    
                }
        }
    }
}
