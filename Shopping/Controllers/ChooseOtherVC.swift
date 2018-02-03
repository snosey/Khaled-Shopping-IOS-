//
//  ChooseOtherVC.swift
//  Shopping
//
//  Created by Naggar on 12/7/17.
//  Copyright © 2017 Haseboty. All rights reserved.
//

import UIKit
import SwiftyJSON

class ChooseOtherVC: UIViewController {

    var tableData = [(String , String)]()

    @IBOutlet weak var tableView: UITableView!
    
    var type = 1 , flag = true , currentGovernment = "" , frameTitle = ""
    var colorCodes = [String]()
    var jsonObjec = JSON()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = frameTitle
        
    }
    
    // MARK: - Actions
    
    @IBAction func dismissViewController(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: false, completion: nil)
        
    }
}

extension ChooseOtherVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseFilterCell") {
            
            // cell.textLabel?.text = tableData[indexPath.row].0
            
            
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

extension ChooseOtherVC: UITableViewDelegate {
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
        
        var colorHex = ""
        if type == 3 || type == 4 {
            colorHex = colorCodes[indexPath.row]
        }
        
        let obj = (tableData[indexPath.row].0 , tableData[indexPath.row].1 , "\(type)" , currentGovernment , colorHex)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getFilterTypes") , object: obj, userInfo: nil)
        
        
        self.dismiss(animated: false, completion: nil)
    }
}
