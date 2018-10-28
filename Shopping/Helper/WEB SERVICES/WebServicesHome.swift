//
//  WebServicesHome.swift
//  Shopping
//
//  Created by Naggar on 11/14/17.
//  Copyright © 2017 Haseboty. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RappleProgressHUD
import NVActivityIndicatorView

extension WebServices {
    
    
    class func getAllProduct(completion: @escaping (_ success: Bool , _ products: [Product]?) -> Void) {
        
        let parameters = [
            "user_id" : String(UserStatus.clientID) ,
            "limit" : String(limit)
        ]
        
        limit += 20
        
        // RappleActivityIndicatorView.startAnimatingWithLabel("Loading...", attributes: RappleModernAttributes)
        
        
        activityIndicatorView.startAnimation()
        
        Alamofire.request(Constants.Services.getAllProduct, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)

        
            .responseJSON { (response) in
                
                // RappleActivityIndicatorView.stopAnimation()

                activityIndicatorView.stopAnimation()
                
                switch(response.result) {
                    
                case .failure(let err) :
                    print(err.localizedDescription)
                    
                    completion(false , nil)
                    
                case .success(let val) :
                    print(val)
                    let json = JSON(val).array!
                    
                    var returnedProducts = [Product]()
                    
                    for eachProduct in json {
                        
                        let product = Product(json: eachProduct)
                        returnedProducts.append(product)
                    }
                    
                    completion(true , returnedProducts)
                }
                
        }
    }
    
    class func updateLove(state: String , idProduct: String , completion: @escaping (_ success: Bool , _ Msg: String) -> Void) {
        
        let parameters = [
            "id_client" : UserStatus.clientID ,
            "id_product" : idProduct ,
            "state" : state
        ]
        
        // RappleActivityIndicatorView.startAnimatingWithLabel("Loading...", attributes: RappleModernAttributes)
        
        activityIndicatorView.startAnimation()

        Alamofire.request(Constants.Services.updateLove, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
        
        
            .responseJSON { (response) in
                
            activityIndicatorView.stopAnimation()
                
                switch(response.result) {
                    
                case .failure(let err) :
                    print(err)
                    completion(false , err.localizedDescription)
                    
                case .success(let val) :
                    print(val)
                    let json = JSON(val)
                    
                    if json["sucess"].bool == true {
                        completion(true , "success")
                    } else {
                        completion(false , "Faild , please try again!")
                    }
                    
                }
                
        }
        
        
    }
    
    
    class func SearchText(text: String , completion: @escaping (_ success: Bool , _ products: [Product]?) -> Void) {
        
        let parameters: [String: Any] = [
            
            "limit" : limitSearch ,
            "text" : text ,
            "user_id" : UserStatus.clientID
            
        ]
        
        // RappleActivityIndicatorView.startAnimatingWithLabel("Loading...", attributes: RappleModernAttributes)

        activityIndicatorView.startAnimation()
        
        Alamofire.request(Constants.Services.productSearch, method: .get , parameters: parameters, encoding: URLEncoding.default, headers: nil)
        
        
            .responseJSON { (response) in
                
                activityIndicatorView.stopAnimation()
                
                switch(response.result) {
                    
                case .failure(let err) :
                    print(err)
                    completion(false , nil)
                    
                    
                case .success(let val) :
                    
                    let json = JSON(val).array!
                    
                    var returnedProducts = [Product]()
                    
                    for eachProduct in json {
                        
                        let product = Product(json: eachProduct)
                        returnedProducts.append(product)
                    }
                    
                    completion(true , returnedProducts)

                }
                
        }

        
    }
    
    class func filterProduct(filter: Filter , completion: @escaping (_ success: Bool , _ products: [Product]?) -> Void) {
        
        let parameters: [String : Any] = [
            "limit" : limitFilter ,
            "id_category1" : filter.id_category1 ,
            "id_category2" : filter.id_category2 ,
            "id_category3" : filter.id_category3 ,
            "price_from" : filter.price_from ,
            "price_to" : filter.price_to ,
            "id_brand" : filter.id_brand ,
            "id_size" : filter.id_size ,
            "id_condition_state" : filter.id_condition_state ,
            "id_color1" : filter.id_color1 ,
            "id_color2" : filter.id_color2 ,
            "id_government" : filter.id_government ,
            "id_city" : filter.id_city ,
            "user_id" : UserStatus.clientID ,
            "swap" : filter.swap
            
        ]
        
        limitFilter += 20
        
        
        // RappleActivityIndicatorView.startAnimatingWithLabel("Loading...", attributes: RappleModernAttributes)

        activityIndicatorView.startAnimation()
        
        Alamofire.request(Constants.Services.productAllSearch, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
        
            .responseJSON { (response) in
                
                activityIndicatorView.stopAnimation()
                
                switch(response.result) {
                    
                case .failure(let err) :
                    print(err.localizedDescription)
                    completion(false , nil)
                    
                case .success(let val) :
                    print(val)
                    let json = JSON(val).array!
                    
                    var returnedProducts = [Product]()
                    
                    for eachProduct in json {
                        
                        let product = Product(json: eachProduct)
                        returnedProducts.append(product)
                    }
                    
                    completion(true , returnedProducts)
                }
        }
    }
}
