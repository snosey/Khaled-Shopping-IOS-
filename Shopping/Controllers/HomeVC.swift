//
//  HomeVC.swift
//  Shopping
//
//  Created by Naggar on 11/11/17.
//  Copyright © 2017 Haseboty. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import NVActivityIndicatorView
import DropDown

class HomeVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    // @IBOutlet weak var sortView: UIView!
    
    @IBOutlet weak var emptyView: UIView!
    
    var data = [Product]() , isSelected = false , selectedIndex = 0
    
    var collectionData = [Product]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    lazy var refresher: UIRefreshControl = {
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
        return refresher
    }()

    
    var searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
    var isLoading = false , lastCellIndex = -1 , isSearching = false // First
    var filterIsLoading = false , filter = Filter()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        
        self.hideKeyboardWhenTappedAround()
        
        NotificationCenter.default.addObserver(self, selector: #selector(getProductFilter(_:)), name: NSNotification.Name(rawValue: "getProductFilter"), object: nil)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if collectionData.count > 0 && filterIsLoading == false { return }
        
        isLoading = false
        lastCellIndex = -1
        isSearching = false
        
        WebServices.limit = 0
        WebServices.limitSearch = 0
        WebServices.limitFavProduct = 0
        WebServices.limitClientProduct = 0
        WebServices.limitSimilarProduct = 0
        WebServices.limitFilter = 0
        
        
        collectionData.removeAll()
        collectionView.addSubview(refresher)

        lastCellIndex = -1
        loadMoreProduct(0)
        setupView()
        
    }
    
    // MARK: - Methods
    func setupView() {
        
        // Register Cell
        collectionView.register(UINib(nibName: "ProductCell", bundle: nil), forCellWithReuseIdentifier: "ShowProductCell")
        
    }
    
    @objc func handleRefresh() {
        if isSearching == true {
            self.refresher.endRefreshing()
            return
        }
        
        isLoading = false
        lastCellIndex = -1
        
        WebServices.limit = 0
        WebServices.limitSearch = 0
        WebServices.limitFavProduct = 0
        WebServices.limitClientProduct = 0
        WebServices.limitSimilarProduct = 0
        WebServices.limitFilter = 0
        
        collectionData.removeAll()
        
        lastCellIndex = -1
        loadMoreProduct(0)
        
    }
    
    @objc func getProductFilter(_ notification: Notification) {
        let val = notification.object as! (Bool , Filter)
        
        self.filterIsLoading = val.0
        self.filter = val.1
        
        
    }
    
    @objc func loadMoreProduct(_ cellIndex: Int) {
        
        self.refresher.endRefreshing()
        
        guard !isLoading else { return }
        guard lastCellIndex != cellIndex else { return }
        
        isLoading = true
        lastCellIndex = cellIndex
        
        
        if filterIsLoading {
            
            WebServices.filterProduct(filter: filter, completion: { (success, products) in
                
                self.isLoading = false
                if success {
                    self.collectionData.append(contentsOf: products!)
                    self.data.append(contentsOf: products!)
                    
                    if self.collectionData.count == 0 {
                        self.emptyView.isHidden = false
                    } else {
                        self.emptyView.isHidden = true
                    }
                    
                } else {
                    Helper.showErrorMessage("Error While loading Products", showOnTop: false)
                }
            })
            
            return
        }
        

        WebServices.getAllProduct { (success, products) in
            
            self.isLoading = false
            
            if success {
                self.collectionData.append(contentsOf: products!)
                self.data.append(contentsOf: products!)
                
                
                
                if self.collectionData.count == 0 {
                    self.emptyView.isHidden = false
                } else {
                    self.emptyView.isHidden = true
                }
                
            } else {
                
                Helper.showErrorMessage("Error While loading Products", showOnTop: false)
                
            }
        }
    }
    @IBAction func searchButton(_ sender: Any) {
        
        searchBar.placeholder = "Search for Products"
        self.navigationItem.titleView = searchBar
        searchBar.showsCancelButton = true
        searchBar.delegate = self
    
    }
    
    @IBAction func searchFilter(_ sender: UIButton) {
        
        let FilterNav = Initializer.createViewControllerWithId(storyBoardId: "FilterNav") as! UINavigationController
        
        
        self.present(FilterNav, animated: false, completion: nil)
        
    }
    
    @IBAction func sortBTN(_ sender: UIButton) {
        
        let drop = DropDown()
        drop.anchorView = sender
        
        drop.dataSource = ["newest" , "Price: low to high" , "Price: high to low"]
        
        drop.cellNib = UINib(nibName: "sortCell", bundle: nil)
        

        drop.cellHeight = 50.0
        
        drop.customCellConfiguration = { [unowned self] (index: Index, item: String, cell: DropDownCell) -> Void in
            
            guard let myCell = cell as? sortCell else { return }
            
            myCell.cellText.text = item
            
            if self.selectedIndex == index {
                myCell.selectedCell = true
            }

        }
        
        
        drop.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            
            self.selectedIndex = index
            
            drop.hide()
            
            // Execute Some
            
            if index == 0 {
                self.collectionData = self.data
            } else if index == 1 {
                self.collectionData = self.collectionData.sorted { (productA, productB) -> Bool in
                    
                    return Double(productA.price)! <= Double(productB.price)!
                }
            } else if index == 2 {
                self.collectionData = self.collectionData.sorted { (productA, productB) -> Bool in
                    
                    return Double(productA.price)! >= Double(productB.price)!
                }
            }
            
            
        }
        
        
        drop.show()
        

        
        

        
        
