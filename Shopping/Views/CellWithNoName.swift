//
//  CellWithNoName.swift
//  Shopping
//
//  Created by Naggar on 11/23/17.
//  Copyright © 2017 Haseboty. All rights reserved.
//

import UIKit

class CellWithNoName: UICollectionViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var LoveCount: UILabel!
    @IBOutlet weak var isLoved: UIButton!
    @IBOutlet weak var Brand: UILabel!
    @IBOutlet weak var Size: UILabel!
    
    // MARK: - Variables
    var product: Product? {
        didSet {
            updateCellData()
        }
    }
    var productID = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    // MARK: - Methods
    func updateCellData() {
        
        self.price.text = "L.E \(product!.price)"
        self.LoveCount.text = product!.love
        
        
        if product!.isLove == "true" {
            self.isLoved.setImage(UIImage(named: "ic_lovefull"), for: .normal)
        } else {
            self.isLoved.setImage(UIImage(named: "ic_love"), for: .normal)
        }
        
        self.Brand.text = product!.brand
        self.Size.text = "\(self.product!.size_number)/\(product!.size)"
        
        self.productID = product!.id
        
        let path = Helper.removeSpaceFromString("\(Constants.Services.imagePath)\(product!.img1)")
        self.productImage.sd_setImage(with: URL(string: path), placeholderImage: UIImage(named: "loading"))
        
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
        var state = "remove"
        if sender.image(for: .normal) == UIImage(named: "ic_love") {
            state = "add"
        }
        
        WebServices.updateLove(state: state, idProduct: productID) { (success, Msg) in
            
            if success {
                self.isLoved.setImage(UIImage(named: (state == "remove" ? "ic_love" : "ic_lovefull")), for: .normal)
                
                if state == "remove" {
                    self.product!.love =
                    "\(Int(self.product!.love)! - 1 )"
                }  else {
                    self.product!.love =
                    "\(Int(self.product!.love)! + 1 )"
                }
                
                self.LoveCount.text = self.product!.love
                
            } else {
                Helper.showErrorMessage(Msg, showOnTop: false)
            }
        }
    }
}
