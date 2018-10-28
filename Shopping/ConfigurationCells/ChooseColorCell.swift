//
//  ChooseColorCell.swift
//  Shopping
//
//  Created by Mohamed El-Naggar on 9/6/18.
//  Copyright © 2018 Haseboty. All rights reserved.
//

import UIKit
import DropDown

class ChooseColorCell: DropDownCell {

    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var colorView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        colorView.layer.cornerRadius = self.colorView.frame.width / 2.0
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
