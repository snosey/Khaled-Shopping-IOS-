//
//  AllForms.swift
//  Shopping
//
//  Created by Naggar on 12/5/17.
//  Copyright © 2017 Haseboty. All rights reserved.
//

import Foundation
import SwiftyJSON


class Forum {
    
    // GET ALL FORMS
    var id = ""
    var title = ""
    var content = ""
    var kind = ""
    
    
    // GET PRofile Forms
    var img1 = " "
    var img2 = " "
    var img3 = " "
    var img4 = " "
    var img5 = " "
    var created_at = ""
    var countComments = ""
    
    init(json: JSON) {
        
        if let id = json["id"].string { self.id = id }
        if let title = json["title"].string { self.title = title }
        if let content = json["content"].string { self.content = content }
        if let kind = json["kind"].string { self.kind = kind }
        
    }
    
    init(profileForums: JSON) {
        
        if let id = profileForums["id"].string { self.id = id }
        if let title = profileForums["title"].string { self.title = title }
        if let content = profileForums["content"].string { self.content = content }
        if let kind = profileForums["kind"].string { self.kind = kind }
        
        if let img1 = profileForums["img1"].string { self.img1 = img1 }
        if let img2 = profileForums["img2"].string { self.img2 = img2 }
        if let img3 = profileForums["img2"].string { self.img3 = img3 }
        if let img4 = profileForums["img2"].string { self.img4 = img4 }
        if let img5 = profileForums["img2"].string { self.img5 = img5 }

        if let created_at = profileForums["created_at"].string { self.created_at = created_at }
        if let countComments = profileForums["countComments"].string { self.countComments = countComments }
        
    }
}
