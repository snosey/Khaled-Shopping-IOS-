//
//  GovernmentVC.swift
//  Shopping
//
//  Created by Mohamed El-Naggar on 8/13/18.
//  Copyright © 2018 Haseboty. All rights reserved.
//

import UIKit

protocol GovernmentCityDelegate: class {
    
    func didCancel()
    func didSelectRow(_ rowData: (String , String) , _ time: Int)
    func didOccursError(_ errorMsg: String)
    
}

class GovernmentVC: UIViewController {
    
    weak var governmentDelegate: GovernmentCityDelegate?

    var showGovernmentData: [(name: String , id: String)]?
    var countTime = 0
    
    @IBOutlet weak var tableView: UITableView!
    

    static func storyBoardInstance() -> GovernmentVC? {
        let storyBoard = UIStoryboard(name: self.className, bundle: nil)
        
        return storyBoard.instantiateInitialViewController() as? GovernmentVC
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if showGovernmentData?.count == 0 {
            governmentDelegate?.didOccursError("لا توجد مواقع لعرضها")
        } else if showGovernmentData == nil {
            governmentDelegate?.didOccursError("لم تقم بتحديد المواقع الخاصه بالتطبيق")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func reloadTableViewData() {
        
        tableView.reloadData()
        tableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        
    }
    
    
    @IBAction func cancelChooseLocation(_ sender: UIBarButtonItem) {
        
        governmentDelegate?.didCancel()
        
    }


}

extension GovernmentVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (showGovernmentData?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "govermnentCell") {
            
            if let cellText = cell.viewWithTag(5) as? UILabel {
                cellText.text = showGovernmentData![indexPath.row].name
            }
         
            return cell
        }
        
        let tableViewCell = UITableViewCell()
        tableViewCell.textLabel?.text = showGovernmentData![indexPath.row].name
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        countTime += 1
        governmentDelegate?.didSelectRow((showGovernmentData![indexPath.row]) , countTime)
        
    }
    
}

extension GovernmentVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    
}
