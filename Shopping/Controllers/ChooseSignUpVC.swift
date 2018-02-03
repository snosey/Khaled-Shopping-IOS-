//
//  ChooseSignUpVC.swift
//  Shopping
//
//  Created by Naggar on 11/6/17.
//  Copyright © 2017 Haseboty. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Google


class ChooseSignUpVC: UIViewController  {

    // MARK: - Outlets
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()

        // FACEBOOK Login SDK
        //facebookButton.delegate = self
        //facebookButton.readPermissions = ["public_profile" , "email" ]
        
        // GOOGLE LOGIN SDK
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        

    }
    
    @IBAction func loginWithFacebook(_ sender: Any) {
        
        let loginManager = FBSDKLoginManager()
        loginManager.logIn(withReadPermissions: ["public_profile" , "email"], from: self) { (result: FBSDKLoginManagerLoginResult!, error: Error!) in
            
            if error != nil {
                self.removeFbData()
            
            } else if result.isCancelled {
                
                self.removeFbData()
            
            } else {
                
                // Success
                if result.grantedPermissions.contains("email") && result.grantedPermissions.contains("public_profile") {
                    
                    print("DONE GET DATA")
                    
                    self.fetchFacebookProfile()
                    
                } else {
                    Helper.showErrorMessage("Error! , please try again", showOnTop: false)
                }
            }
        }
    }
    
    func removeFbData() {
        let fbManager = FBSDKLoginManager()
        fbManager.logOut()
        FBSDKAccessToken.setCurrent(nil)
    }
    
    func fetchFacebookProfile() {
        
        if FBSDKAccessToken.current() != nil {
            
            
            let userID = FBSDKAccessToken.current().userID!
            
            WebServices.login(userName: userID, password: "", completion: { (success, Msg) in
                if success == true {
                    // DONE
                    UserStatus.isLoggedByFaceOrGoogle = true
                    self.goToMainHomeVC()
                } else {
                    
                    WebServices.signUp(email: "", userName: userID, passWord: "", completion: { (success, Msg) in
                        
                        if success {
                            // DONE REGISTER TRY TO LOGIN
                            WebServices.login(userName: userID, password: "", completion: { (success, Msg) in
                                
                                if success {
                                    // DONE SUCCESSFULLY LOGIN
                                    // TAKE IT TO APPLICATION
                                    ////////////////////////
                                    ////////////////////////
                                    UserStatus.isLoggedByFaceOrGoogle = true
                                    self.goToMainHomeVC()
                                    ////////////////////////
                                    ////////////////////////
                                } else {
                                    Helper.showErrorMessage("ERROR , Please try again", showOnTop: false)
                                }
                                
                            })
                        } else {
                            Helper.showErrorMessage("ERROR , Please try again", showOnTop: false)
                        }
                        
                    })
                    
                }
            })
            
        }
        
        
    }
    
    // MARK: - Methods
    func setupView() {
        Helper.roundCorners(view: googleButton, cornerRadius: 10.0)
         Helper.roundCorners(view: facebookButton, cornerRadius: 10.0)
        
    }
    
    func goToMainHomeVC() {
        
        let homeVC = Initializer.createViewControllerWithId(storyBoardId: Constants.StoryBoardID.HomeTabBar) as! UITabBarController
        
        var counter: Int = 0
        WebServices.getInbox(completion: { (success, messages) in
            if success {
                
                for eachMessage in messages! {
                    counter += Int(eachMessage.unReed)!
                }
                
                if counter != 0 {
                    homeVC.viewControllers![3].tabBarItem.badgeValue = "\(counter)"
                }
            }
        })
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let window = appDelegate.window!
        
        window.rootViewController = homeVC
        
    }
    
    // MARK: - Actions
    @IBAction func signInAction(_ sender: UIButton) {
        
        let loginVC = Initializer.createViewControllerWithId(storyBoardId: Constants.StoryBoardID.loginVC) as! LoginVC
        
        loginVC.modalPresentationStyle = .overCurrentContext
        
        self.present(loginVC, animated: false, completion: nil)
        
    }
    
    @IBAction func signUpAction(_ sender: UIButton) {
        
        let signUpVC = Initializer.createViewControllerWithId(storyBoardId: Constants.StoryBoardID.signUpVC) as! SignUpVC
        
        signUpVC.modalPresentationStyle = .overCurrentContext
        
        self.present(signUpVC, animated: false, completion: nil)
        
    }
    
    @IBAction func signInToGoogle(_ sender: Any) {
        
        
        GIDSignIn.sharedInstance().signIn()
        
    }
}

// MARK: - Handle GOOGLE SDK
extension ChooseSignUpVC: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            
            let userId = user.userID
            // let idToken = user.authentication.idToken
            // let fullName = user.profile.name
            // let profilePicture = String(describing: GIDSignIn.sharedInstance().currentUser.profile.imageURL(withDimension: 400))
            // let email = user.profile.email
            
            
            WebServices.login(userName: userId!, password: "", completion: { (success, Msg) in
                if success == true {
                    // DONE LOGIN
                    UserStatus.isLoggedByFaceOrGoogle = true
                    self.goToMainHomeVC()
                } else {
                    // NOT REGISTER
                    WebServices.signUp(email: "", userName: userId!, passWord: "", completion: { (success, Msg) in
                        
                        if success == true {
                            // DONE TRY TO SIGN UP AGAIN
                            
                            WebServices.login(userName: userId!, password: "", completion: { (success, Msg) in
                                if success {
                                    // TAKE IT TO APPLICATION
                                    ////////////////////////
                                    ////////////////////////
                                    UserStatus.isLoggedByFaceOrGoogle = true
                                    self.goToMainHomeVC()
                                    ////////////////////////
                                    ////////////////////////
                                    
                                    
                                } else {
                                    Helper.showErrorMessage("ERROR , Please try again", showOnTop: false)
                                }
                            })
                        } else {
                            Helper.showErrorMessage("ERROR , Please try again", showOnTop: false)
                        }
                        
                    })
                }
            })
            
            
        } else {
            print("\(error.localizedDescription)")
        }
    }
}

extension ChooseSignUpVC: GIDSignInUIDelegate {
    
}
