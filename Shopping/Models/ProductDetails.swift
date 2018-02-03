//
//  ProductDetails.swift
//  Shopping
//
//  Created by Naggar on 11/21/17.
//  Copyright © 2017 Haseboty. All rights reserved.
//

import Foundation
import SwiftyJSON

class ProductDetails {
    
    var description = ""
    var title = ""
    var share = ""
    var id_category1 = ""
    var id_category2 = ""
    var id_category3 = ""
    var img1 = ""
    var img2 = ""
    var img3 = ""
    var img4 = ""
    var img5 = ""
    var id_brand = ""
    var color1 = ""
    var color2 = ""
    var price = ""
    var swap = ""
    var view = ""
    var created_at = ""
    var id_client = "" // M4 m7tago - l2 e7tgto b2a :""D
    var countLove = ""
    var isLove = ""
    var review = ""
    var stars = "0"
    var comment = ""
    var brand = ""
    var size = ""
    var size_number = ""
    var state = ""
    var government = ""
    var city = ""
    var name = ""
    var logo = ""
    var phone = ""
    
    var id = ""
    var client_id_of_owner = ""
    
    init(json: JSON) {
        
        
        if let description = json["description"].string { self.description = description }
        if let title = json["title"].string { self.title = title }
        if let share = json["share"].string { self.share = share }
        if let id_category1 = json["id_category1"].string { self.id_category1 = id_category1 }
        if let id_category2 = json["id_category2"].string { self.id_category2 = id_category2 }
        if let id_category3 = json["id_category3"].string { self.id_category3 = id_category3 }
        if let img1 = json["img1"].string { self.img1 = img1 }
        if let img2 = json["img2"].string { self.img2 = img2 }
        if let img3 = json["img3"].string { self.img3 = img3 }
        if let img4 = json["img4"].string { self.img4 = img4 }
        if let img5 = json["img5"].string { self.img5 = img5 }
        if let id_brand = json["id_brand"].string { self.id_brand = id_brand }
        if let color1 = json["color1"].string { self.color1 = color1 }
        if let color2 = json["color2"].string { self.color2 = color2 }
        if let price = json["price"].string { self.price = price }
        if let swap = json["swap"].string { self.swap = swap }
        if let view = json["view"].string { self.view = view }
        if let created_at = json["created_at"].string { self.created_at = created_at }
        if let id_client = json["id_client"].string { self.id_client = id_client }
        if let love = json["love"].string { self.countLove = love }
        if let isLove = json["isLove"].string { self.isLove = isLove }
        if let review = json["review"].string { self.review = review }
        if let stars = json["stars"].string {  self.stars = stars  }
        if let comment = json["comment"].string { self.comment = comment }
        if let brand = json["brand"].string { self.brand = brand }
        if let size = json["size"].string { self.size = size }
        if let size_number = json["size_number"].string { self.size_number = size_number }
        if let state = json["state"].string { self.state = state }
        if let  government = json["government"].string { self.government = government }
        if let city = json["city"].string { self.city = city }
        if let name = json["name"].string { self.name = name }
        if let logo = json["logo"].string { self.logo = logo }
        if let phone = json["phone"].string { self.phone = phone }
        
        
    }
    
    
}
