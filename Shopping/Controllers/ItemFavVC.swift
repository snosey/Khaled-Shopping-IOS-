//
//  ItemFavVC.swift
//  Shopping
//
//  Created by Naggar on 11/23/17.
//  Copyright © 2017 Haseboty. All rights reserved.
//

import UIKit

class ItemFavVC: UIViewController {

    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var emptyView: UIView!
    
    @IBOutlet weak var backBTN: UIBarButtonItem!
    
    var itemOrFav: Int = 1 , isLoading = false , lastCellIndex = -1
    var lastY: CGFloat = 0.0

    var collectionData = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Helper.roundCorners(view: emptyView, cornerRadius: 10.0)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.tabBarController?.selectedIndex == 1 {

            self.backBTN.image = nil
            
            self.itemOrFav = 2
            WebServices.limitFavProduct = 0

           
            
        }
        
        WebServices.limit = 0
        WebServices.limitSearch = 0
        WebServices.limitFavProduct = 0
        WebServices.limitClientProduct = 0
        WebServices.limitSimilarProduct = 0
        
        collectionView.bounces = false

        isLoading = false
        lastCellIndex = -1
        
        collectionView.register(UINib(nibName: "ProductCell", bundle: nil), forCellWithReuseIdentifier: "ShowProductCell")
        
        // For Items ( That is not Contain Logo , Name )
        collectionView.register(UINib(nibName: "CellWithNoName", bundle: nil), forCellWithReuseIdentifier: "CellWithNoName")
        
        if itemOrFav == 1 {
            WebServices.clientProducts(UserStatus.clientID, completion: { (success, products) in
            
                if success {
                
                    if products!.count == 0 {
                        self.emptyView.isHidden = false
                    }
                    
                    self.collectionData = products!
                    self.collectionView.reloadData()
                
                } else {
                
                    Helper.showErrorMessage("Error , please try again!", showOnTop: false)
                
                }
            })
        } else {
            WebServices.getFavouritesProduct(completion: { (success, products) in
                
                if success {
                    
                    if products!.count == 0 {
                        self.emptyView.isHidden = false
                    }
                    
                    self.collectionData = products!
                    self.collectionView.reloadData()
                    
                } else {
                    
                    Helper.showErrorMessage("Error , please try again!", showOnTop: false)
                    
                }
            })
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func loadMoreProduct(_ cellIndex: Int) {
        
        guard !isLoading else { return }
        guard lastCellIndex != cellIndex else { return }
        
        isLoading = true
        lastCellIndex = cellIndex
        
        if  itemOrFav == 1 {
            
            WebServices.clientProducts(UserStatus.clientID, completion: { (success, products) in
                if success {
                    
                    self.collectionData.append(contentsOf: products!)
                    
                    self.collectionView.reloadData()
                    
                } else {
                    Helper.showErrorMessage("Error while loading More Products", showOnTop: false)
                }
            })
            
            
        } else {
            
            WebServices.getFavouritesProduct(completion: { (success, products) in
                
                if success {
                    self.collectionData.append(contentsOf: products!)
                    
                    self.collectionView.reloadData()

                } else {
                    Helper.showErrorMessage("Error while loading More Products", showOnTop: false)
                }
                
            })
            
        }
            
    }
    
    @IBAction func dismissVC(_ sender: UIBarButtonItem) {
        
        WebServices.limitFavProduct = 0
        WebServices.limitClientProduct = 0
        
        self.dismiss(animated: false, completion: nil)
        
    }
    
    
}

extension ItemFavVC: UICollectionViewDelegateFlowLayout {
    
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

        var width = (self.collectionView.frame.width - 8.0) / 2

        width = width > 200.0 ? 200.0 : width

        let const: CGFloat = (itemOrFav == 1 ? 1.8 : 2.0)

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

extension ItemFavVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if itemOrFav == 1 {
            
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellWithNoName", for: indexPath) as? CellWithNoName {
                
                cell.product = collectionData[indexPath.row]
                
                return cell
            }
            
        } else {
            
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShowProductCell", for: indexPath) as? ProductCell {
                
                cell.product = collectionData[indexPath.row]
                
                return cell
            }
        }
        

        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if itemOrFav == 1 {
          
            let nav = Initializer.createViewControllerWithId(storyBoardId: Constants.StoryBoardID.UpdateProductNav) as! UINavigationController
            
            if let editProductVC = nav.viewControllers[0] as? UpdateProductVC {
            
                editProductVC.productID = self.collectionData[indexPath.row].id
                
                self.present(nav, animated: false, completion: nil)
            }
            
            return
        }
        
        let ProductNav = Initializer.createViewControllerWithId(storyBoardId: Constants.StoryBoardID.productProfileNav) as! UINavigationController
        
        if let firstVC = ProductNav.viewControllers[0] as? ProductProfileVC {
            
            firstVC.productID = self.collectionData[indexPath.row].id
            
            firstVC.client_id_of_owner = self.collectionData[indexPath.row].id_client
            
            self.present(ProductNav, animated: false, completion: nil)

        }
    }
}
