//
//  FilterVC.swift
//  Shopping
//
//  Created by Naggar on 12/2/17.
//  Copyright © 2017 Haseboty. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftRangeSlider

class FilterVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var rangeSlider: RangeSlider!
    
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var categoryTitle: UILabel!
    
    @IBOutlet weak var brandTitle: UILabel!
    @IBOutlet weak var sizeTitle: UILabel!
    @IBOutlet weak var firstColorTitle: UILabel!
    @IBOutlet weak var secondColorTitle: UILabel!
    
    @IBOutlet weak var firstColorView: UIView!
    @IBOutlet weak var secondColorView: UIView!
    
    @IBOutlet weak var conditionTitle: UILabel!
    @IBOutlet weak var locationTitle: UILabel!
    
    
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

    
    
    var jsonObjct = JSON()
    var filterData = Filter()
    var sizeKam = 0 // ZERO means hide , ONE means numbers , TWO means مقاسات

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.rangeSlider.updateLayerFramesAndPositions()

        NotificationCenter.default.addObserver(self, selector: #selector(getThreeCategory(_:)), name: NSNotification.Name(rawValue: "ThreeCategoryFilter"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(getOtherTypes(_:)), name: NSNotification.Name(rawValue: "getFilterTypes"), object: nil)
        
        rangeSlider.addTarget(self, action: #selector(FilterVC.rangeSliderValueChanged), for: .valueChanged)


        Helper.roundCorners(view: categoryButton, cornerRadius: 10.0)
        
        
        Helper.ImageViewCircle(imageView: firstColorView, 2.0)
        Helper.ImageViewCircle(imageView: secondColorView, 2.0)
        firstColorView.isHidden = true
        secondColorView.isHidden = true

        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.rangeSlider.updateLayerFramesAndPositions()
        
        WebServices.loadProductContent { (error, jsonObjc) in
            if error == nil {
                self.jsonObjct = jsonObjc!
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.rangeSlider.updateLayerFramesAndPositions()

    }
    

    // MARK: - Methods
    @objc func rangeSliderValueChanged() {
        

    }
    
    @objc func getThreeCategory(_ notification: Notification) {
        
        let val = notification.object as! (String , String , String , String)
        
        print(val.0)
        print(val.1)
        print(val.2)
        print(val.3)
        
        categoryTitle.text = val.3
        
        filterData.id_category1 = val.0
        filterData.id_category2 = val.1
        filterData.id_category3 = val.2
        
        if val.0 == "12" || val.0 == "11" || val.0 == "10" || val.1 == "106" || val.1 == "100" {
            
            sizeKam = 0
            filterData.id_size = "-1"
            
            heightSize.constant = 0
            heightTop.constant = 0
            labelHeightSize.constant = 0
            sizeView.isHidden = true
            
        } else if val.0 == "9" || val.2 == "95" {
            
            sizeKam = 1
            heightSize.constant = 40
            heightTop.constant = 10
            labelHeightSize.constant = 15
            sizeView.isHidden = false
            
            sizeTitle.text = "( 31 ) "
            filterData.id_size = "10"
            
        } else if val.0 == "-1" {
        
            sizeKam = 3
            heightSize.constant = 40
            heightTop.constant = 10
            labelHeightSize.constant = 15
            sizeView.isHidden = false
        } else {
            sizeKam = 2 // Means show Size names
            heightSize.constant = 40
            heightTop.constant = 10
            labelHeightSize.constant = 15
            sizeView.isHidden = false
            
            sizeTitle.text = "Small "
            filterData.id_size = "1"
        }

        
        
        
    }
    
    @objc func getOtherTypes(_ notification: Notification) {
        let val = notification.object as! (String , String , String , String , String)
        
        if val.2 == "1" {
            filterData.id_brand = val.1
            brandTitle.text = val.0
        } else if val.2 == "2" {
            filterData.id_size = val.1
            sizeTitle.text = val.0
        } else if val.2 == "3" {
            filterData.id_color1 = val.1
            firstColorTitle.text = val.0
            
            firstColorView.isHidden = false
            firstColorView.backgroundColor = UIColor(hexString: val.4)

        } else if val.2 == "4" {
            filterData.id_color2 = val.1
            secondColorTitle.text = val.0
            
            secondColorView.isHidden = false
            secondColorView.backgroundColor = UIColor(hexString: val.4)

        } else if val.2 == "5" {
            filterData.id_condition_state = val.1
            conditionTitle.text = val.0
        } else if val.2 == "6" {
            filterData.id_government = val.1
        } else {
            filterData.id_city = val.1
            filterData.id_government = val.3
            locationTitle.text = val.0
        }
    }
    
    func getBrandTypes() -> [(String , String)] {
        var items = [(String , String)]()
        
        if let brands = jsonObjct["brands"].array {
            
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
        
        if let brands = jsonObjct["size"].array {
            
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
            
        } else if sizeKam == 2 {
            
            for index in 1..<8 {
                returnedItems.append(items[index])
            }
            
        } else {
            return items
        }
        
        
        return returnedItems
    }
    
    func getColor() -> [(String , String)] {
        var items = [(String , String)]()
        
        if let brands = jsonObjct["color"].array {
            
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
        
        if let brands = jsonObjct["color"].array {
            
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
        
        if let brands = jsonObjct["condition"].array {
            
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
        
        if let brands = jsonObjct["government"].array {
            
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
        
        if let brands = jsonObjct["city"][governmentID].array {
            
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
    
    @IBAction func SelectCategory(_ sender: UIButton) {
        
        let ChooseCategoryFilterNav = Initializer.createViewControllerWithId(storyBoardId: "ChooseCategoryFilterNav") as! UINavigationController
        
        if let chooseCaVC = ChooseCategoryFilterNav.viewControllers[0] as? ChooseCategoryFilterVC {
        
            chooseCaVC.jsonObject = jsonObjct
        
            self.present(ChooseCategoryFilterNav, animated: false, completion: nil)
        }
        
    }
    
    @IBAction func SelectBrand(_ sender: UIButton) {
        
        let ChooseOtherNav = Initializer.createViewControllerWithId(storyBoardId: "ChooseOtherNav") as! UINavigationController
        
        if let chooseOtherVC = ChooseOtherNav.viewControllers[0] as? ChooseOtherVC {
            
            chooseOtherVC.type = 1
            chooseOtherVC.frameTitle = "Choose Brand Type"
            chooseOtherVC.jsonObjec = jsonObjct
            chooseOtherVC.tableData = [("All" , "-1")]
            chooseOtherVC.tableData.append(contentsOf: getBrandTypes())
            
            self.present(ChooseOtherNav, animated: false, completion: nil)
        }
    }
    
    @IBAction func SelectSize(_ sender: UIButton) {
        let ChooseOtherNav = Initializer.createViewControllerWithId(storyBoardId: "ChooseOtherNav") as! UINavigationController
        
        if let chooseOtherVC = ChooseOtherNav.viewControllers[0] as? ChooseOtherVC {
            
            chooseOtherVC.type = 2
            chooseOtherVC.frameTitle = "Choose Size Type"
            chooseOtherVC.jsonObjec = jsonObjct
            chooseOtherVC.tableData = [("All" , "-1")]
            chooseOtherVC.tableData.append(contentsOf: getSizeTypes())

            self.present(ChooseOtherNav, animated: false, completion: nil)
        }
    }
    
    @IBAction func SelectFirstColor(_ sender: UIButton) {
        let ChooseOtherNav = Initializer.createViewControllerWithId(storyBoardId: "ChooseOtherNav") as! UINavigationController
        
        if let chooseOtherVC = ChooseOtherNav.viewControllers[0] as? ChooseOtherVC {
            
            chooseOtherVC.type = 3
            chooseOtherVC.frameTitle = "Choose Color"
            chooseOtherVC.jsonObjec = jsonObjct
            chooseOtherVC.tableData = [("All" , "-1")]
            chooseOtherVC.tableData.append(contentsOf: getColor())

            chooseOtherVC.colorCodes = ["#FFFFFF"]
            chooseOtherVC.colorCodes.append(contentsOf: getColorHexaCode())
            
            self.present(ChooseOtherNav, animated: false, completion: nil)
        }
    }
    
    @IBAction func SelectSecondColor(_ sender: UIButton) {
        let ChooseOtherNav = Initializer.createViewControllerWithId(storyBoardId: "ChooseOtherNav") as! UINavigationController
        
        if let chooseOtherVC = ChooseOtherNav.viewControllers[0] as? ChooseOtherVC {
            
            chooseOtherVC.type = 4
            chooseOtherVC.frameTitle = "Choose Color"
            chooseOtherVC.jsonObjec = jsonObjct
            chooseOtherVC.tableData = [("All" , "-1")]
            chooseOtherVC.tableData.append(contentsOf: getColor())
            
            chooseOtherVC.colorCodes = ["#FFFFFF"]
            chooseOtherVC.colorCodes.append(contentsOf: getColorHexaCode())

            self.present(ChooseOtherNav, animated: false, completion: nil)
        }
        
    }
    
    @IBAction func SelectCondition(_ sender: UIButton) {
        let ChooseOtherNav = Initializer.createViewControllerWithId(storyBoardId: "ChooseOtherNav") as! UINavigationController
        
        if let chooseOtherVC = ChooseOtherNav.viewControllers[0] as? ChooseOtherVC {
            
            chooseOtherVC.type = 5
            chooseOtherVC.frameTitle = "Choose Condition Type"
            chooseOtherVC.jsonObjec = jsonObjct
            chooseOtherVC.tableData = [("All" , "-1")]
            chooseOtherVC.tableData.append(contentsOf: getConditionTypes())

            self.present(ChooseOtherNav, animated: false, completion: nil)
        }
    }
    
    @IBAction func SelectLocation(_ sender: UIButton) {
        let ChooseOtherNav = Initializer.createViewControllerWithId(storyBoardId: "ChooseOtherNav") as! UINavigationController
        
        if let chooseOtherVC = ChooseOtherNav.viewControllers[0] as? ChooseOtherVC {
            
            chooseOtherVC.type = 6
            chooseOtherVC.frameTitle = "Choose Location"
            chooseOtherVC.jsonObjec = jsonObjct["city"]
            chooseOtherVC.tableData = getGovernment()
            
            self.present(ChooseOtherNav, animated: false, completion: nil)
        }
    }
    
    @IBAction func FilterProducts(_ sender: UIButton) {
        
        filterData.price_from = "\(Int(rangeSlider.lowerValue))"
        filterData.price_to = "\(Int(rangeSlider.upperValue))"
        
        print(filterData.price_from)
        print(filterData.price_to)
        
        
        let obj = (true , filterData)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getProductFilter")  , object: obj, userInfo: nil)

        self.dismiss(animated: false, completion: nil)
        
    }
    
    @IBAction func dismissVC(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: false, completion: nil)
        
    }
    
}
