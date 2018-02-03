//
//  Category.swift
//  Shopping
//
//  Created by Naggar on 11/10/17.
//  Copyright © 2017 Haseboty. All rights reserved.
//

import Foundation
import SwiftyJSON

class Category {
    
    var id = ""
    var Perivous_Category_id = ""
    var logo = ""
    var name = ""
    var orders = ""
    
    init(id: String , PerviousID: String , name: String , orders: String , logo: String = "") {
        
        self.id = id
        self.Perivous_Category_id = PerviousID
        self.name = name
        self.orders = orders
        
    }
    
}
