//
//  ClientProfileVC.swift
//  Shopping
//
//  Created by Naggar on 11/24/17.
//  Copyright © 2017 Haseboty. All rights reserved.
//

import UIKit
import SDWebImage

class ClientProfileVC: UIViewController {
    
    // MARK: - Outlet
    @IBOutlet weak var clientPic: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var followingNum: UILabel!
    @IBOutlet weak var followersNum: UILabel!
    @IBOutlet weak var aboutClient: UILabel!
    
    @IBOutlet weak var MessageSellerButton: UIButton!
    
    @IBOutlet weak var reviewImageView1: UIImageView!
    @IBOutlet weak var reviewImageView2: UIImageView!
    @IBOutlet weak var reviewImageView3: UIImageView!
    @IBOutlet weak var reviewImageView4: UIImageView!
    @IBOutlet weak var reviewImageView5: UIImageView!
    
    @IBOutlet weak var reviewNumber1: UILabel!
    @IBOutlet weak var reviewNumber2: UILabel!
    @IBOutlet weak var reviewNumber3: UILabel!
    @IBOutlet weak var reviewNumber4: UILabel!
    @IBOutlet weak var reviewNumber5: UILabel!
    
    @IBOutlet weak var notReviewed: UILabel!
    
    var productOwnerID = "" , isLoading = false , lastCellIndex = -1  , idOfClient = ""
    var data: (String , String , String , String , String , String , String , String , String)?
    // Phone data.2
    var collectionData = [Product]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // For Items ( That is not Contain Logo , Name )
        
        print(productOwnerID)
        
        print(idOfClient)
        
        


    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        WebServices.limit = 0
        WebServices.limitSearch = 0
        WebServices.limitFavProduct = 0
        WebServices.limitClientProduct = 0
        WebServices.limitSimilarProduct = 0

        collectionView.register(UINib(nibName: "CellWithNoName", bundle: nil), forCellWithReuseIdentifier: "CellWithNoName")
    
