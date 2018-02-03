//
//  roundedImage.swift
//  Shopping
//
//  Created by Naggar on 1/15/18.
//  Copyright © 2018 Haseboty. All rights reserved.
//

import UIKit

class roundedImage: UIImageView {
    
    
    override func draw(_ rect: CGRect) {
        
        // roundCorner()
    }
    
    func roundCorner() {
        
        self.layer.cornerRadius = self.frame.size.width / 2.0
        self.clipsToBounds = true
        
    }
 

}
