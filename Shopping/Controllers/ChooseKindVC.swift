//
//  ChooseKindVC.swift
//  Shopping
//
//  Created by Naggar on 12/6/17.
//  Copyright © 2017 Haseboty. All rights reserved.
//

import UIKit

class ChooseKindVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var tableData = [(String , String)]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableData.removeAll()
        
        tableData.append(("-1" , "All"))
        
        WebServices.getForumsKinds { (success, kinds) in
            if success {
                
                self.tableData.append(contentsOf: kinds!)
                
            } else {
                
                Helper.showErrorMessage("Error , while Loading Kinds", showOnTop: false)
                
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func dismissVC(_ sender: UIBarButtonItem) {
        
        
        self.dismiss(animated: false, completion: nil)
        
    }
    
    
}

extension ChooseKindVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getForumKind") , object: tableData[indexPath.row], userInfo: nil)

        self.dismiss(animated: false, completion: nil)

        
    }
}

extension ChooseKindVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "chooseKindCell") {
            
            cell.textLabel?.text = tableData[indexPath.row].1
            
            
            return cell
        }

        return UITableViewCell()
    }
    
    
}
