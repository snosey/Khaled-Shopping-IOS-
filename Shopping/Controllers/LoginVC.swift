//
//  LoginVC.swift
//  Shopping
//
//  Created by Naggar on 11/6/17.
//  Copyright © 2017 Haseboty. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class LoginVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var dismissView: UIView!
    @IBOutlet weak var username: SkyFloatingLabelTextField!
    @IBOutlet weak var password: SkyFloatingLabelTextField!
    @IBOutlet weak var email: SkyFloatingLabelTextField!
    @IBOutlet weak var sendInfoButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
    }
    
    
    // MARK: - Methods
    @objc func dismissLoginVC() {
        self.dismiss(animated: false, completion: nil)
        print("Dismiss Login VC")
    }
    
    func setupView() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginVC.dismissLoginVC))
        
        self.dismissView.addGestureRecognizer(gestureRecognizer)
        
        Helper.roundCorners(view: sendInfoButton, cornerRadius: 10.0, borderWidth: 0.0, borderColor: .clear)

    }
    
    
    // MARK: - Actions

    @IBAction func forgetUserPass(_ sender: UIButton) {
        
        email.isHidden = false
        sendInfoButton.isHidden = false
        
    }
    @IBAction func SignInAction(_ sender: UIButton) {
        guard let userName = username.text , userName != "" else {
            Helper.showErrorMessage("Please enter username!", showOnTop: false)
            return
        }
        
        guard let passWord = password.text , passWord != "" else {
            Helper.showErrorMessage("Please enter password!", showOnTop: false)
            return
        }
        
        WebServices.login(userName: userName, password: passWord) { (success, Msg) in
            if success == true {
                
                Helper.showSucces(Msg!, showOnTop: false)
                
                self.goToMainHomeVC()
                
            } else {
                // ERROR
                Helper.showErrorMessage((Msg)!, showOnTop: false)
            }
        }
    }
    
    @IBAction func sendInfoToMail(_ sender: UIButton) {
        
        guard let mail = email.text , mail != "" else {
            Helper.showErrorMessage("Please enter email!", showOnTop: false)
            return
        }
        
        guard Helper.isEmailValid(email: mail) else {
            Helper.showErrorMessage("Pease enter valid email address!", showOnTop: false)
            return
        }
        
        // Everything is Ok , try to send login info to my email
        WebServices.forgetPassword(email: mail) { (success, Msg) in
            
            if success == true {
                // DONE
                // Sent to mail
                Helper.showSucces(Msg, showOnTop: false )
            } else {
                Helper.showErrorMessage(Msg, showOnTop: false)
            }
            
        }
        
    }
    
    func goToMainHomeVC() {
        
        UserStatus.isLoggedByFaceOrGoogle = false
        
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
        
        Initializer.createWindow().rootViewController = homeVC
        
    }
    
    
    
}
