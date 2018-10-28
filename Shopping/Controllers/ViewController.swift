//
//  ViewController.swift
//  Shopping
//
//  Created by Mohamed El-Naggar on 8/27/18.
//  Copyright © 2018 Haseboty. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        let itemFavNav = Initializer.createViewControllerWithId(storyBoardId: Constants.StoryBoardID.ItemFavNav) as! UINavigationController
        
        if let favVC = itemFavNav.viewControllers[0] as? ItemFavVC {
            
            favVC.itemOrFav = 2 // favourites
            WebServices.limitFavProduct = 0
            favVC.title = "My Favourites"
            self.present(itemFavNav, animated: false, completion: nil)
 
        }
        
    }
}
