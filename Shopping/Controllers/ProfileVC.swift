//
//  ProfileVC.swift
//  Shopping
//
//  Created by Naggar on 11/22/17.
//  Copyright © 2017 Haseboty. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {
    
    // MARK: - Outlets

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Actions
    
    @IBAction func gotoProfileSetting(_ sender: Any) {
        
        
        let clientProfileVC = Initializer.createViewControllerWithId(storyBoardId: "ClientProfileNav") as! UINavigationController
        
        if let vc = clientProfileVC.viewControllers[0] as? ClientProfileVC {
            vc.productOwnerID = UserStatus.clientID
            vc.idOfClient = UserStatus.clientID
            
            self.present(clientProfileVC, animated: true , completion: nil)
        }
        
        
        
//        WebServices.getUserInfo { (success, userName , name , phone, logo, about)  in
//            if success {
//
//                let ProfileSettingNav = Initializer.createViewControllerWithId(storyBoardId: Constants.StoryBoardID.ProfileSettingNav) as! UINavigationController
//
//                if let profileSetting = ProfileSettingNav.viewControllers[0] as? ProfileSettingVC {
//
//                    profileSetting.userName = userName!
//                    profileSetting.name = name!
//                    profileSetting.phone = phone!
//                    profileSetting.logoText = logo!
//                    profileSetting.aboutus = about!
//
//                    self.present(ProfileSettingNav, animated: false, completion: nil)
//                }
//
//            } else {
//                Helper.showErrorMessage("Error , Please try again!", showOnTop: false)
//            }
//        }
        
        
    }

    
    @IBAction func goToMyItems(_ sender: Any) {
        
        
        let itemFavNav = Initializer.createViewControllerWithId(storyBoardId: Constants.StoryBoardID.ItemFavNav) as! UINavigationController
        
        WebServices.limitClientProduct = 0


        if let itemVC = itemFavNav.viewControllers[0] as? ItemFavVC {
            
            itemVC.itemOrFav = 1
            itemVC.title = "My Items"

            self.present(itemFavNav, animated: false, completion: nil)
            
            
        }
        
    }
    
    @IBAction func goToMyFavourites(_ sender: Any) {
        
        let itemFavNav = Initializer.createViewControllerWithId(storyBoardId: Constants.StoryBoardID.ItemFavNav) as! UINavigationController
        
        if let favVC = itemFavNav.viewControllers[0] as? ItemFavVC {
            
            favVC.itemOrFav = 2
            WebServices.limitFavProduct = 0
            favVC.title = "My Favourites"
            self.present(itemFavNav, animated: false, completion: nil)


            
        }

    }
    
    @IBAction func aboutShopping(_ sender: Any) {
        
        
        
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        
        // Remove All user data from UserDefaults
        UserStatus.login = false
        
        UserDefaults.standard.removeObject(forKey :Constants.UserData.logged)
        UserDefaults.standard.removeObject(forKey: Constants.UserData.username)
        UserDefaults.standard.removeObject(forKey: Constants.UserData.email)
        
        UserDefaults.standard.removeObject(forKey: Constants.UserData.password)
        UserDefaults.standard.removeObject(forKey: Constants.UserData.clientID)
        UserDefaults.standard.removeObject(forKey: Constants.UserData.userID)

        
        // Instaniate ChooseLoginOrSignUp
        
        if let ChooseSignUpVC = Initializer.createViewControllerWithId(storyBoardId: Constants.StoryBoardID.ChooseSignUpVC) as? ChooseSignUpVC {
            
            let window = Initializer.createWindow()
            
            window.rootViewController = ChooseSignUpVC
            
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
