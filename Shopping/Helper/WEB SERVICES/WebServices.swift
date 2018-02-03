//
//  WebServices.swift
//  Shopping
//
//  Created by Naggar on 11/6/17.
//  Copyright © 2017 Haseboty. All rights reserved.
//

import Foundation
import Alamofire
import RappleProgressHUD
import SwiftyJSON

class WebServices {
    
    // MARK: - Stored Properties
    static var limit = 0 // used in getAllProduct
    static var limitClientProduct = 0 // used in getClientProduct
    static var limitSimilarProduct = 0 // Used in get Similar product
    static var limitFavProduct = 0 // Used in Favourite Products
    static var limitSearch = 0 //
    static var limitFilter = 0 // User in Filter Products
    
    // MARK: - Add Product
    class func addProduct(addProduct: AddProduct , completion: @escaping (_ success: Bool , _ Msg: String) -> Void ) {
        
        print(addProduct.price)
        
        let parameters = [
            "id_client" : "\(UserStatus.clientID)" ,
            "title" : addProduct.title ,
            "description" : addProduct.description ,
            "id_category1" : addProduct.id_category1 ,
            "id_category2" : addProduct.id_category2 ,
            "id_category3" : addProduct.id_category3 ,
            "price" : addProduct.price ,
            "swap" : addProduct.swap ,
            "id_brand" : addProduct.id_brand ,
            "id_size" : addProduct.id_size ,
            "id_condition_state" : addProduct.id_condition_state ,
            "id_city" : addProduct.id_city  ,
            "id_government" : addProduct.id_government  ,
            "id_color1" : addProduct.id_color1 ,
            "id_color2" : addProduct.id_color2 ,
            "img1" : addProduct.img1 ,
            "img2" : addProduct.img2 ,
            "img3" : addProduct.img3 ,
            "img4" : addProduct.img4 ,
            "img5" : addProduct.img5 ,
        ]
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Loading...", attributes: RappleModernAttributes)
        
        Alamofire.request(Constants.Services.addProduct, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
        
            .responseJSON { (response) in
                
                RappleActivityIndicatorView.stopAnimation()
                
                switch(response.result) {
                    
                case .failure(let err) :
                    print(err)
                    completion(false , err.localizedDescription)
                    
                case .success(let val) :
                    print(val)
                    completion(true , "Done")
                    
                }
        }
    }
    
    // MARK: - Get Category
    class func loadProductContent(completion: @escaping (_ err: Error? , _ json: JSON?) -> Void ) {
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Loading...", attributes: RappleModernAttributes)
        

        Alamofire.request(Constants.Services.productContentData, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
        
            .responseJSON { (response) in
                
                RappleActivityIndicatorView.stopAnimation()
                
                switch(response.result) {
                    
                case .failure(let err) :
                    completion(err , nil)
                    
                case .success(let val) :
                    let json = JSON(val)
                    
                    completion(nil , json)
                }
        }
    }
    
    
    class func clientRegId(regID: String , _ completion: @escaping (_ success: Bool) -> Void) {
        
        let parameters = [
            "id_client" : UserStatus.clientID ,
            "reg_id" : regID
        ]
        
        print(UserStatus.clientID)
        
        
        Alamofire.request("http://haseboty.com/shopping/webservice/clientRegId.php", method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
        
        
            .responseJSON { (response) in
                
                switch(response.result) {
                    
                case .failure(let err) :
                    print(err)
                    completion(false)
                    
                    
                case .success(let val):
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
