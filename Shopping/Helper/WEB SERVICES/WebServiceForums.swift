//
//  WebServiceForums.swift
//  Shopping
//
//  Created by Naggar on 12/5/17.
//  Copyright © 2017 Haseboty. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RappleProgressHUD

extension WebServices {
    
    class func getForums(idKind: String , completion: @escaping (_ success: Bool , _ allForms: [Forum]?) -> Void) {
        
        let parameters = [
            "id_kind" : idKind
        ]
        RappleActivityIndicatorView.startAnimatingWithLabel("Loading...", attributes: RappleModernAttributes)

        Alamofire.request(Constants.Services.formsAll, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
        
        
            .responseJSON { (response) in
                
                RappleActivityIndicatorView.stopAnimation()
                
                switch(response.result) {
                    
                case .failure(let err) :
                    print(err)
                    completion(false , nil )
                    
                case .success(let val) :
                    let json = JSON(val)
                    
                    var returnedForms = [Forum]()
                    
                    for eachForm in json.array! {
                        
                        returnedForms.append(Forum(json: eachForm))
                    }
                    
                    completion(true , returnedForms)
                    
                }
        }
    }
    
    class func getForumsKinds(_ completion: @escaping (_ success: Bool , _ kinds: [(String , String)]?) -> Void) {
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Loading...", attributes: RappleModernAttributes)
        
        Alamofire.request(Constants.Services.allFormsKind, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            
            
            .responseJSON { (response) in
                
                RappleActivityIndicatorView.stopAnimation()
                
                switch(response.result) {
                    
                case .failure(let err) :
                    print(err)
                    completion(false , nil)
                    
                case .success(let val) :
                    let json = JSON(val)
                    
                    var kinds = [(String , String)]()
                    
                    for eachKind in json.array! {
                        
                        if let id = eachKind["id"].string {
                            if let name = eachKind["name"].string {
                                kinds.append((id , name))
                            }
                        }
                    }
                    
                    completion(true,  kinds)
                }
        }
    }
    
    
    class func getForumsProfile(id: String , completion: @escaping (_ success: Bool , _ proifleForm: Forum?) -> Void) {
        
        let parameters = [
            "id" : id
        ]
        RappleActivityIndicatorView.startAnimatingWithLabel("Loading...", attributes: RappleModernAttributes)
        
        Alamofire.request(Constants.Services.formsContentById, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            
            
            .responseJSON { (response) in
                
                RappleActivityIndicatorView.stopAnimation()
                
                switch(response.result) {
                    
                case .failure(let err) :
                    print(err)
                    completion(false , nil)
                    
                case .success(let val) :
                    let json = JSON(val)
                    
                    completion(true , Forum(profileForums: json))

                }
        }
    }
    
    class func getCommentsForum(idForm: String , completion: @escaping (_ success: Bool , _ comments: [ForumComment]?) -> Void) {
        
        let parameters = [
            "id_form" : idForm
        ]
        RappleActivityIndicatorView.startAnimatingWithLabel("Loading...", attributes: RappleModernAttributes)
        
        Alamofire.request(Constants.Services.formsComments , method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            
            
            .responseJSON { (response) in
                
                RappleActivityIndicatorView.stopAnimation()
                
                switch(response.result) {
                    
                case .failure(let err) :
                    print(err)
                    completion(false , nil )
                    
                case .success(let val) :
                    let json = JSON(val)
                    
                    var returnedForms = [ForumComment]()
                    
                    for eachComment in json.array! {
                        
                        returnedForms.append(ForumComment(json: eachComment))
                    }
                    
                    completion(true , returnedForms)
                }
        }
    }
    
    class func deleteCommentForum(commentID: String , completion: @escaping (_ success: Bool) -> Void) {
        
        let parameters = [
            "id" : commentID
        ]
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Loading...", attributes: RappleModernAttributes)
        
        Alamofire.request(Constants.Services.deleteFormsComment , method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            
            
            .responseJSON { (response) in
                
                RappleActivityIndicatorView.stopAnimation()
                
                switch(response.result) {
                    
                case .failure(let err) :
                    print(err)
                    completion(false)
                    
                case .success(let val) :
                    let json = JSON(val)
                    print(json)
                    
                    if json["sucess"].bool == true {
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
        }
    }
    
    class func postCommentsForum(comment: String , id_form: String , completion: @escaping (_ success: Bool) -> Void) {
        
        let parameters = [
            "comment" : comment ,
            "id_client": UserStatus.clientID ,
            "id_form" : id_form
        ]
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Loading...", attributes: RappleModernAttributes)
        
        Alamofire.request(Constants.Services.addFormsComment , method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            
            
            .responseJSON { (response) in
                
                RappleActivityIndicatorView.stopAnimation()
                
                switch(response.result) {
                    
                case .failure(let err) :
                    print(err)
                    completion(false)
                    
                case .success(let val) :
                    let json = JSON(val)
                    print(json)
                    
                    if json["sucess"].bool == true {
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
        }

    }
    
}
