//
//  UpdateProductVC.swift
//  Shopping
//
//  Created by Naggar on 12/1/17.
//  Copyright © 2017 Haseboty. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import OpalImagePicker
import Photos
import SwiftyJSON
import SDWebImage

class UpdateProductVC: UIViewController {
    
    // MARK: - Outlets

    @IBOutlet weak var imagesCollection: UICollectionView!
    
    @IBOutlet weak var titleTF: SkyFloatingLabelTextField!
    @IBOutlet weak var priceTF: SkyFloatingLabelTextField!
    
    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var brandTitle: UILabel!
    @IBOutlet weak var sizeTitle: UILabel!
    
    @IBOutlet weak var firstColorTitle: UILabel!
    
    @IBOutlet weak var secondColorTitle: UILabel!
    
    @IBOutlet weak var firstColorView: UIView!
    @IBOutlet weak var secondColorView: UIView!
    
    @IBOutlet weak var conditionTitle: UILabel!
    @IBOutlet weak var locationTitle: UILabel!
    
    @IBOutlet weak var swappingImage: UIImageView!
    @IBOutlet weak var alertView: UIView!
    
    /// MARK: - DESIGNED TEXT VIEW BY NAGGAR
    ///////////////////////////////
    @IBOutlet weak var descriptionTV: UITextView!
    @IBOutlet weak var descriptionPH: UILabel!
    @IBOutlet weak var descriptionLine: UIImageView!
    ///////////////////////////////
    
    
    // HIDE IF ////
    @IBOutlet weak var heightSize: NSLayoutConstraint!
    @IBOutlet weak var heightTop: NSLayoutConstraint!
    @IBOutlet weak var labelHeightSize: NSLayoutConstraint!
    @IBOutlet weak var sizeView: UIView!
    /*
     
     
     category1_id.equals("12")
     category1_id.equals("11")
     category1_id.equals("10")
     
     hide size spinner
     __________________________
     category1_id.equals("9")
     
     show size spinner with just numbers
     anything else  show size names
     category2_id.equals("106")
     category2_id.equals("100")
     
     hide size spinner
     category2_id.equals("95")
     
     show size spinner with just numbers
     
     */
    
    // MARK: - Variables
    public var jsonObject = JSON()
    var productID = ""
    
    var productModel: EditProduct?
    var sizeKam = 0 // ZERO means hide , ONE means numbers , TWO means مقاسات
    
    var collectionData = [(UIImage , String)]()
    var selectedImagesName = [String]()
    
    var selectedImages = [UIImage]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        heightTop.constant = 0
        heightSize.constant = 0
        labelHeightSize.constant = 0
        sizeView.isHidden = true

        
        NotificationCenter.default.addObserver(self, selector: #selector(deleteCustomImage), name: NSNotification.Name(rawValue: "deleteCustomImage"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(getThreeCategory(_:)), name: NSNotification.Name(rawValue: "ThreeCategory"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(getOtherTypes(_:)), name: NSNotification.Name(rawValue: "getOtherTypes"), object: nil)


        WebServices.editProductData(productID: productID) { (success, product) in
            if success {
                
                self.productModel = product!
                
                self.getAllImage(self.productModel!)
                self.setProductModel(self.productModel!)
                
                
            } else {
                
                Helper.showErrorMessage("Error while loading Product Details", showOnTop: false)
                
            }
        }
        
        
        setupView()
        
        loadContent()
    }
    
    
    // MARK: - Methods
    func setupView() {
        
        Helper.ImageViewCircle(imageView: firstColorView, 2.0)
        Helper.ImageViewCircle(imageView: secondColorView, 2.0)
        firstColorView.isHidden = true
        secondColorView.isHidden = true

        
        Helper.roundCorners(view: categoryButton, cornerRadius: 10.0)
        
        descriptionTV.textColor = UIColor.lightGray
        descriptionTV.text = "Description"
        
        
        imagesCollection.register(UINib(nibName: "imageCell", bundle: nil), forCellWithReuseIdentifier: "imageCell")

    }
    
    func downloadImage(name: String)  {
        
        WebServices.downloadImage(name: Helper.removeSpaceFromString(name)) { (success, image) in
            if success {
                
                self.selectedImagesName.append(name)
                self.selectedImages.append(image!)
                
                self.collectionData.append((image! , name))
                self.imagesCollection.reloadData()

                
            }
        }
        
    }
    
