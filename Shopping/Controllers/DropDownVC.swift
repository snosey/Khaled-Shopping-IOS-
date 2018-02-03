//
//  DropDownVC.swift
//  Shopping
//
//  Created by Naggar on 11/11/17.
//  Copyright © 2017 Haseboty. All rights reserved.
//

import UIKit
import SwiftyJSON

class DropDownVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var NavTitle: UINavigationItem!
    
    var tableData = [(String , String)]()
    var colorCodes = [String]()
    
    var type = 1 , flag = true , currentGovernment = "" , frameTitle = ""
    var jsonObjec = JSON()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NavTitle.title = frameTitle
        tableView.delegate = self
        tableView.dataSource = self
    
    }
    
    // MARK: - Actions
    
    @IBAction func dismissViewController(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: false, completion: nil)
        
    }
}

extension DropDownVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "itemsCell") {
            
            // if type is 3 or 4 == ( FirstColor , SecondColor ) Respectively
            
            let colorView = (cell.viewWithTag(1))!
            Helper.ImageViewCircle(imageView: colorView, 2.0)
            
            
            if type == 3 || type == 4 {
                colorView.isHidden = false

                colorView.backgroundColor = UIColor(hexString: colorCodes[indexPath.row])
                
            } else {
                colorView.isHidden = true
            }
            
            // ASIGN
            
            (cell.viewWithTag(2) as! UILabel).text = tableData[indexPath.row].0
            
            return cell
        }
        
        return UITableViewCell()
    }
}

extension DropDownVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if type == 6 && flag == true {
            
            currentGovernment = tableData[indexPath.row].1
            
            if let cities = jsonObjec[tableData[indexPath.row].1].array {
                tableData.removeAll()
                for city in cities {
                    if let name = city["name"].string {
                        if let id = city["id"].string {
                            tableData.append((name , id))
                        }
                    }
                }
            }
            flag = false
            type = 7

            tableView.reloadData()
            
            return
        }
        var colorHexa = ""
        if type == 3 || type == 4 {
            colorHexa = colorCodes[indexPath.row]
        }
        let obj = (tableData[indexPath.row].0 , tableData[indexPath.row].1 , "\(type)" , currentGovernment , colorHexa)

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getOtherTypes") , object: obj, userInfo: nil)

        
        self.dismiss(animated: false, completion: nil)
    }
}
