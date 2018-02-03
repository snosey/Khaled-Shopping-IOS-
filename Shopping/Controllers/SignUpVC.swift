//
//  SignUpVC.swift
//  Shopping
//
//  Created by Naggar on 11/6/17.
//  Copyright © 2017 Haseboty. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class SignUpVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var dismissView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var email: SkyFloatingLabelTextField!
    
    @IBOutlet weak var username: SkyFloatingLabelTextField!
    
    @IBOutlet weak var password: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    
    }

    // MARK: - Methods
    
    func setupView() {
        let gestureRecogizer = UITapGestureRecognizer(target: self, action: #selector(SignUpVC.dismissSignUpVC))
        
    self.dismissView.addGestureRecognizer(gestureRecogizer)
        
        
        Helper.roundCorners(view: containerView, cornerRadius: 5.0)

    }
    
    @objc func dismissSignUpVC() {
        
        self.dismiss(animated: false, completion: nil)
        
        print("Dismiss SignUp VC")
        
    }
    
    // MARK: - Actions
    
    @IBAction func SignUpAction(_ sender: UIButton) {
        
        guard let userName = username.text , userName != "" else {
            
            Helper.showErrorMessage("Please enter username!", showOnTop: false)
            
            return
        }
        
        guard let passWord = password.text , passWord != "" else {
            Helper.showErrorMessage("Please enter password!", showOnTop: false)
            return
        }
        
        guard let mail = email.text , Helper.isEmailValid(email: mail) else {
            
            Helper.showErrorMessage("Please enter valid email!", showOnTop: false)
            
            return
        }
        
        // DONE
        // Username , password , email is Ok
        
        WebServices.signUp(email: mail, userName: userName, passWord: passWord) { (success, Msg) in
            
            if success == true {
                // SignUp Successfully
                
                WebServices.login(userName: userName, password: passWord, completion: { (success, Msg) in
                    if success {
                        //
                        self.goToMainHomeVC()
                        
                    } else {
                        Helper.showErrorMessage(Msg!, showOnTop: false)
                    }
                })
                
            } else {
                Helper.showErrorMessage(Msg, showOnTop: false)
            }
        }
    }
    
    func goToMainHomeVC() {
        
        UserStatus.isLoggedByFaceOrGoogle = false
        
        let homeVC = Initializer.createViewControllerWithId(storyBoardId: Constants.StoryBoardID.HomeTabBar)
        
        Initializer.createWindow().rootViewController = homeVC
        
    }
    
    
}
