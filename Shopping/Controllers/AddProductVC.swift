//
//  AddProductVC.swift
//  Shopping
//
//  Created by Naggar on 11/9/17.
//  Copyright © 2017 Haseboty. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SwiftyJSON
import Photos
import RappleProgressHUD
import OpalImagePicker

class AddProductVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var titleTF: SkyFloatingLabelTextField!
    @IBOutlet weak var priceTF: SkyFloatingLabelTextField!
    
    /// MARK: - DESIGNED TEXT VIEW BY NAGGAR
    ///////////////////////////////
    @IBOutlet weak var descriptionTV: UITextView!
    @IBOutlet weak var descriptionPH: UILabel!
    @IBOutlet weak var descriptionLine: UIImageView!
    ///////////////////////////////
    
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var categoryType: UILabel!
    @IBOutlet weak var brandType: UILabel!
    @IBOutlet weak var sizeType: UILabel!
    @IBOutlet weak var firstColor: UILabel!
    @IBOutlet weak var secondColor: UILabel!
    @IBOutlet weak var secondColorView: UIView!
    @IBOutlet weak var firstColorView: UIView!
    
    @IBOutlet weak var conditionType: UILabel!
    @IBOutlet weak var location: UILabel!
    
    @IBOutlet weak var swapingImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
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
    
    
    var collectionData = [(UIImage , String)]()
    var selectedImagesName = [String]()
    var selectedImages = [UIImage]() {
        didSet {
            
            collectionData.removeAll()
            for index in 0 ..< selectedImages.count {
                collectionData.append((selectedImages[index] , selectedImagesName[index]))
            }
            
            collectionView.reloadData()
        }
    }
    
    public var jsonObject = JSON()
    var AddProductModel = AddProduct()
    var sizeKam = 0 // ZERO means hide , ONE means numbers , TWO means مقاسات
    var totalCount = 0
    
    var locationVC = GovernmentVC.storyBoardInstance()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        heightTop.constant = 0
        heightSize.constant = 0
        labelHeightSize.constant = 0
        sizeView.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(getThreeCategory(_:)), name: NSNotification.Name(rawValue: "ThreeCategory"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(getOtherTypes(_:)), name: NSNotification.Name(rawValue: "getOtherTypes"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(deleteCustomImage), name: NSNotification.Name(rawValue: "deleteCustomImage"), object: nil)

        
        setupView()
        
        loadContent()
    }
    
    // MARK: - Methods
    @objc func getThreeCategory(_ notification: Notification) {
        let val = notification.object as! ( String , String , String , String )
        
        print(val.0)
        print(val.1)
        print(val.2)
        categoryType.text = val.3
        
        // DATA Will sent to Backend
        AddProductModel.id_category1 = val.0
        AddProductModel.id_category2 = val.1
        AddProductModel.id_category3 = val.2
        
        if val.0 == "12" || val.0 == "11" || val.0 == "10" || val.1 == "106" || val.1 == "100" {
            
            sizeKam = 0
            AddProductModel.id_size = "36"
            
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
            
            sizeType.text = "( 31 ) "
            AddProductModel.id_size = "10"
            
        } else {
            sizeKam = 2 // Means show Size names
            heightSize.constant = 40
            heightTop.constant = 15
            labelHeightSize.constant = 15
            sizeView.isHidden = false
            
            sizeType.text = "Small "
            AddProductModel.id_size = "1"
        }
    }
    
    @objc func deleteCustomImage(_ notification: Notification) {
        
        let val = notification.object as! IndexPath
        
        collectionData.remove(at: val.row)
        selectedImagesName.remove(at: val.row)
        selectedImages.remove(at: val.row)
        collectionView.reloadData()
        
    }
    
    @objc func getOtherTypes(_ notification: Notification) {
        let val = notification.object as! (String , String , String , String , String)
        
        print(val)
        
        
        if val.2 == "1" {
            AddProductModel.id_brand = val.1
            brandType.text = val.0
        } else if val.2 == "2" {
            AddProductModel.id_size = val.1
            sizeType.text = val.0
        } else if val.2 == "3" {
            AddProductModel.id_color1 = val.1
            firstColor.text = val.0
            firstColorView.backgroundColor = UIColor(hexString: val.4)
            firstColorView.isHidden = false
        } else if val.2 == "4" {
            AddProductModel.id_color2 = val.1
            secondColor.text = val.0
            secondColorView.isHidden = false
            secondColorView.backgroundColor = UIColor(hexString: val.4)
        } else if val.2 == "5" {
            AddProductModel.id_condition_state = val.1
            conditionType.text = val.0
        } else if val.2 == "6" {
            AddProductModel.id_government = val.1
        } else {
            AddProductModel.id_city = val.1
            AddProductModel.id_government = val.3
            location.text = val.0
        }
    }
    
    
    func setupView() {
    
        Helper.ImageViewCircle(imageView: firstColorView, 2.0)
        Helper.ImageViewCircle(imageView: secondColorView, 2.0)

        Helper.roundCorners(view:categoryButton , cornerRadius: 10.0)
        
        descriptionTV.textColor = UIColor.lightGray
        descriptionTV.text = "Description"
        
        ////////// Initialize ProductMode With default data \\\\\\\\\\
        AddProductModel.id_brand = "1"
        AddProductModel.id_size = "1"
        AddProductModel.id_color1 = "3"
        AddProductModel.id_color2 = "3"
        AddProductModel.id_condition_state = "2"

        // Register Cell
        collectionView.register(UINib(nibName: "imageCell", bundle: nil), forCellWithReuseIdentifier: "imageCell")
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "getCategory" {
            let destVC = segue.destination as! PopUpMenuVC
            destVC.jsonObject = jsonObject
        }
        
        if segue.identifier == "brand" {
            
            let destVC = segue.destination as! DropDownVC
            destVC.tableData = getBrandTypes()
            destVC.frameTitle = "Choose Brand"
            destVC.type = 1
        }
        
        if segue.identifier == "size" {
            let destVC = segue.destination as! DropDownVC
            destVC.tableData = getSizeTypes()
            destVC.frameTitle = "Choose Size"
            destVC.type = 2
        }
        
        if segue.identifier == "firstColor" {
            let destVC = segue.destination as! DropDownVC
            destVC.tableData = getColor()
            destVC.colorCodes = getColorHexaCode()
            print(destVC.colorCodes)
            
            destVC.frameTitle = "Choose Color"
            destVC.type = 3
        }
        
        if segue.identifier == "secondColor" {
            let destVC = segue.destination as! DropDownVC
            destVC.tableData = getColor()
            destVC.colorCodes = getColorHexaCode()
            destVC.frameTitle = "Choose Color"
            destVC.type = 4
        }
        
        if segue.identifier == "condition" {
            let destVC = segue.destination as! DropDownVC
            destVC.tableData = getConditionTypes()
            destVC.frameTitle = "Choose Condition"
            destVC.type = 5
        }
        /*
        if segue.identifier == "location" {
//            let destVC = segue.destination as! DropDownVC
//            destVC.tableData = getGovernment()
//            destVC.frameTitle = "Choose Location"
//            destVC.jsonObjec = jsonObject["city"]
//            destVC.type = 6
        }
        */
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
    
    
    // MARK: - Actions
    
    @IBAction func interestedSwapping(_ sender: UIButton) {
        
        if AddProductModel.swap == "0" {
            swapingImageView.image = UIImage(named: "ic_checked")
            AddProductModel.swap = "1"
        } else {
            swapingImageView.image = UIImage(named: "ic_unchecked")
            AddProductModel.swap = "0"
        }
        
    }
    
    @IBAction func SelectLocation(_ sender: UIButton) {
        
        locationVC = GovernmentVC.storyBoardInstance()!
        
        locationVC?.governmentDelegate = self
        
        let governmentData = getGovernment()
        if governmentData.count > 0 {
            
            locationVC?.showGovernmentData = governmentData
            self.present(UINavigationController(rootViewController: locationVC!) , animated: true , completion: nil)
        }
        
    }
    
    
    @IBAction func addProduct(_ sender: UIButton) {
        
        
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
        
        if AddProductModel.id_category1 == "" {
            Helper.showErrorMessage("You must choose category!", showOnTop: false)
            return
        }
        
        if AddProductModel.id_government == "" {
            Helper.showErrorMessage("You must choose location!", showOnTop: false)
            return
        }
        
        
        print(AddProductModel)
        
        AddProductModel.title = title
        AddProductModel.price = price
        
        if collectionData.count >= 1 {
            AddProductModel.img1 = collectionData[0].1
        }
        
        if collectionData.count >= 2 {
            AddProductModel.img2 = collectionData[1].1
        }
        if collectionData.count >= 3 {
            AddProductModel.img3 = collectionData[2].1
        }
        
        if collectionData.count >= 4 {
            AddProductModel.img4 = collectionData[3].1
        }
        
        if collectionData.count >= 5 {
            AddProductModel.img5 = collectionData[4].1
        }
        
        
        

        ////////////// UPLOADING IMAGES ///////////////////////
        RappleActivityIndicatorView.startAnimatingWithLabel("Uploading Images...", attributes: RappleModernAttributes)

        WebServices.uploadImages(allImage: collectionData) { (success, Msg) in
            
            
            
            if success {
                
                self.totalCount += 1
                
                if self.totalCount == self.collectionData.count {
  
                    RappleActivityIndicatorView.stopAnimation()
            
                print(Msg)
                
                ////////////// UPLOADING PRODUCT DATA ///////////////////////
                WebServices.addProduct(addProduct: self.AddProductModel) { (success, Msg) in
                    if success {
                        // DONE
                        print("UPLOAD YOUR PRODUCT")
                        Helper.showSucces(Msg, showOnTop: false)
                        
                        WebServices.limit = 0
                        // Move to home
                        Initializer.createWindow().rootViewController = Initializer.createViewControllerWithId(storyBoardId: Constants.StoryBoardID.HomeTabBar)
                        
                    } else {
                        print(Msg)
                        Helper.showErrorMessage(Msg, showOnTop: false)
                    }
                }
                    
                }

            } else {
                Helper.showErrorMessage("Uploaded Failed , try later!", showOnTop: false)
            }
        }
    }
    
    
    
    @IBAction func AddImage(_ sender: UIButton) {
        
        if collectionData.count < 5 {
        
            let imagePicker = OpalImagePickerController()
            imagePicker.imagePickerDelegate = self
            present(imagePicker, animated: true, completion: nil)
        
        }  else {
            Helper.showErrorMessage("You can’t add more than 5 images", showOnTop: false)
        }
    }
}

