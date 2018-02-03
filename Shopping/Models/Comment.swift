//
//  Comment.swift
//  Shopping
//
//  Created by Naggar on 11/23/17.
//  Copyright © 2017 Haseboty. All rights reserved.
//

import Foundation
import SwiftyJSON

class Comment {
    
    var comment = ""
    var created_at = ""
    var id = ""
    var id_client = ""
    var id_product = ""
    var logo = ""
    var name = ""
    var updated_at = ""
    
    init(json: JSON) {
        
        if let comment = json["comment"].string { self.comment = comment }
        if let created_at = json["created_at"].string { self.created_at = created_at }
        if let id = json["id"].string { self.id = id }
        if let id_client = json["id_client"].string { self.id_client = id_client }
        if let id_product = json["id_product"].string { self.id_product = id_product }
        if let logo = json["logo"].string { self.logo = logo }
        if let name = json["name"].string { self.name = name }
        if let updated_at = json["updated_at"].string { self.updated_at = updated_at }
        
    }
}
