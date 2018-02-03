//
//  FollowersCell.swift
//  Shopping
//
//  Created by Naggar on 11/25/17.
//  Copyright © 2017 Haseboty. All rights reserved.
//

import UIKit

class FollowersCell: UITableViewCell {
    
    // MARK: - Outlets

    @IBOutlet weak var followerName: UILabel!
    @IBOutlet weak var followerLogo: UIImageView!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    var id = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        Helper.ImageViewCircle(imageView: followerLogo, 2.0)
        Helper.roundCorners(view: followButton, cornerRadius: 10.0)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    // MARK: - Action
    @IBAction func followThisClient(_ sender: UIButton) {
        
        var state = "remove"
        
        if followButton.title(for: .normal) == "Follow" {
            state = "add"
        }
        
        WebServices.updateFollow(clientID: id, state: state) { (success, Msg) in
            if success {
                
                if state == "add" {
                    self.followButton.setTitle("Following", for: .normal)
                } else {
                    self.followButton.setTitle("Follow", for: .normal)
                }
                Helper.showSucces("Added to your following list", showOnTop: false)
                
            } else {
                
                Helper.showErrorMessage(Msg!, showOnTop: false)
                
            }
        }
    }
}
