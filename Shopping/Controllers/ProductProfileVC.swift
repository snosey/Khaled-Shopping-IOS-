//
//  ProductProfileVC.swift
//  Shopping
//
//  Created by Naggar on 11/17/17.
//  Copyright © 2017 Haseboty. All rights reserved.
//

import UIKit
import ImageSlideshow

class ProductProfileVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var imageSlider: ImageSlideshow!
    
    @IBOutlet weak var sellerLogo: UIImageView!
    @IBOutlet weak var SellerName: UILabel!
    
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
    
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productBrandSZ: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var MessageSeller: UIButton!
    
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var productColor: UILabel!
    @IBOutlet weak var sellerLocation: UILabel!
    @IBOutlet weak var viewCount: UILabel!
    @IBOutlet weak var peopleInterested: UILabel!
    @IBOutlet weak var addingTime: UILabel!
    
    @IBOutlet weak var loveCount: UIButton!
    
    @IBOutlet weak var comments: UIButton!
    
    @IBOutlet weak var notReviewed: UILabel!
    
    // TWO BUTTONS { MEMBER , SIMILAR }
    
    @IBOutlet weak var membersItem: UIButton!
    @IBOutlet weak var similarItem: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // CollectionView Height WILL BE Dynamic
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!

    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: - Variables
    var productDetails: ProductDetails?
    var productID = ""
    var client_id_of_owner = ""
    
    var collectionData: [Product] = [Product]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var isLoading = false , lastCellIndex = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        

        print(productID)
        print(client_id_of_owner)
        

        
        collectionViewHeight.constant = 400.0

        membersItem.setTitleColor(UIColor.black , for: .normal)
        similarItem.setTitleColor(UIColor.lightGray, for: .normal)
        


    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        if UserStatus.clientID == client_id_of_owner {
            
            MessageSeller.setTitle("Edit Item", for: .normal)
            MessageSeller.backgroundColor = UIColor(hexString: "#F93A31")
        }
        
        collectionView.register(UINib(nibName: "ProductCell", bundle: nil), forCellWithReuseIdentifier: "ShowProductCell")
        
        // For Similar Items ( That is not Contain Logo , Name )
        collectionView.register(UINib(nibName: "CellWithNoName", bundle: nil), forCellWithReuseIdentifier: "CellWithNoName")

        WebServices.getProductDetails(client_id_of_owner, productID) { (success, productDetail) in
            if success {
                
                self.productDetails = productDetail!
                self.productDetails!.id = self.productID
                self.productDetails!.client_id_of_owner = self.client_id_of_owner
                
                self.isLoading = false
                self.lastCellIndex = -1
                
                WebServices.limit = 0
                WebServices.limitSearch = 0
                WebServices.limitFavProduct = 0
                WebServices.limitClientProduct = 0
                WebServices.limitSimilarProduct = 0
                
                self.collectionData.removeAll()
                

                self.loadMoreProduct(0)
                
                self.setupView()

                
            } else {
                Helper.showErrorMessage("Error , While Loading productDetails", showOnTop: false)
            }
        }
    }
    

    // MARK: - Methods
    func setupView() {
        
        if productDetails != nil {
            updateProductDetails()
        }
        
        // SETUP ImageSliderShow
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ProductProfileVC.tapFullScreen))
        imageSlider.addGestureRecognizer(tapGesture)

        imageSlider.pageControlPosition = .insideScrollView
        imageSlider.pageControl.currentPageIndicatorTintColor = UIColor.black
        imageSlider.pageControl.pageIndicatorTintColor = UIColor.lightGray
        
        // Round MessageSeller Button
        Helper.roundCorners(view: MessageSeller, cornerRadius: 12.0)
        Helper.ImageViewCircle(imageView: sellerLogo, 2.0)
        
        WebServices.limitClientProduct = 0
        
        // GET PRODUCT ByClient
        WebServices.clientProducts(productDetails!.client_id_of_owner) { (success, products) in
            if success {
                print("DONE")
                self.collectionData = products!
            } else {
                Helper.showErrorMessage("Error , Please try again!2222222", showOnTop: false)
            }
        }


        // Update View Count
        WebServices.updateView(productDetails!.id) { (success) in
            if success {
                print("UPDATED")
            } else {
                print("NOT UPDATED")
            }
        }
    }
    
    @objc func tapFullScreen() {
        
        imageSlider.presentFullScreenController(from: self)
        
    }

    
    func updateProductDetails() {
        
        // SET ALL Images
        imageSlider.setImageInputs(getInputSource())
        
        let path = Helper.removeSpaceFromString("\(Constants.Services.imagePath)\(productDetails!.logo)")
        
        sellerLogo.sd_setImage(with: URL(string: path), placeholderImage: UIImage(named: "profile"))
        
        SellerName.text = productDetails!.name
        productTitle.text = productDetails!.title
        productBrandSZ.text = "\(productDetails!.size) - \(productDetails!.state) - \(productDetails!.brand)"
        productPrice.text = "L.E \(productDetails!.price)"
        productDescription.text = productDetails!.description
        productColor.text = "\(productDetails!.color1) - \(productDetails!.color2)"
        sellerLocation.text = "\(productDetails!.government) - \(productDetails!.city)"
        viewCount.text = productDetails!.view
        peopleInterested.text = productDetails!.review
        addingTime.text = Helper.getDay(productDetails!.created_at)

        
        loveCount.setImage((productDetails!.isLove == "true" ? UIImage(named: "ic_lovefull") : UIImage(named: "ic_love")), for: .normal)
        
        //comments.setTitle("Comments ( \(productDetails!.comment) )", for: .normal)
    
        self.title = productDetails!.title
        
        if productDetails!.stars == "0" {
            
            notReviewed.isHidden = false
            
        } else {
            if productDetails!.stars[productDetails!.stars.startIndex] == "1" {
                
                reviewNumber1.text = productDetails!.review
                reviewNumber1.isHidden = false

                reviewImageView1.isHidden = false
                
            } else if productDetails!.stars[productDetails!.stars.startIndex] == "2" {
                
                reviewNumber2.text = productDetails!.review
                reviewNumber2.isHidden = false
                
                reviewImageView1.isHidden = false
                reviewImageView2.isHidden = false
                
            } else if productDetails!.stars[productDetails!.stars.startIndex] == "3" {
                
                reviewNumber3.text = productDetails!.review
                reviewNumber3.isHidden = false
            
                reviewImageView1.isHidden = false
                reviewImageView2.isHidden = false
                reviewImageView3.isHidden = false
                
            } else if productDetails!.stars[productDetails!.stars.startIndex] == "4" {
                
                reviewNumber4.isHidden = false
                reviewNumber4.text = productDetails!.review

                
                reviewImageView1.isHidden = false
                reviewImageView2.isHidden = false
                reviewImageView3.isHidden = false
                reviewImageView4.isHidden = false
                
            } else if productDetails!.stars[productDetails!.stars.startIndex] == "5" {
                
                reviewNumber5.text = productDetails!.review
                reviewNumber5.isHidden = false
                
                reviewImageView1.isHidden = false
                reviewImageView2.isHidden = false
                reviewImageView3.isHidden = false
                reviewImageView4.isHidden = false
                reviewImageView5.isHidden = false

            }
        }
    }
    
    func getInputSource() -> [InputSource] {
        
        var inputSource = [InputSource]()

        if let img1 = productDetails?.img1 , img1 != " " {
            
            inputSource.append(KingfisherSource(urlString: Helper.removeSpaceFromString("\(Constants.Services.imagePath)\(img1)")) ?? ImageSource(image: UIImage(named: "icon_no_logo")!))
        }
        
        if let img2 = productDetails?.img2 , img2 != " " {
            
            inputSource.append(KingfisherSource(urlString: Helper.removeSpaceFromString("\(Constants.Services.imagePath)\(img2)")) ?? ImageSource(image: UIImage(named: "icon_no_logo")!))
        }
        
        if let img3 = productDetails?.img3 , img3 != " " {
            
            inputSource.append(KingfisherSource(urlString: Helper.removeSpaceFromString("\(Constants.Services.imagePath)\(img3)")) ?? ImageSource(image: UIImage(named: "icon_no_logo")!))
        }
        
        if let img4 = productDetails?.img4 , img4 != " " {
            
            inputSource.append(KingfisherSource(urlString: Helper.removeSpaceFromString("\(Constants.Services.imagePath)\(img4)")) ?? ImageSource(image: UIImage(named: "icon_no_logo")!))
        }
        
        if let img5 = productDetails?.img5 , img5 != " " {
            
            inputSource.append(KingfisherSource(urlString: Helper.removeSpaceFromString("\(Constants.Services.imagePath)\(img5)")) ?? ImageSource(image: UIImage(named: "icon_no_logo")!))
        }
        
        return inputSource
    }
    
    @objc func loadMoreProduct(_ cellIndex: Int) {
        
        guard !isLoading else { return }
        guard lastCellIndex != cellIndex else { return }
        
        isLoading = true
        lastCellIndex = cellIndex
        
        if membersItem.currentTitleColor == .black {
            
            WebServices.clientProducts(productDetails!.client_id_of_owner) { (success, products) in
                if success {
                    print("DONE")
                    
                    self.collectionData.append(contentsOf: products!)
                    
                } else {
                    Helper.showErrorMessage("Error , Please try again!", showOnTop: false)
                }
            }
            
        } else {
            
            WebServices.getSimilarProduct(productDetails!.id_category1, productDetails!.id_category2, cat3: productDetails!.id_category3) { (success, products) in
                if success {
                    self.collectionData.append(contentsOf: products!)
                } else {
                    Helper.showErrorMessage("Error , Please try again!", showOnTop: false)
                }
            }
            
        }
    
    }
    
    
    
    // MARK: - Actions
    @IBAction func dismissVC(_ sender: Any) {
        
        WebServices.limit = 0
        WebServices.limitSearch = 0
        WebServices.limitFavProduct = 0
        WebServices.limitClientProduct = 0
        WebServices.limitSimilarProduct = 0

        
        self.dismiss(animated: false, completion: nil)
        
    }
    
    
    @IBAction func goToClientProfile(_ sender:  UIButton) {
        
        let ClientProfileNav = Initializer.createViewControllerWithId(storyBoardId: Constants.StoryBoardID.ClientProfileNav) as! UINavigationController
        

        if let clientProfile = ClientProfileNav.viewControllers[0] as? ClientProfileVC {
            
            
            clientProfile.productOwnerID = self.productDetails!.client_id_of_owner
            clientProfile.idOfClient = self.productDetails!.id_client

            self.present(ClientProfileNav, animated: false, completion: nil)
            
        }
    
    }
    
    
    @IBAction func ContactSeller(_ sender: Any) {
        
        if UserStatus.clientID == client_id_of_owner {
            
            let nav = Initializer.createViewControllerWithId(storyBoardId: Constants.StoryBoardID.UpdateProductNav) as! UINavigationController
            
            if let editProductVC = nav.viewControllers[0] as? UpdateProductVC {
                
                editProductVC.productID = productID
                
                self.present(nav, animated: false, completion: nil)
            }
            
            
            return
        }
        
        
        let clientChatVC = Initializer.createViewControllerWithId(storyBoardId: "ClientChatVC") as! ClientChatVC

        
        clientChatVC.idClient = client_id_of_owner
        clientChatVC.ProfileTitle = productDetails!.title
        clientChatVC.productID = productDetails!.id
        clientChatVC.productImage = productDetails!.img1

            
            
        self.present(clientChatVC, animated: false, completion: nil)
        
    }
    
    @IBAction func contactPhone(_ sender: Any) {
        guard let phone = productDetails?.phone , phone != "" else {
            Helper.showErrorMessage("Phone is not exist!", showOnTop: false)
            return
        }
        
        guard let number = URL(string: "tel://\(phone)") else { return }
        
        
        if UIApplication.shared.canOpenURL(number) {
            
            UIApplication.shared.open(number, options: [ : ], completionHandler: nil)
            
        }
    }
    
    @IBAction func isLoveAction(_ sender: UIButton) {
        
        var state = "remove"
        if sender.image(for: .normal) == UIImage(named: "ic_love") {
            state = "add"
        }
        
        WebServices.updateLove(state: state, idProduct: productDetails!.id) { (success, Msg) in
            
            if success {
                self.loveCount.setImage(UIImage(named: (state == "remove" ? "ic_love" : "ic_lovefull")), for: .normal)
                
                if state == "remove" {
                    self.productDetails!.countLove = "\((Int(self.productDetails!.countLove)! - 1))"
                } else {
                    self.productDetails!.countLove = "\((Int(self.productDetails!.countLove)! + 1))"
                }
                
            } else {
                Helper.showErrorMessage(Msg, showOnTop: false)
            }
        }
    }
    
    @IBAction func shareAction(_ sender: UIButton) {
        
        let sharedItem = productDetails!.share
        
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [sharedItem], applicationActivities: nil)
        
        // This lines is for the popover you need to show in iPad
        activityViewController.popoverPresentationController?.sourceView = (sender)
        
        // This line remove the arrow of the popover to show in iPad
        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.init(rawValue: 0)
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        // Anything you want to exclude
        activityViewController.excludedActivityTypes = [
//            UIActivityType.postToWeibo,
//            UIActivityType.print,
//            UIActivityType.assignToContact,
//            UIActivityType.saveToCameraRoll,
//            UIActivityType.addToReadingList,
//            UIActivityType.postToFlickr,
//            UIActivityType.postToVimeo,
//            UIActivityType.postToTencentWeibo ,
//            UIActivityType.postToFacebook ,
//            UIActivityType.postToTwitter ,
//            UIActivityType.copyToPasteboard ,
//            UIActivityType.mail
        ]
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func commentsAction(_ sender: Any) {
        
        let commentsNav = Initializer.createViewControllerWithId(storyBoardId: Constants.StoryBoardID.commentNav) as! UINavigationController
        
        if let commentVC = commentsNav.viewControllers[0] as? CommentsVC {
            
            WebServices.getComments(idProduct: productDetails!.id , completion: { (success , comments) in
                if success {
                    
                    commentVC.tableViewData = comments!
                    commentVC.idProduct = self.productDetails!.id
                    commentVC.productClientID = self.productDetails!.client_id_of_owner
                    
                    self.present(commentsNav, animated: false, completion: nil)
                    
                } else {
                    
                    if self.productDetails!.comment == "0" {
                        Helper.showWarning("There is no Comments!", showOnTop: false)
                    } else {
                        Helper.showErrorMessage("Error , Please trye again!", showOnTop: false)
                    }
                    
                }
            })
        }
    }
    
    @IBAction func memberItemsPressed(_ sender: UIButton) {
        
        
        guard membersItem.currentTitleColor == UIColor.lightGray else { return }
        
        
        membersItem.setTitleColor(UIColor.black , for: .normal)
        similarItem.setTitleColor(UIColor.lightGray, for: .normal)
        
        
        WebServices.limit = 0
        WebServices.limitSearch = 0
        WebServices.limitFavProduct = 0
        WebServices.limitClientProduct = 0
        WebServices.limitSimilarProduct = 0

        WebServices.clientProducts(productDetails!.client_id_of_owner) { (success, products) in
            if success {
                print("DONE")
                self.collectionData = products!
            } else {
                Helper.showErrorMessage("Error , Please try again!", showOnTop: false)
            }
        }
    }
 
    @IBAction func similarItemsPressed(_ sender: UIButton) {
        
        guard similarItem.currentTitleColor == UIColor.lightGray else { return }
        
        membersItem.setTitleColor(UIColor.lightGray , for: .normal)
        similarItem.setTitleColor(UIColor.black, for: .normal)
        
        WebServices.limit = 0
        WebServices.limitSearch = 0
        WebServices.limitFavProduct = 0
        WebServices.limitClientProduct = 0
        WebServices.limitSimilarProduct = 0

        WebServices.getSimilarProduct(productDetails!.id_category1, productDetails!.id_category2, cat3: productDetails!.id_category3) { (success, products) in
            if success {
                self.collectionData = products!
            } else {
                Helper.showErrorMessage("Error , Please try again!", showOnTop: false)
            }
        }
        
    }
}

extension ProductProfileVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var width = (UIScreen.main.bounds.width - 20.0) / 2
        
        width = width > 200.0 ? 200.0 : width
        
        let const: CGFloat = (membersItem.titleColor(for: .normal) == .black ? 1.5 : 1.8)
        
        return CGSize(width: width, height: (width * const))
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let currentData = collectionData.count
        
        if indexPath.row == currentData - 1 {
            // Load Next 20 Products
            loadMoreProduct(indexPath.row)
        }
    }
}


extension ProductProfileVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return collectionData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShowProductCell", for: indexPath) as? ProductCell , similarItem.titleColor(for: .normal) == .black {
            
            cell.product = collectionData[indexPath.row]
            
            return cell
        }
        
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
            
            self.present(ProductNav, animated: false, completion: nil)
        }
    }
}
