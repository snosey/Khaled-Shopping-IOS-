//
//  Message.swift
//  Shopping
//
//  Created by Naggar on 11/28/17.
//  Copyright © 2017 Haseboty. All rights reserved.
//

import Foundation
import SwiftyJSON


class Message {
    
    var id = ""
    var message = ""
    var created_at = ""
    var name = ""
    var logo = ""
    var unReed = ""
    var id_product = ""
    var product_name = ""
    var product_image = ""
    
    // FOR Client Chat usage
    var sender_name = ""
    var sender_logo = ""
    var reciver_name = ""
    var reciver_logo = ""
    var id_sent = ""
    var seen = ""
    
    init(json: JSON) {
        
        if let id = json["id"].string { self.id = id }
        if let message = json["message"].string { self.message = message }
        if let created_at = json["created_at"].string { self.created_at = created_at }
        if let name = json["name"].string { self.name = name }
        if let logo = json["logo"].string { self.logo = logo }
        if let unReed = json["unReed"].string { self.unReed = unReed }
        if let id_product = json["id_product"].string { self.id_product = id_product }
        if let product_name = json["product_name"].string { self.product_name = product_name }
        if let product_image = json["product_image"].string { self.product_image = product_image }
        
    }
    
    init(json: JSON , _ sender_name: String , _ sender_logo: String , _ reciver_name: String , _ reciver_logo: String , _ id_sent: String) {
        
        if let id = json["id"].string { self.id = id }
        if let message = json["message"].string { self.message = message }
        if let created_at = json["created_at"].string { self.created_at = created_at }
        if let id_product = json["id_product"].string { self.id_product = id_product }
        if let product_name = json["product_name"].string { self.product_name = product_name }
        if let product_image = json["product_image"].string { self.product_image = product_image }

        
        if let seen = json["seen"].string { self.seen = seen }
        
        // FOR CLIENT CHAT
        self.sender_name = sender_name
        self.sender_logo = sender_logo
        self.reciver_name = reciver_name
        self.reciver_logo = reciver_logo
        self.id_sent = id_sent
        
    }
    
}
