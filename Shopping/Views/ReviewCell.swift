//
//  ReviewCell.swift
//  Shopping
//
//  Created by Naggar on 11/26/17.
//  Copyright © 2017 Haseboty. All rights reserved.
//

import UIKit

class ReviewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var ReviewerName: UILabel!
    @IBOutlet weak var Rate: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var ReviewerLogo: UIImageView!
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var reviewComment: UILabel!
    
    var review: Review? {
        didSet {
            updateCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        
        deleteButton.isHidden = true
        Helper.ImageViewCircle(imageView: ReviewerLogo, 2.0)
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell() {
        
        ReviewerName.text = review!.name
        Rate.text = "Rate: \(review!.rate)/5"
        date.text = Helper.getDay(review!.created_at)
        
        ReviewerLogo.sd_setImage(with: URL(string: Helper.removeSpaceFromString("\(Constants.Services.imagePath)\(review!.logo)")), placeholderImage: UIImage(named: "profile")!)
        
        
        if review!.id_rate_client == UserStatus.clientID {
            
            deleteButton.isHidden = false
            
        } else {
            deleteButton.isHidden = true
        }
        
        
        reviewComment.text = review!.data
        
    }

}
