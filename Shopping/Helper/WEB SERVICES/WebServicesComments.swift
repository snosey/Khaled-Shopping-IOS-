//
//  WebServicesComments.swift
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
    
    
    class func postComments(comment: String , idProduct: String , completion: @escaping (_ success: Bool , _ Msg: String?) -> Void) {
        
        let parameters = [
            "comment" : comment ,
            "id_client" : UserStatus.clientID ,
            "id_product" : idProduct
        ]
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Loading...", attributes: RappleModernAttributes)

        
        Alamofire.request(Constants.Services.postComments, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
        
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
                        completion(false , "Error , Please try again!")
                    }
                }
        }
    }
    
    
    class func deleteComment(commentID: String , completion: @escaping (_ success: Bool , _ Msg: String?) -> Void) {
        
        let parameters = [
            "id" : commentID
        ]
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Loading...", attributes: RappleModernAttributes)

        
        Alamofire.request(Constants.Services.deleteComment, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
        
        
            .responseJSON { (response) in
                
                RappleActivityIndicatorView.stopAnimation()
                
                switch(response.result) {
                    
                case .failure(let err) :
                    print(err)
                    completion(false, err.localizedDescription)
                    
                case .success(let val) :
                    let json = JSON(val)
                    print(json)
                    
                    if json["sucess"].bool == true {
                        completion(true , nil)
                    } else {
                        completion(false , "Error , while deleting Comment!")
                    }
                }
        }
    }
    
    class func getComments(idProduct: String , completion: @escaping (_ success: Bool , _ comments: [Comment]?) -> Void) {
        
        let parameters = [
            "id_product" : idProduct
        ]
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Loading...", attributes: RappleModernAttributes)
        
        Alamofire.request(Constants.Services.getComments, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
        
            .responseJSON { (response) in

                RappleActivityIndicatorView.stopAnimation()

                switch(response.result) {
                    
                case .failure(let err) :
                    print(err)
                    completion(false , nil)
                    
                case .success(let val) :
                    print(val)
                    
                    let json = JSON(val)
                    var comments = [Comment]()
                    print(json)
                    
                    for eachComment in json.array! {
                        
                        comments.append(Comment(json: eachComment))
                        
                    }
                    
                    completion(true , comments)
                    
                    
                }
                
        }
        
    }
    
    
}
