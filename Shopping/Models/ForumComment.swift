//
//  ForumComment.swift
//  Shopping
//
//  Created by Naggar on 12/5/17.
//  Copyright © 2017 Haseboty. All rights reserved.
//

import Foundation
import SwiftyJSON

class ForumComment {
    
    var id = ""
    var id_client = ""
    var id_form = ""
    var comment = ""
    var created_at = ""
    var updated_at = ""
    var name = ""
    var logo = ""
    
    init(json: JSON) {
        
        if let id = json["id"].string { self.id = id }
        if let id_client = json["id_client"].string { self.id_client = id_client }
        if let id_form = json["id_form"].string { self.id_form = id_form }
        if let comment = json["comment"].string { self.comment = comment }
        if let created_at = json["created_at"].string { self.created_at = created_at }
        if let updated_at = json["updated_at"].string { self.updated_at = updated_at }
        if let name = json["name"].string { self.name = name }
        if let logo = json["logo"].string { self.logo = logo }
        
    }
}