        WebServices.clientProfileData(id_of_client: productOwnerID, completion: { (success, name, about, phone, logo, follow, followers, review, stars, isFollow) in
            
            if success {
                
                self.data = (name! , about! , phone! , logo! , follow! , followers! , review! , stars! , isFollow!)

                self.setupView()
                
                self.isLoading = false
                self.lastCellIndex = -1
                self.collectionData.removeAll()
                self.loadMoreProduct(0)

            } else {
                
                Helper.showWarning("Error , While Loading Client Profile!", showOnTop: false)
                    
            }
        })

    }
    
    // MARK: - Methods
    func setupView() {
        
        //Helper.roundCorners(view: followButton, cornerRadius: 10.0)
        
        // Helper.roundCorners(view: MessageSellerButton, cornerRadius: 10.0)
        
        // Helper.ImageViewCircle(imageView: clientPic, 2.0)
        
        
        
        if Helper.removeSpaceFromString(data!.3) != "" {
            clientPic.contentMode = .scaleToFill
        }
        
        // Update Profile Data
        clientPic.sd_setImage(with: URL(string: Helper.removeSpaceFromString("\(Constants.Services.imagePath)\(data!.3)")), placeholderImage: UIImage(named: "profile"))
        
        self.title = data!.0 // as Name of Client
        aboutClient.text = data!.1 // As about
        // Phone
        
        followingNum.text = data!.4
        followersNum.text = data!.5
        
        if idOfClient == UserStatus.clientID {
            
            followButton.setTitle("Edit Profile", for: .normal)
            followButton.backgroundColor = UIColor(hexString: "FF0000")
            
        } else {
        
            followButton.setTitle( (data!.8 == "false" ? "Follow" : "Following") , for: .normal)
        
        }
        
        ////// REVIEWWWW \\\\\\\\\\\\
        if data!.7 == "0" {
            
            notReviewed.isHidden = false
            
        } else {
            if data!.7[data!.7.startIndex] == "1" {
                
                reviewNumber1.text = data!.6
                reviewNumber1.isHidden = false
                
                reviewImageView1.isHidden = false
                
            } else if data!.7[data!.7.startIndex] == "2" {
                
                reviewNumber2.text = data!.6
                reviewNumber2.isHidden = false
                
                reviewImageView1.isHidden = false
                reviewImageView2.isHidden = false
                
            } else if data!.7[data!.7.startIndex] == "3" {
                
                reviewNumber3.text = data!.6
                reviewNumber3.isHidden = false
                
                reviewImageView1.isHidden = false
                reviewImageView2.isHidden = false
                reviewImageView3.isHidden = false
                
            } else if data!.7[data!.7.startIndex] == "4" {
                
                reviewNumber4.isHidden = false
                reviewNumber4.text = data!.6
                
                
                reviewImageView1.isHidden = false
                reviewImageView2.isHidden = false
                reviewImageView3.isHidden = false
                reviewImageView4.isHidden = false
                
            } else if data!.7[data!.7.startIndex] == "5" {
                
                reviewNumber5.text = data!.6
                reviewNumber5.isHidden = false
                
                reviewImageView1.isHidden = false
                reviewImageView2.isHidden = false
                reviewImageView3.isHidden = false
                reviewImageView4.isHidden = false
                reviewImageView5.isHidden = false
                
            }
        }
    }
    
    
    @objc func loadMoreProduct(_ cellIndex: Int) {
        
        guard !isLoading else { return }
        guard lastCellIndex != cellIndex else { return }
        
        isLoading = true
        lastCellIndex = cellIndex
        
        WebServices.clientProducts(productOwnerID) { (success, products) in
            
            self.isLoading = false
            
            if success {
                self.collectionData.append(contentsOf: products!)
                
            } else {
                
                Helper.showErrorMessage("Error While loading Products", showOnTop: false)
                
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func followClient(_ sender: UIButton) {
        
        if idOfClient == UserStatus.clientID {
            
            WebServices.getUserInfo { (success, userName , name , phone, logo, about)  in
                if success {
                    
                    let ProfileSettingNav = Initializer.createViewControllerWithId(storyBoardId: Constants.StoryBoardID.ProfileSettingNav) as! UINavigationController
                    
                    if let profileSetting = ProfileSettingNav.viewControllers[0] as? ProfileSettingVC {
                        
                        profileSetting.userName = userName!
                        profileSetting.name = name!
                        profileSetting.phone = phone!
                        profileSetting.logoText = logo!
                        profileSetting.aboutus = about!
                        
                        self.present(ProfileSettingNav, animated: false, completion: nil)
                    }
                    
                } else {
                    Helper.showErrorMessage("Error , Please try again!", showOnTop: false)
                }
            }
            
        } else {
        
        var state = "remove"
        
        if followButton.title(for: .normal) == "Follow" {
            state = "add"
        }
        
        WebServices.updateFollow(clientID: productOwnerID, state: state) { (success, Msg) in
            if success {
                Helper.showSucces("success", showOnTop: false)
                
                if state == "add" {
                    self.followButton.setTitle("Following", for: .normal)
                    self.data!.8 = "true"
                } else {
                    self.followButton.setTitle("Follow", for: .normal)
                    self.data!.8 = "false"
                }
                
            } else {
                
                Helper.showErrorMessage(Msg!, showOnTop: false)
                
            }
        }
        }
    }
    /// CALL CLIENT FUNCTION
    /*
    @IBAction func CallClient(_ sender: UIButton) {
        
        guard let phone = data?.2 , phone != "" else {
            Helper.showErrorMessage("Phone is not exist!", showOnTop: false)
            return
        }
        
        guard let number = URL(string: "tel://\(phone)") else { return }
        
        
        if UIApplication.shared.canOpenURL(number) {
            
            UIApplication.shared.open(number, options: [ : ], completionHandler: nil)
            
        }
    }
    */
    
    @IBAction func MessageClient(_ sender: UIButton) {
        
        let messNav = Initializer.createViewControllerWithId(storyBoardId: Constants.StoryBoardID.MessagesNav) as! UINavigationController
        
        if let messageVC = messNav.viewControllers[0] as? ClientChatVC {
            
            messageVC.idClient = productOwnerID
            messageVC.ProfileTitle = data!.0
            
            self.present(messNav, animated: false, completion: nil)
        }
        
    }
    
    @IBAction func dismissVC(_ sender: Any) {
        
        WebServices.limit = 0
        WebServices.limitSearch = 0
        WebServices.limitFavProduct = 0
        WebServices.limitClientProduct = 0
        WebServices.limitSimilarProduct = 0
        
        self.dismiss(animated: false, completion: nil)
        
    }
    
    @IBAction func reviewClient(_ sender: UIButton) {
        
        let nav = Initializer.createViewControllerWithId(storyBoardId: Constants.StoryBoardID.ReviewNav) as! UINavigationController
        
        if let reviewVC = nav.viewControllers[0] as? ReviewVC {
            
            
            reviewVC.idClient = productOwnerID
            
            self.present(nav, animated: false, completion: nil)
        }
        
        
    }
    
    @IBAction func goToFollowingList(_ sender: UIButton) {
        
        let nav = Initializer.createViewControllerWithId(storyBoardId: Constants.StoryBoardID.FollowersNav) as! UINavigationController
        
        if let followersVC = nav.viewControllers[0] as? FollowersVC {
            
            
            followersVC.idClient = productOwnerID
            followersVC.followersOrFollowing = 2
            
            self.present(nav, animated: false, completion: nil)
        }
        
    }
    
    @IBAction func goToFollowersList(_ sender: UIButton) {
        
        let nav = Initializer.createViewControllerWithId(storyBoardId: Constants.StoryBoardID.FollowersNav) as! UINavigationController
        
        if let followersVC = nav.viewControllers[0] as? FollowersVC {
            
            
            followersVC.idClient = productOwnerID
            followersVC.followersOrFollowing = 1
            
            self.present(nav, animated: false, completion: nil)
        }
        
        
    }
}


extension ClientProfileVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var width = (self.collectionView.bounds.width - 20.0) / 2
        
        width = width > 200.0 ? 200.0 : width
        
        
        return CGSize(width: width, height: width * 1.8)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let currentData = collectionData.count
        
        if indexPath.row == currentData - 1 {
            // Load Next 20 Products
            loadMoreProduct(indexPath.row)
        }
    }
}

extension ClientProfileVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionData.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellWithNoName", for: indexPath) as? CellWithNoName {
            
            cell.product = collectionData[indexPath.row]
            
            return cell
        }

        return UICollectionViewCell()
    }
    
}