    func getAllImage(_ productDetails: EditProduct) {
        
        if productDetails.img1 != " " {

            downloadImage(name: productDetails.img1)
            
        }
        
        if productDetails.img2 != " " {
            
            downloadImage(name: productDetails.img2)

        }
        
        if productDetails.img3 != " " {
            
            downloadImage(name: productDetails.img3)

        }
        
        if productDetails.img4 != " " {
            downloadImage(name: productDetails.img4)
        }
        
        if productDetails.img5 != " " {
            
            downloadImage(name: productDetails.img5)
        }

        print(collectionData.count)
        
        imagesCollection.reloadData()
        
    }
    
    func setProductModel(_ productDetails: EditProduct) {
        
        if productDetails.category1 == "12" || productDetails.category1 == "11" || productDetails.category1 == "10" || productDetails.category2 == "106" || productDetails.category2 == "100" {
            
            sizeKam = 0
            productModel!.id_size = "36"
            
            heightSize.constant = 0
            heightTop.constant = 0
            labelHeightSize.constant = 0
            sizeView.isHidden = true
            
        } else if productDetails.category1 == "9" || productDetails.category3 == "95" {
            
            sizeKam = 1
            heightSize.constant = 40
            heightTop.constant = 15
            labelHeightSize.constant = 15
            sizeView.isHidden = false
            
            sizeTitle.text = "( 31 ) "
            productModel!.id_size = "10"
            
        } else {
            sizeKam = 2 // Means show Size names
            heightSize.constant = 40
            heightTop.constant = 15
            labelHeightSize.constant = 15
            sizeView.isHidden = false
            
            sizeTitle.text = "Small "
            productModel!.id_size = "1"
        }

        
        self.titleTF.text = productDetails.title
        self.priceTF.text = productDetails.price
        self.descriptionTV.text = (productDetails.description == "" ? "Description" : productDetails.description)
        self.brandTitle.text = productDetails.brand
        self.sizeTitle.text = productDetails.size
        self.locationTitle.text = productDetails.city
        self.firstColorTitle.text = productDetails.color1
        self.secondColorTitle.text = productDetails.color2
        
        print(productDetails.category3)
        print(productDetails.id_category3)
        
        
        if productDetails.category3 == "" && productDetails.id_category3 == "2" {
            self.categoryTitle.text = productDetails.category2
            
        } else {
            self.categoryTitle.text = productDetails.category3
        }
        
        if productDetails.swap == "1" {
            swappingImage.image = UIImage(named: "ic_checked")
        } else {
            swappingImage.image = UIImage(named: "ic_unchecked")
        }
    }
    
    @objc func getThreeCategory(_ notification: Notification) {
        let val = notification.object as! (String , String , String , String )
        
        print(val.0)
        print(val.1)
        print(val.2)
        categoryTitle.text = val.3
        
        // DATA Will sent to Backend
        productModel!.id_category1 = val.0
        productModel!.id_category2 = val.1
        productModel!.id_category3 = val.2
        
        if val.0 == "12" || val.0 == "11" || val.0 == "10" || val.1 == "106" || val.1 == "100" {
            
            sizeKam = 0
            productModel!.id_size = "36"
            
            heightSize.constant = 0
            heightTop.constant = 0
            labelHeightSize.constant = 0
            sizeView.isHidden = true
            
        } else if val.0 == "9" || val.2 == "95" {
            
            sizeKam = 1
            heightSize.constant = 40
            heightTop.constant = 15
            labelHeightSize.constant = 15
            sizeView.isHidden = false
            
            sizeTitle.text = "( 31 ) "
            productModel!.id_size = "10"
            
        } else {
            sizeKam = 2 // Means show Size names
            heightSize.constant = 40
            heightTop.constant = 15
            labelHeightSize.constant = 15
            sizeView.isHidden = false
            
            sizeTitle.text = "Small "
            productModel!.id_size = "1"
        }

        
    }
    