//        if let tv = sortView.viewWithTag(5) as? UITableView {
//
//            sortView.isHidden = false
//            tv.delegate = self
//            tv.dataSource = self
//            tv.reloadData()
//        }
//
    }
    
    
}


extension HomeVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var width = (self.collectionView.frame.width - 5) / 2
        
        width = width > 200.0 ? 200.0 : width
        
        
        return CGSize(width: width, height: width * 2.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let currentData = collectionData.count
        
        if indexPath.row == currentData - 1 {
            // Load Next 20 Products
            loadMoreProduct(indexPath.row)
        }
    }
}

extension HomeVC: UICollectionViewDataSource {
    
   
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShowProductCell", for: indexPath) as? ProductCell {
            
            cell.product = collectionData[indexPath.row]
                        
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         let ProductNav = Initializer.createViewControllerWithId(storyBoardId: Constants.StoryBoardID.productProfileNav) as! UINavigationController
        
        
        if let firstVC = ProductNav.viewControllers[0] as? ProductProfileVC {

            // to insure that productDetails is come with nil
            firstVC.productID = self.collectionData[indexPath.row].id
            firstVC.client_id_of_owner = self.collectionData[indexPath.row].id_client
            
            self.present(ProductNav , animated: false , completion: nil)

            // self.navigationController?.pushViewController(firstVC, animated: true)
        }
    }
}

extension HomeVC: UISearchBarDelegate {
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {


        if searchBar.text != "" && isSearching == false {
                
                isSearching = true
                
            WebServices.SearchText(text: searchBar.text!, completion: { (success, products) in
                    
                if success {
                    
                    self.collectionData = products!
                    
                    if self.collectionData.count == 0 {
                        self.emptyView.isHidden = false
                    } else {
                        self.emptyView.isHidden = true
                    }
                    
                    self.isSearching = false
                } else {
                    Helper.showErrorMessage("Error While loading products!", showOnTop: false)
                }
            })
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.tabBarController?.view.endEditing(true)

        if searchBar.text != "" && isSearching == false {
            
            isSearching = true
            
            WebServices.SearchText(text: searchBar.text!, completion: { (success, products) in
                
                if success {
                    self.collectionData = products!
                    self.isSearching = false
                    
                    if self.collectionData.count == 0 {
                        self.emptyView.isHidden = false
                    } else {
                        self.emptyView.isHidden = true
                    }
                    
                } else {
                    Helper.showErrorMessage("Error While loading products!", showOnTop: false)
                }
            })
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {

        self.tabBarController?.view.endEditing(true)

        navigationItem.titleView = nil

        WebServices.limit = 0
        WebServices.limitFilter = 0
        filterIsLoading = false
        
        isLoading = false
        lastCellIndex = -1
        self.navigationItem.title = "Home"
        collectionData.removeAll()
        
        loadMoreProduct(0)
        
    }
}
