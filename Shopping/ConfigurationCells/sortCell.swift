//
//  sortCell.swift
//  Shopping
//
//  Created by Mohamed El-Naggar on 9/4/18.
//  Copyright © 2018 Haseboty. All rights reserved.
//

import UIKit
import DropDown

class sortCell: DropDownCell {

    
    @IBOutlet weak var cellText: UILabel!
    
    @IBOutlet weak var cellImage: UIImageView!
    
    var selectedCell: Bool = false {
        didSet {
            cellImage.image = UIImage(named: "RadioSelected")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


}
