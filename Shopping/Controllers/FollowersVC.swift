//
//  FollowersVC.swift
//  Shopping
//
//  Created by Naggar on 11/25/17.
//  Copyright © 2017 Haseboty. All rights reserved.
//

import UIKit

class FollowersVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Variables
    var followersOrFollowing: Int = 1 , idClient = ""
    var tableData = [(String , String , String , String , String)]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        WebServices.limit = 0
        WebServices.limitSearch = 0
        WebServices.limitFavProduct = 0
        WebServices.limitClientProduct = 0
        WebServices.limitSimilarProduct = 0

        tableData.removeAll()
        
        
        if followersOrFollowing == 1 {
            self.navigationItem.title = "Followers"
            WebServices.getFollowers(idClient: idClient, completion: { (success, cells) in
                if success {
                    
                    self.tableData = cells!
                    
                } else {
                    Helper.showErrorMessage("Error while Loading Followers , Try again", showOnTop: false)
                }
            })
            
        } else {
                        self.navigationItem.title = "Following"
            
            WebServices.getFollowing(idClient: idClient, completion: { (success, cells) in
                if success {
                    
                    self.tableData = cells!
                    
                } else {
                    Helper.showErrorMessage("Error while Loading Followers , Try again", showOnTop: false)
                }
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Actions
    
    @IBAction func dismissVC(_ sender: UIBarButtonItem) {
        
        WebServices.limit = 0
        WebServices.limitSearch = 0
        WebServices.limitFavProduct = 0
        WebServices.limitClientProduct = 0
        WebServices.limitSimilarProduct = 0

    
        self.dismiss(animated: false, completion: nil)
    }
    
}

extension FollowersVC: UITableViewDelegate {
    
    
}


extension FollowersVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FollowersCell") as? FollowersCell {
            
            if UserStatus.clientID == tableData[indexPath.row].4 {
                
                cell.followButton.isHidden = true
                cell.followButton.isEnabled = false
                
            }
            
            cell.followerName.text = tableData[indexPath.row].0
            cell.followerLogo.sd_setImage(with: URL(string: Helper.removeSpaceFromString("\(Constants.Services.imagePath)\(tableData[indexPath.row].1)")), placeholderImage: UIImage(named: "profile"))
            
            cell.number.text = tableData[indexPath.row].2
            
            if tableData[indexPath.row].3 == "false" {
             
                cell.followButton.setTitle("Follow", for: .normal)
                
                
            } else {
                
                cell.followButton.setTitle("Following", for: .normal)
                
            }
            
            cell.id = tableData[indexPath.row].4
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let ClientProfileNav = Initializer.createViewControllerWithId(storyBoardId: Constants.StoryBoardID.ClientProfileNav) as! UINavigationController
        
        
        if let clientProfile = ClientProfileNav.viewControllers[0] as? ClientProfileVC {
            
            clientProfile.productOwnerID = tableData[indexPath.row].4
            clientProfile.idOfClient = tableData[indexPath.row].4

            //clientProfile.productOwnerID =  self.productDetails!.client_id_of_owner
            // clientProfile.idOfClient = self.productDetails!.id_client
            
            
            self.present(ClientProfileNav, animated: false, completion: nil)
            
        }
    }
}
