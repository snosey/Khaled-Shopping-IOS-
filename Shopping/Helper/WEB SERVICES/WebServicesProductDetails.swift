//
//  WebServicesProductDetails.swift
//  Shopping
//
//  Created by Naggar on 11/21/17.
//  Copyright © 2017 Haseboty. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RappleProgressHUD

extension WebServices {
    
    class func getProductDetails(_ clientID: String , _ id: String , completion: @escaping (_ success: Bool , _ productDetail: ProductDetails?) -> Void) {
        
        let parameters = [
            "id" : id ,
            "user_id" : UserStatus.clientID
        ]
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Loading...", attributes: RappleModernAttributes)
        
        Alamofire.request(Constants.Services.productDetails, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
        
        
            .responseJSON { (response) in
                
                RappleActivityIndicatorView.stopAnimation()

                switch(response.result) {
                    
                case .failure(let err) :
                    print(err)
                    completion(false , nil)
                    
                    
                case .success(let val) :
                    print(val)
                    let json = JSON(val)
                    print(json)
                    
                    completion(true , ProductDetails(json: json))
                    
                }
                
        }
        
        
    }
    
    class func updateView(_ id: String , completion: @escaping (_ success: Bool) -> Void) {
        
        let parameters = [
            "id_product" : id
        ]
        
        Alamofire.request(Constants.Services.updateView, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
        
            .responseJSON { (response) in
                
                switch(response.result) {
                    
                case .failure(let err) :
                    print(err)
                    completion(false)
                    
                case .success(let val) :
                    print(val)
                    completion(true)
                }
        }
        
    }
    
    
    class func clientProducts(_ clientProduct: String, completion: @escaping (_ success: Bool , _ products: [Product]?) -> Void) {
        
        print(clientProduct)
        print(UserStatus.clientID)
        
        
        let parameters: [String : Any] = [
            "id_client" : clientProduct ,
            "limit" : limitClientProduct ,
            "user_id" : UserStatus.clientID
        ]
        
        limitClientProduct += 20
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Loading...", attributes: RappleModernAttributes)

        
        Alamofire.request(Constants.Services.clientProducts, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
        
            .responseJSON { (response) in
                
                RappleActivityIndicatorView.stopAnimation()
                
                switch(response.result) {
                case .failure(let err) :
                    print(err)
                    completion(false , nil)
                    
                case .success(let val) :
                    print(val)
                    let json = JSON(val)
                    
                    var returnedProducts = [Product]()
                    
                    for eachProduct in json.array! {
                        
                        returnedProducts.append(Product(json: eachProduct))
                        
                    }
                    print(returnedProducts.count)
                    
                    completion(true , returnedProducts)
                }
        }
    }
    
    
    class func getSimilarProduct(_ cat1: String , _ cat2: String , cat3: String , completion: @escaping (_ success: Bool , _ products: [Product]?) -> Void) {
        
        let parameters: [String : Any] = [
            "limit" : limitSimilarProduct ,
            "user_id" : UserStatus.clientID ,
            "id_category1" : cat1 ,
            "id_category2" : cat2 ,
            "id_category3" : cat3
        ]
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Loading...", attributes: RappleModernAttributes)

        
        Alamofire.request(Constants.Services.similarProducts, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
        
            .responseJSON { (response) in
                
                RappleActivityIndicatorView.stopAnimation()
                
                switch(response.result) {
                    
                case .failure(let err) :
                    print(err.localizedDescription)
                    completion(false , nil)
                 
                case .success(let val) :
                    print(val)
                    let json = JSON(val)
                    
                    var returnedProducts = [Product]()
                    
                    for eachProduct in json.array! {
                        
                        returnedProducts.append(Product(json: eachProduct))
                        
                    }
                    print(returnedProducts.count)
                    
                    completion(true , returnedProducts)
                }
        }
    }
    
    class func getFavouritesProduct(completion: @escaping (_ success: Bool , _ products: [Product]?) -> Void) {
        
        let parameters: [String : Any] = [
            "limit" : limitFavProduct ,
            "id_client" : UserStatus.clientID
        ]
        
        limitFavProduct += 20
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Loading...", attributes: RappleModernAttributes)
        
        
        Alamofire.request(Constants.Services.productClientLove, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            
            .responseJSON { (response) in
                
                RappleActivityIndicatorView.stopAnimation()
                
                switch(response.result) {
                case .failure(let err) :
                    print(err)
                    completion(false , nil)
                    
                case .success(let val) :
                    print(val)
                    let json = JSON(val)
                    
                    var returnedProducts = [Product]()
                    
                    for eachProduct in json.array! {
                        
                        returnedProducts.append(Product(json: eachProduct))
                        
                    }
                    print(returnedProducts.count)
                    
                    completion(true , returnedProducts)
                }
        }
    }
    
    class func deleteProduct(productID: String , completion: @escaping (_ success: Bool , _ Msg: String?) -> Void) {
        
        let parameters = [
            "id" : productID
        ]
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Loading...", attributes: RappleModernAttributes)
        
        Alamofire.request(Constants.Services.deleteProduct, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
        
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
                        
                        completion(false , "Unable to delete , please try again")
                    }
                    
                    
                }
        }
    }
    
    class func editProductData(productID: String , completion: @escaping(_ success: Bool , _ productDetails: EditProduct?) -> Void) {
        
        let parameters = [
            "id" : productID
        ]
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Loading...", attributes: RappleModernAttributes)
        
        Alamofire.request(Constants.Services.editProductData, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            
            .responseJSON { (response) in
                
                RappleActivityIndicatorView.stopAnimation()
                
                switch(response.result) {
                    
                case .failure(let err) :
                    print(err)
                    completion(false , nil)
                    
                case .success(let val) :
                    let json = JSON(val)
                    print(json)
                    
                    completion(true , EditProduct(json: json))
                }

        }
        
    }
    
    class func updateProductData(productID: String , product: EditProduct , completion: @escaping(_ success: Bool) -> Void) {
        
        let parameters = [
            "id" : productID ,
            "view" : product.view ,
            "id_client" : product.id_client ,
            "title" : product.title ,
            "description" : product.description ,
            "id_category1": product.id_category1 ,
            "id_category2": product.id_category2 ,
            "id_category3": product.id_category3 ,
            "price" : product.price ,
            "swap" : product.swap ,
            "img1" : product.img1 ,
            "img2" : product.img2 ,
            "img3" : product.img3 ,
            "img4" : product.img4 ,
            "img5" : product.img5 ,
            "id_brand" : product.id_brand ,
            "id_size" : product.id_size ,
            "id_condition_state" : product.id_condition_state ,
            "id_color1" :  product.id_color1 ,
            "id_color2"  : product.id_color2 ,
            "id_government" : product.id_government ,
            "id_city" : product.id_city
        ]
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Loading...", attributes: RappleModernAttributes)

        Alamofire.request(Constants.Services.updateProduct, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
        
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
















