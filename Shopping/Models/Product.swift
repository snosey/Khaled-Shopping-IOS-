//
//  Product.swift
//  Shopping
//
//  Created by Naggar on 11/14/17.
//  Copyright © 2017 Haseboty. All rights reserved.
//

import Foundation
import SwiftyJSON


class Product {
    
    var id = ""
    var img1 = ""
    var price = ""
    var id_client = ""
    var love = ""
    var isLove = "" // True or False but String
    var brand = ""
    var size = ""
    var size_number = ""
    var name = ""
    var logo = ""
    var swap = ""
    
    init(json: JSON) {
        if let id = json["id"].string { self.id = id }
        if let img1 = json["img1"].string { self.img1 = img1 }
        if let price = json["price"].string { self.price = price }
        if let id_client = json["id_client"].string { self.id_client = id_client }
        if let love = json["love"].string { self.love = love }
        if let isLove = json["isLove"].string { self.isLove = isLove }
        if let brand = json["brand"].string { self.brand = brand }
        if let size = json["size"].string { self.size = size }
        if let size_number = json["size_number"].string { self.size_number = size_number }
        if let name = json["username"].string { self.name = name }
        else if let name = json["name"].string { self.name = name }
        if let logo = json["logo"].string { self.logo = logo }
        if let swap = json["swap"].string { self.swap = swap }
    }
}
