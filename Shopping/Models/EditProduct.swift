//
//  editProduct.swift
//  Shopping
//
//  Created by Naggar on 12/1/17.
//  Copyright © 2017 Haseboty. All rights reserved.
//

import Foundation
import SwiftyJSON

class EditProduct {
    
    var description = ""
    var title = ""
    var id_category1 = ""
    var category1 = ""
    var id_category2 = ""
    var category2 = ""
    var id_category3 = ""
    var category3 = ""
    var img1 = " "
    var img2 = " "
    var img3 = " "
    var img4 = " "
    var img5 = " "
    var id_color1 = ""
    var color1 = ""
    var id_color2 = ""
    var color2 = ""
    var price = ""
    var swap = ""
    var view = ""
    var created_at = ""
    var id_client = ""
    var id_brand = ""
    var brand = ""
    var id_size = ""
    var size = ""
    var size_number = ""
    var id_condition_state = ""
    var state = ""
    var id_government = ""
    var government = ""
    var id_city = ""
    var city = ""
    
    
    init(json: JSON) {
        
        if let description = json["description"].string { self.description = description }
        if let title = json["title"].string { self.title = title }
        if let id_category1 = json["id_category1"].string { self.id_category1 = id_category1 }
        if let category1 = json["category1"].string { self.category1 = category1 }
        if let id_category2 = json["id_category2"].string { self.id_category2 = id_category2 }
        if let category2 = json["category2"].string { self.category2 = category2 }
        if let id_category3 = json["id_category3"].string { self.id_category3 = id_category3 }
        if let category3 = json["category3"].string { self.category3 = category3 }
        if let img1 = json["img1"].string { self.img1 = img1 }
        if let img2 = json["img2"].string { self.img2 = img2 }
        if let img3 = json["img3"].string { self.img3 = img3 }
        if let img4 = json["img4"].string { self.img4 = img4 }
        if let img5 = json["img5"].string { self.img5 = img5 }
        if let id_color1 = json["id_color1"].string { self.id_color1 = id_color1 }
        if let color1 = json["color1"].string { self.color1 = color1 }
        if let id_color2 = json["id_color2"].string { self.id_color2 = id_color2 }
        if let color2 = json["color2"].string { self.color2 = color2 }
        if let price = json["price"].string { self.price = price }
        if let swap = json["swap"].string { self.swap = swap }
        if let view = json["view"].string { self.view = view }
        if let created_at = json["created_at"].string { self.created_at = created_at }
        if let id_client = json["id_client"].string { self.id_client = id_client }
        if let id_brand = json["id_brand"].string { self.id_brand = id_brand }
        if let brand = json["brand"].string { self.brand = brand }
        if let id_size = json["id_size"].string { self.id_size = id_size }
        if let size = json["size"].string { self.size = size }
        if let size_number = json["size_number"].string { self.size_number = size_number }
        if let id_condition_state = json["id_condition_state"].string { self.id_condition_state = id_condition_state }
        if let state = json["state"].string { self.state = state }
        if let id_government = json["id_government"].string { self.id_government = id_government }
        if let government = json["government"].string { self.government = government }
        if let id_city = json["id_city"].string { self.id_city = id_city }
        if let city = json["city"].string { self.city = city }
    }    
}