extension AddProductVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = self.collectionView.frame.height
        
        return CGSize(width: height, height: height)
    }
    
}


extension AddProductVC: UICollectionViewDataSource {
    
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

extension AddProductVC: UITextViewDelegate {
    
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

extension AddProductVC: OpalImagePickerControllerDelegate {
    
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingImages images: [UIImage]) {
        
        print("Welcome")
        
        if images.count + collectionData.count > 5 {
            Helper.showErrorMessage("You can’t add more than 5 images", showOnTop: false)
            
        } else {
            
            selectedImages.append(contentsOf: images)
            
            picker.dismiss(animated: true, completion: nil)
            collectionView.reloadData()
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
            
            print("\(name)\(dateString)\(exten)")
            
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


extension AddProductVC: GovernmentCityDelegate {
    
    func didCancel() {
        
        print("Did Cancel")
        locationVC?.dismiss(animated: true, completion: nil)
    }
    
    func didOccursError(_ errorMsg: String) {
        Helper.showErrorMessage(errorMsg, showOnTop: false)
        locationVC?.dismiss(animated: true, completion: nil)
    }
    
    func didSelectRow(_ rowData: (String, String) , _ time: Int) {
        print(rowData)
        print(time)
        
        if time == 1 { // IF TIME is set to 1 --> Government ID
            
            AddProductModel.id_government = rowData.1 // As Government id
            location.text = rowData.0 // as Government  name
            
            // Try to fetch Which City
            let cities = getCityByGovernment(governmentID: AddProductModel.id_government)
            
            if cities.count > 0 {
                locationVC?.showGovernmentData = cities
                locationVC?.reloadTableViewData()
                
            } else {
                locationVC?.dismiss(animated: true, completion: nil)
            }
            
        } else {
            
            AddProductModel.id_city = rowData.1 // as City ID
            location.text = rowData.0 // as City name
            
            // Dismiss GovernmentVC
            locationVC?.dismiss(animated: true, completion: nil)
            
        }
        
    }
    
}
