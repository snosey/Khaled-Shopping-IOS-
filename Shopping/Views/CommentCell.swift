//
//  CommentCell.swift
//  Shopping
//
//  Created by Naggar on 11/23/17.
//  Copyright © 2017 Haseboty. All rights reserved.
//

import UIKit
import SDWebImage


class CommentCell: UITableViewCell {
    
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    

    
    var commentDetails: Comment? {
        didSet {
            self.name.text = commentDetails!.name
            self.comment.text = commentDetails!.comment
            self.date.text = Helper.getDay(commentDetails!.created_at)
            
            let path = Helper.removeSpaceFromString("\(Constants.Services.imagePath)\(commentDetails!.logo)")
            logoImage.sd_setImage(with: URL(string: path), placeholderImage: UIImage(named: "profile"))
            
            deleteButton.isHidden = (UserStatus.clientID != commentDetails!.id_client)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
