//
//  recieverCell.swift
//  Shopping
//
//  Created by Naggar on 11/28/17.
//  Copyright © 2017 Haseboty. All rights reserved.
//

import UIKit

class recieverCell: UITableViewCell {
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var MessageText: UILabel!
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var MessageContainer: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        Helper.ImageViewCircle(imageView: logo, 2.0)
        
        Helper.roundCorners(view: MessageContainer, cornerRadius: 5.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    
    }
}