    @objc func getOtherTypes(_ notification: Notification) {
        let val = notification.object as! (String , String , String , String , String)
        
        if val.2 == "1" {
            productModel!.id_brand = val.1
            brandTitle.text = val.0
        } else if val.2 == "2" {
            productModel!.id_size = val.1
            sizeTitle.text = val.0
        } else if val.2 == "3" {
            productModel!.id_color1 = val.1
            firstColorTitle.text = val.0
            firstColorView.backgroundColor = UIColor(hexString: val.4)
            firstColorView.isHidden = false
        } else if val.2 == "4" {
            productModel!.id_color2 = val.1
            secondColorTitle.text = val.0
            secondColorView.backgroundColor = UIColor(hexString: val.4)
            secondColorView.isHidden = false

        } else if val.2 == "5" {
            productModel!.id_condition_state = val.1
            conditionTitle.text = val.0
        } else if val.2 == "6" {
            productModel!.id_government = val.1
        } else {
            productModel!.id_city = val.1
            productModel!.id_government = val.3
            locationTitle.text = val.0
        }
        
    }
    func getBrandTypes() -> [(String , String)] {
        var items = [(String , String)]()
        
        if let brands = jsonObject["brands"].array {
            
            for brand in brands {
                
                if let name = brand["name"].string {
                    if let id = brand["id"].string {
                        items.append((name , id))
                    }
                }
            }
        }
        
        return items
    }
    
    func getSizeTypes() -> [(String , String)] {
        var items = [(String , String)]()
        
        if let brands = jsonObject["size"].array {
            
            for brand in brands {
                
                if let name = brand["name"].string {
                    if let id = brand["id"].string {
                        items.append((name , id))
                    }
                }
            }
        }
        
        print(items)
        
        var returnedItems = [(String , String)]()
        if sizeKam == 1 {
            
            for index in 8..<items.count {
                returnedItems.append(items[index])
            }
            
        } else {
            
            for index in 1..<8 {
                returnedItems.append(items[index])
            }
            
        }
        
        
        return returnedItems
    }
    
    func getColor() -> [(String , String)] {
        var items = [(String , String)]()
        
        if let brands = jsonObject["color"].array {
            
            for brand in brands {
                
                if let name = brand["color"].string {
                    if let id = brand["id"].string {
                        items.append((name , id))
                    }
                }
            }
        }
        
        return items
    }
    
    func getColorHexaCode() -> [String] {
        var result = [String]()
        
        if let brands = jsonObject["color"].array {
            
            for brand in brands {
                
                if let colorCode = brand["colorCode"].string {
                    result.append(colorCode)
                }
            }
        }
        return result
    }
    
    func getConditionTypes() -> [(String , String)] {
        
        var items = [(String , String)]()
        
        if let brands = jsonObject["condition"].array {
            
            for brand in brands {
                
                if let name = brand["title"].string {
                    if let id = brand["id"].string {
                        items.append((name , id))
                    }
                }
            }
        }
        
        return items
        
    }
    
    func getGovernment() -> [(String , String)] {
        
        var items = [(String , String)]()
        
        if let brands = jsonObject["government"].array {
            
            for brand in brands {
                
                if let name = brand["name"].string {
                    if let id = brand["id"].string {
                        items.append((name , id))
                    }
                }
            }
        }
        
        return items
        
    }
    
    func getCityByGovernment(governmentID: String) -> [(String , String)] {
        var items = [(String , String)]()
        
        if let brands = jsonObject["city"][governmentID].array {
            
            for brand in brands {
                
                if let name = brand["name"].string {
                    if let id = brand["id"].string {
                        items.append((name , id))
                    }
                }
            }
        }
        
        return items
    }
    

    
    func loadContent() {
        
        WebServices.loadProductContent { (err, json) in
            
            if err == nil {
                self.jsonObject = json!
            } else {
                Helper.showErrorMessage(err!.localizedDescription, showOnTop: false)
            }
        }
    }
    
    @objc func deleteCustomImage(_ notification: Notification) {
        let val = notification.object as! IndexPath
        print(collectionData.count)
        print(selectedImagesName.count)
        print(selectedImages.count)
        
        
        collectionData.remove(at: val.row)
        selectedImagesName.remove(at: val.row)
        selectedImages.remove(at: val.row)
        imagesCollection.reloadData()
    }
    
    // MARK: - Actions
    @IBAction func selectImages(_ sender: UIButton) {
        
        if collectionData.count < 5 {
            
            let imagePicker = OpalImagePickerController()
            imagePicker.imagePickerDelegate = self
            present(imagePicker, animated: true, completion: nil)
            
        }  else {
            Helper.showErrorMessage("You can’t add more than 5 images", showOnTop: false)
        }
    }

