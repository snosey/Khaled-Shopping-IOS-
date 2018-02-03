//
//  ForumVC.swift
//  Shopping
//
//  Created by Naggar on 12/6/17.
//  Copyright © 2017 Haseboty. All rights reserved.
//

import UIKit
// CELL : "ForumCell"

class ForumVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var forumKind: UILabel!
    
    
    // MARK: - Variables
    var tableData = [Forum]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var idKind = "-1"
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableData.removeAll()
        
        WebServices.getForums(idKind: idKind) { (success, forums) in
            if success {
                
                self.tableData = forums!
                
            } else {
                Helper.showErrorMessage("Error , Please try again", showOnTop: false)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(getForumKind(_:)), name: NSNotification.Name(rawValue: "getForumKind"), object: nil)
    }
    
    @objc func getForumKind(_ notification: Notification) {
        
        let val = notification.object as! (String , String)
        
        idKind = val.0
        forumKind.text = val.1
        
    }
    
    // MARK: - Actions
    @IBAction func SelectForumsKinds(_ sender: UIButton) {
        
        let ChooseKindNav = Initializer.createViewControllerWithId(storyBoardId: "ChooseKindNav") as! UINavigationController
        
        self.present(ChooseKindNav, animated: false, completion: nil)
        
    }
}


extension ForumVC: UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ForumCell") {

            (cell.viewWithTag(1) as! UILabel).text = tableData[indexPath.row].title
            (cell.viewWithTag(2) as! UILabel).text = tableData[indexPath.row].content
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let ForumProfileNav = Initializer.createViewControllerWithId(storyBoardId: "ForumProfileNav") as! UINavigationController
        
        if let forumProfileVC = ForumProfileNav.viewControllers[0] as? ForumProfileVC {
            
            forumProfileVC.idProfile = tableData[indexPath.row].id
            
            self.present(ForumProfileNav, animated: false, completion: nil)
        }
        
    }
    
}

extension ForumVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}


