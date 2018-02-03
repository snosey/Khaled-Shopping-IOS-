//
//  Review.swift
//  Shopping
//
//  Created by Naggar on 11/26/17.
//  Copyright © 2017 Haseboty. All rights reserved.
//

import Foundation
import SwiftyJSON


class Review {
    
    
    var id = ""
    var rate = ""
    var data = "" // AS COmment
    var id_rate_client = ""
    var name = ""
    var logo = ""
    var created_at = ""
    
    init(json: JSON) {
        
        if let id = json["id"].string { self.id = id }
        if let rate = json["rate"].string { self.rate = rate }
        if let data = json["data"].string { self.data = data }
        if let id_rate_client = json["id_rate_client"].string { self.id_rate_client = id_rate_client }
        if let name = json["name"].string { self.name = name }
        if let logo = json["logo"].string { self.logo = logo }
        if let created_at = json["created_at"].string { self.created_at = created_at }
        
    }
}