    @IBAction func ChooseCategory(_ sender: UIButton) {
        
        let vc = Initializer.createViewControllerWithId(storyBoardId: Constants.StoryBoardID.PopUpMenuVC) as! PopUpMenuVC
        
        vc.jsonObject = jsonObject
        self.present(vc, animated: false, completion: nil)
        
        
    }
    @IBAction func SelectBrand(_ sender: UIButton) {
        let vc = Initializer.createViewControllerWithId(storyBoardId: Constants.StoryBoardID.tChooseXXXXVC) as! DropDownVC
        
        vc.tableData = getBrandTypes()
        vc.frameTitle = "Choose Brand"
        vc.type = 1
        self.present(vc, animated: false, completion: nil)

    }
    
    @IBAction func SelectSize(_ sender: UIButton) {
        let vc = Initializer.createViewControllerWithId(storyBoardId: Constants.StoryBoardID.tChooseXXXXVC) as! DropDownVC
        
        vc.tableData = getSizeTypes()
        vc.frameTitle = "Choose Size"
        vc.type = 2
        self.present(vc, animated: false, completion: nil)

    }
    
    
    @IBAction func SelectFirstColor(_ sender: UIButton) {
        let vc = Initializer.createViewControllerWithId(storyBoardId: Constants.StoryBoardID.tChooseXXXXVC) as! DropDownVC

        vc.tableData = getColor()
        vc.colorCodes = getColorHexaCode()
        vc.frameTitle = "Choose Color"
        vc.type = 3
        self.present(vc, animated: false, completion: nil)

    }
    @IBAction func SelectSecondColor(_ sender: UIButton) {
        let vc = Initializer.createViewControllerWithId(storyBoardId: Constants.StoryBoardID.tChooseXXXXVC) as! DropDownVC

        vc.tableData = getColor()
        vc.colorCodes = getColorHexaCode()
        vc.frameTitle = "Choose Color"
        vc.type = 4
        self.present(vc, animated: false, completion: nil)

    }
    @IBAction func SelectCondition(_ sender: UIButton) {
        let vc = Initializer.createViewControllerWithId(storyBoardId: Constants.StoryBoardID.tChooseXXXXVC) as! DropDownVC
        
        vc.tableData = getConditionTypes()
        vc.frameTitle = "Choose Condition"
        vc.type = 5
        self.present(vc, animated: false, completion: nil)

        
    }
    @IBAction func ChooseLocation(_ sender: UIButton) {
        let vc = Initializer.createViewControllerWithId(storyBoardId: Constants.StoryBoardID.tChooseXXXXVC) as! DropDownVC
        
        vc.tableData = getGovernment()
        vc.frameTitle = "Choose Location"
        vc.type = 6
        vc.jsonObjec = jsonObject["city"]
        self.present(vc, animated: false, completion: nil)
        
    }
    
    @IBAction func SelectSwapping(_ sender: UIButton) {
        
        if productModel!.swap == "0" {
            swappingImage.image = UIImage(named: "ic_checked")
            productModel!.swap = "1"
        } else {
            swappingImage.image = UIImage(named: "ic_unchecked")
            productModel!.swap = "0"
        }

        
        
    }
    
    @IBAction func EditProduct(_ sender: UIButton) {
        if collectionData.count == 0 {
            Helper.showErrorMessage("Please select at least 1 image", showOnTop: false)
            return
        }
        
        guard let title = titleTF.text , title != "" else {
            Helper.showErrorMessage("Please enter title!", showOnTop: false)
            return
        }
        
        
        guard let price = priceTF.text , price != "" else {
            Helper.showErrorMessage("Please enter Price!", showOnTop: false)
            return
        }

        productModel!.title = titleTF.text!
        productModel!.price = priceTF.text!
        productModel!.description = descriptionTV.text!
        
        productModel!.img1 = " "
        productModel!.img2 = " "
        productModel!.img3 = " "
        productModel!.img4 = " "
        productModel!.img5 = " "
        
        // 5 IMAGES
        if collectionData.count >= 1 {
            productModel!.img1 = "\(collectionData[0].1)"
            print("IMAGE 1 \(productModel!.img1)")
        }
        if collectionData.count >= 2 {
            productModel!.img2 = "\(collectionData[1].1)"
            print("IMAGE 2 \(productModel!.img2)")
        }
        if collectionData.count >= 3 {
            productModel!.img3 = "\(collectionData[2].1)"
            print("IMAGE 3 \(productModel!.img3)")
        }
        if collectionData.count >= 4 {
            productModel!.img4 = "\(collectionData[3].1)"
            print("IMAGE 4 \(productModel!.img4)")
        }
        if collectionData.count >= 5 {
            productModel!.img5 = "\(collectionData[4].1)"
            print("IMAGE 5 \(productModel!.img5)")
        }
        
        WebServices.updateProductData(productID: productID, product: productModel!) { (success) in
            if success {
            
                WebServices.uploadImages(allImage: self.collectionData, completion: { (success, msg) in
                    if success {
                        Helper.showSucces("Updated Successfully", showOnTop: false)
                        WebServices.limit = 0
                        WebServices.limitSearch = 0
                        WebServices.limitFavProduct = 0
                        WebServices.limitClientProduct = 0
                        WebServices.limitSimilarProduct = 0

                        self.dismiss(animated: false, completion: nil)
                        
                    } else {
                        Helper.showErrorMessage("Error while uploading Photos", showOnTop: false)
                    }
                })
                
                
            } else {
                
                
                Helper.showErrorMessage("Error while Update product", showOnTop: false)
            }
        }
        
        
        
        
    }
    
