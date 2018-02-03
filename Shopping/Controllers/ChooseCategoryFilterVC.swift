//
//  ChooseCategoryFilterVC.swift
//  Shopping
//
//  Created by Naggar on 12/7/17.
//  Copyright © 2017 Haseboty. All rights reserved.
//

import UIKit
import SwiftyJSON

class ChooseCategoryFilterVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    public var chooseOne = [Category]() {
        didSet {
            tableView.reloadData()
        }
    }
    var count = 1 , category1ID = "" , category2ID = "" , category3ID = ""
    var jsonObject = JSON()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        chooseOne = getCategory1Array()
        
        tableView.reloadData()
        
    }
    
    func getCategory1Array() -> [Category] {
        
        var category1 = [Category]()
        
        if let newCategory = jsonObject["catregory1"].array {
            print("newCateory COUNT : \(newCategory.count)")
            for categoryOne in newCategory {
                
                if let name = categoryOne["name"].string {
                    if let id = categoryOne["id"].string {
                        if let logo = categoryOne["logo"].string {
                            if let orders = categoryOne["orders"].string {
                                category1.append(Category.init(id: id, PerviousID: "", name: name, orders: orders , logo: logo))
                            }
                        }
                    }
                }
            }
        }
        
        return category1
    }
    
    func getCategory2Array(id_Category1: String) -> [Category] {
        var category1 = [Category]()
        
        if let newCategory = jsonObject["catregory2"].array {
            for categoryOne in newCategory {
                
                if id_Category1 != categoryOne["id_category1"].string { continue }
                
                if let name = categoryOne["name"].string {
                    if let id = categoryOne["id"].string {
                        if let orders = categoryOne["orders"].string {
                            category1.append(Category.init(id: id, PerviousID: id_Category1, name: name, orders: orders))
                            
                        }
                    }
                }
            }
        }
        
        
        return category1
    }
    
    func getCategory3Array(id_Category2: String) -> [Category] {
        
        var category1 = [Category]()
        
        if let newCategory = jsonObject["catregory3"].array {
            for categoryOne in newCategory {
                
                if id_Category2 != categoryOne["id_category2"].string { continue }
                
                if let name = categoryOne["name"].string {
                    if let id = categoryOne["id"].string {
                        if let orders = categoryOne["orders"].string {
                            category1.append(Category.init(id: id, PerviousID: id_Category2, name: name, orders: orders))
                        }
                    }
                }
            }
        }
        
        return category1
    }
    
    
    // MARK: - Actions
    
    @IBAction func dismissViewController(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: false, completion: nil)
        
    }
}
extension ChooseCategoryFilterVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chooseOne.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "categoryFilterCell") {
            
            if indexPath.row == 0 {
                cell.textLabel?.text = "All"
            } else {
                cell.textLabel?.text = chooseOne[indexPath.row].name
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
}

extension ChooseCategoryFilterVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            let obj = ("-1" , "-1" , "-1" , "All")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ThreeCategoryFilter") , object: obj, userInfo: nil)

            self.dismiss(animated: false, completion: nil)
            
        } else {
            
            self.navigationItem.title = chooseOne[indexPath.row].name
        
        

            if count == 0 {
                chooseOne = getCategory1Array()
                count = 1
            } else if count == 1 {
                category1ID = chooseOne[indexPath.row].id
                chooseOne = getCategory2Array(id_Category1: chooseOne[indexPath.row].id)
                count = 2
            } else if count == 2 {
                category2ID = chooseOne[indexPath.row].id
                let name = chooseOne[indexPath.row].name
                chooseOne = getCategory3Array(id_Category2: chooseOne[indexPath.row].id)
                count = 3
            
            if(chooseOne.count == 0) {
                
                    let obj = (category1ID , category2ID , "2" , name)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ThreeCategoryFilter") , object: obj, userInfo: nil)
                
                    self.dismiss(animated: false, completion: nil)
                
                }
            
            } else {
                category3ID = chooseOne[indexPath.row].id
                let obj = (category1ID , category2ID , category3ID , chooseOne[indexPath.row].name)
            
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ThreeCategoryFilter")  , object: obj, userInfo: nil)
            
                self.dismiss(animated: false, completion: nil)
            }
        }
        
        tableView.reloadData()
        
    }
    
}
