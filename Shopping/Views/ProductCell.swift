//
//  ProductCell.swift
//  Shopping
//
//  Created by Naggar on 11/11/17.
//  Copyright © 2017 Haseboty. All rights reserved.
//

import UIKit
import SDWebImage

class ProductCell: UICollectionViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var isLoved: UIButton!
    @IBOutlet weak var Brand: UILabel!
    @IBOutlet weak var Size: UILabel!
    @IBOutlet weak var loveImage: UIImageView!
    @IBOutlet weak var loveButtonView: UIView!
    @IBOutlet weak var rotate: UIImageView!
    
    // MARK: - Variables
    var product: Product? {
        didSet {
            updateCellData()
        }
    }
    var productID = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        Helper.ImageViewCircle(imageView: profilePic, 2.0)
        
        // Helper.makeUIViewShadow(containerView: loveButtonView)
        
        loveButtonView.layer.applySketchShadow(y: 0 , spread: 2, radius : 15)

        
    }
    
    // MARK: - Methods
    func updateCellData() {
        
        self.name.text = product!.name
        self.price.text = "\(product!.price) L.E"
        
        if product!.swap == "1" {
            
            rotate.isHidden = false
            
        }
    
        if product!.isLove == "true" {
            // self.isLoved.setImage(UIImage(named: "ic_lovefull"), for: .normal)
            loveImage.image = UIImage(named: "ic_lovefull")
        } else {
            // self.isLoved.setImage(UIImage(named: "ic_love"), for: .normal)
            loveImage.image = UIImage(named: "ic_love")
        }
        
        self.Brand.text = product!.brand
        self.Size.text = "\(product!.size)"
        
        self.productID = product!.id
        
        let pathProfilePic = Helper.removeSpaceFromString("\(Constants.Services.imagePath)\(product!.logo)")
        self.profilePic.sd_setImage(with: URL(string: pathProfilePic), placeholderImage: UIImage(named: "profile"))
        
        let pathProductImage = Helper.removeSpaceFromString("\(Constants.Services.imagePath)\(product!.img1)")
        
        self.productImage.sd_setImage(with: URL(string: pathProductImage), placeholderImage: UIImage(named: "loading"))

    }
    
    func downloadImage(name: String) -> UIImage? {
        
        var returnedImage: UIImage?
        WebServices.downloadImage(name: name) { (success, image) in
            if success {
                returnedImage = image
                
            } else {
                returnedImage = nil
            }
        }
        return returnedImage
    }
    
    // MARK: - Actions
    @IBAction func LoveAction(_ sender: UIButton) {
        
        guard UserStatus.clientID != product!.id_client else {
            
            Helper.showWarning("You can make your item as a favourite!", showOnTop: false)
            
            return 
        }
        
        var state = "remove"
        
        if loveImage.image == UIImage(named: "ic_love") {
            state = "add"
        }
        
        WebServices.updateLove(state: state, idProduct: productID) { (success, Msg) in
            
            if success {
                
                self.loveImage.image = UIImage(named: (state == "remove" ? "ic_love" : "ic_lovefull"))
                
                if state == "remove" {
                    self.product!.love = "\(Int(self.product!.love)! - 1)"
                } else {
                    self.product!.love = "\(Int(self.product!.love)! + 1)"
                }
                
            } else {
                Helper.showErrorMessage(Msg, showOnTop: false)
            }
        }
        
    }
}