    @IBAction func DeleteProduct(_ sender: UIButton) {
        
        alertView.isHidden = false
        
    }
    
    @IBAction func YesAlertAction(_ sender: UIButton) {
        
        WebServices.deleteProduct(productID: productID) { (success, Msg) in
            if success {
                
                Helper.showSucces("Deleted Successfully", showOnTop: false)
                
                Initializer.createWindow().rootViewController = Initializer.createViewControllerWithId(storyBoardId: Constants.StoryBoardID.HomeTabBar) as! UITabBarController
                
                
            } else {
                Helper.showErrorMessage(Msg!, showOnTop: false)
            }
        }
        

    }
    @IBAction func NoAlertAction(_ sender: UIButton) {
        
        alertView.isHidden = true

    }
    
    @IBAction func DismissVC(_ sender: UIBarButtonItem) {
        
        WebServices.limit = 0
        WebServices.limitSearch = 0
        WebServices.limitFavProduct = 0
        WebServices.limitClientProduct = 0
        WebServices.limitSimilarProduct = 0

        
        self.dismiss(animated: false, completion: nil)
    }
    
    
}

extension UpdateProductVC: OpalImagePickerControllerDelegate {
    
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingImages images: [UIImage]) {
        
        print("Welcome")
        
        if images.count + collectionData.count > 5 {
            Helper.showErrorMessage("You can’t add more than 5 images", showOnTop: false)
            
        } else {
            
            selectedImages.append(contentsOf: images)
            collectionData.removeAll()
            
            for index in 0 ..< selectedImages.count {
                collectionData.append((selectedImages[index] , selectedImagesName[index]))
            }
            
            picker.dismiss(animated: true, completion: nil)
            imagesCollection.reloadData()
        }
    }
    
    func imagePickerDidCancel(_ picker: OpalImagePickerController) {
        
        print("User Cancel")
        
    }
    
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingAssets assets: [PHAsset]) {
        
        
        for asset in assets {
            let date = Date()
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone.current
            formatter.dateFormat = "yyyMMddHHmmss"
            
            let dateString = formatter.string(from: date)
            let file = getNameWithoutExtension(name: asset.value(forKey: "filename") as! String)
            let name = file.0
            let exten = file.1
            
            selectedImagesName.append("\(name)\(dateString)\(exten)")
        }
    }
    
    
    func getNameWithoutExtension(name: String) -> (String , String) {
        
        var output = name , exten = ""
        
        while(output.last != ".") {
            
            exten = "\(output.last!)\(exten)"
            output.removeLast()
            
        }
        
        exten = "\(output.last!)\(exten)"
        
        output.removeLast()
        
        return (output  , exten)
    }
}

extension UpdateProductVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if descriptionTV.textColor == UIColor.lightGray && descriptionTV.isFirstResponder {
            descriptionTV.text = nil
            descriptionTV.textColor = UIColor.black
            descriptionPH.isHidden = false
            descriptionLine.backgroundColor = UIColor.black
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if descriptionTV.text.isEmpty || descriptionTV.text == "" {
            descriptionTV.textColor = UIColor.lightGray
            descriptionTV.text = "Description"
            descriptionPH.isHidden = true
            descriptionLine.backgroundColor = UIColor.lightGray
        }
    }
}


extension UpdateProductVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? imageCell {
            
            cell.imageView.image = collectionData[indexPath.row].0
            cell.indexPath = indexPath
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
}

extension UpdateProductVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = self.imagesCollection.frame.height
        
        return CGSize(width: height, height: height)
    }
    
}
