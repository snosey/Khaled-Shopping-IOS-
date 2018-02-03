//
//  imageCell.swift
//  Shopping
//
//  Created by Naggar on 11/16/17.
//  Copyright © 2017 Haseboty. All rights reserved.
//

import UIKit

class imageCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    
    var indexPath = IndexPath()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    // MARK: - Actions
    
    @IBAction func deleteSelectedImage(_ sender: Any) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "deleteCustomImage") , object: indexPath, userInfo: nil)

    }
}
