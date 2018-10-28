//
//  ClientProfileVC.swift
//  Shopping
//
//  Created by Naggar on 11/24/17.
//  Copyright © 2017 Haseboty. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftyJSON

class ClientProfileVC: UIViewController {
    
    // MARK: - Outlet
    @IBOutlet weak var collectionView: UICollectionView!
    
    var productOwnerID = "" , isLoading = false , lastCellIndex = -1  , idOfClient = ""
    
    var data: (String , String , String , String , String , String , String , String , String)?
    
    // CollectionView Height WILL BE Dynamic
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    var lastY: CGFloat = 0.0

    
    // Phone data.2
    var collectionData: [Product] = [Product]() {
        didSet {
            
            print(collectionData.count)
            
            let width = collectionView.frame.width / 2.0
            let const = 1.8
            let numberOfCells = (collectionData.count / 2 + collectionData.count % 2 )
            
            print(numberOfCells)
            print(width)
            print(const)
            
            
            
            collectionViewHeight.constant = CGFloat(width) * CGFloat(const) * CGFloat(numberOfCells)
            
            collectionView.reloadData()
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // For Items ( That is not Contain Logo , Name )
        
        print(productOwnerID)
        scrollView.delegate  = self

        collectionView.register(UINib(nibName: "CellWithNoName", bundle: nil), forCellWithReuseIdentifier: "CellWithNoName")

        
        print(idOfClient)
        


    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        
        
        loadMoreProduct(Int((collectionView.indexPath(for: collectionView.visibleCells.last!)?.row)!))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        WebServices.limit = 0
        WebServices.limitSearch = 0
        WebServices.limitFavProduct = 0
        WebServices.limitClientProduct = 0
        WebServices.limitSimilarProduct = 0


        WebServices.clientProfileData(id_of_client: productOwnerID, completion: { (success, name, about, phone, logo, follow, followers, review, stars, isFollow) in
            
            if success {
                
                self.data = (name! , about! , phone! , logo! , follow! , followers! , review! , stars! , isFollow!)
                
                self.setupView()
                
                self.isLoading = false
                self.lastCellIndex = -1
                self.collectionData.removeAll()
                
                // let jsonOBject = JSON()
                
                // self.collectionData.append(Product(json: jsonOBject))
                self.loadMoreProduct(0)

            } else {
                
                Helper.showWarning("Error , While Loading Client Profile!", showOnTop: false)
                    
            }
        })

    }
    
    // MARK: - Methods
    func setupView() {
        
        
        let profileLogo = self.view.viewWithTag(5) as! UIImageView
        let followers = self.view.viewWithTag(6) as! UILabel
        let following = self.view.viewWithTag(7) as! UILabel
        let followButton = self.view.viewWithTag(8) as! UIButton
        let notReviewed = self.view.viewWithTag(9) as! UILabel
        
        let reviewNumber1 = self.view.viewWithTag(11) as! UILabel
        
        
        let reviewNumber2 = self.view.viewWithTag(12) as! UILabel
        
        let reviewNumber3 = self.view.viewWithTag(13) as! UILabel
        
        let reviewNumber4 = self.view.viewWithTag(14) as! UILabel
        
        let reviewNumber5 = self.view.viewWithTag(15) as! UILabel
        
        let reviewImageView1 = self.view.viewWithTag(16) as! UIImageView
        let reviewImageView2 = self.view.viewWithTag(17) as! UIImageView
        let reviewImageView3 = self.view.viewWithTag(18) as! UIImageView
        let reviewImageView4 = self.view.viewWithTag(19) as! UIImageView
        let reviewImageView5 = self.view.viewWithTag(20) as! UIImageView
        
        
        
        // if Helper.removeSpaceFromString(data!.3) != "" {
        //   profileLogo.contentMode = .scaleToFill
        //  }
        
        // Update Profile Data
        profileLogo.sd_setImage(with: URL(string: Helper.removeSpaceFromString("\(Constants.Services.imagePath)\(data!.3)")), placeholderImage: UIImage(named: "profile"))
        
        if data?.0.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            profileLogo.contentMode = .scaleAspectFit
        }
        
        self.title = data?.0 // as Name of Client
        
        // aboutClient.text = data!.1 // As about
        // Phone
        
        following.text = data?.4
        followers.text = data?.5
        
        if idOfClient == UserStatus.clientID {
            
            followButton.setTitle("Edit Profile", for: .normal)
            followButton.backgroundColor = UIColor(hexString: "65103C")
            
        } else {
            
            followButton.setTitle( (data?.8 == "false" ? "Follow" : "Following") , for: .normal)
            
        }
        
        ////// REVIEWWWW \\\\\\\\\\\\
        if data?.7 == "0" {
            
            notReviewed.isHidden = false
            
        } else {
            notReviewed.isHidden = true
            
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
        
        if sender.title(for: .normal) == "Follow" {
            state = "add"
        }
        
        WebServices.updateFollow(clientID: productOwnerID, state: state) { (success, Msg) in
            if success {
                Helper.showSucces("success", showOnTop: false)
                
                if state == "add" {
                    sender.setTitle("Following", for: .normal)
                    self.data!.8 = "true"
                } else {
                    sender.setTitle("Follow", for: .normal)
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let currentY = scrollView.contentOffset.y
        let currentBottomY = scrollView.frame.size.height + currentY
        if currentY > lastY {
            //"scrolling down"
            collectionView.bounces = true
        } else {
            //"scrolling up"
            // Check that we are not in bottom bounce
            if currentBottomY < scrollView.contentSize.height + scrollView.contentInset.bottom {
                collectionView.bounces = false
            }
        }
        lastY = scrollView.contentOffset.y
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        var width = (self.collectionView.bounds.width - 8.0) / 2.0

        
        width = width > 200.0 ? 200.0 : width
        

        
        return CGSize(width: width, height: (width *  1.8))
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let ProductNav = Initializer.createViewControllerWithId(storyBoardId: Constants.StoryBoardID.productProfileNav) as! UINavigationController
        
        if let firstVC = ProductNav.viewControllers[0] as? ProductProfileVC {
            
            firstVC.productID = self.collectionData[indexPath.row].id
            
            firstVC.client_id_of_owner = self.collectionData[indexPath.row].id_client
            
            self.present(ProductNav , animated: false , completion: nil)
            
            // self.navigationController?.pushViewController(firstVC, animated: true)
        }
    }
    
}
