//
//  ProfileSettingVC.swift
//  Shopping
//
//  Created by Naggar on 11/22/17.
//  Copyright © 2017 Haseboty. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SDWebImage
import Photos
import OpalImagePicker

class ProfileSettingVC: UIViewController  {

    // MARK: - Outlets
    
    @IBOutlet weak var newLogo: roundedImage!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var passWordTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var passHeightCons: NSLayoutConstraint!
    @IBOutlet weak var passLabelConst: NSLayoutConstraint!
    
    @IBOutlet weak var passLabel: UILabel!
    @IBOutlet weak var StarPass: UILabel!
    
    @IBOutlet weak var aboutMeTF: SkyFloatingLabelTextField!
    
    @IBOutlet weak var widthImageView: NSLayoutConstraint!

    
    // MARK: - Variables
    var logoText = ""
    var aboutus = ""
    var phone = ""
    var name = ""
    var userName = ""
    
    var picker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()

        checkPermission()
        picker.delegate = self
        
        userNameLabel.text = userName
        nameTF.text = name
        passWordTF.text = UserStatus.password
        emailTF.text = UserStatus.email
        phoneTF.text = phone
        aboutMeTF.text = aboutus
        
        if UserStatus.isLoggedByFaceOrGoogle == true {
            passWordTF.isUserInteractionEnabled = false
            passHeightCons.constant = 0
            passLabel.isHidden = true
            passLabelConst.constant = 0
            StarPass.isHidden = true
        }
        
       // Helper.ImageViewCircle(imageView: newLogo, 2.0)
        newLogo.roundCorner()
        
        let path = Helper.removeSpaceFromString("\(Constants.Services.imagePath)\(logoText)")
        
        print(path)
        
        
        newLogo.sd_setImage(with: URL(string: path), placeholderImage: UIImage(named: "profile"))

    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        
        newLogo.frame = CGRect(x: (self.view.bounds.midX - (0.4 * self.view.frame.width) / 2.0), y: 30, width: 0.4 * self.view.frame.width, height: 0.4 * self.view.frame.width)
        
        newLogo.roundCorner()
        
        
        
        
        // widthImageView.constant = 0.4  * self.view.frame.width
        
       
            
    }
    
    // MARK: - Actions
    @IBAction func chooseLogo(_ sender: UIButton) {
        
        print("Tap Image was Clicked")
        // picker.delegate = self
        
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func updateInfo(_ sender: Any) {
        
        guard let Name = nameTF.text , Name != "" else {
            Helper.showErrorMessage("Please enter your name!", showOnTop: false)
            return
        }
        
        if passWordTF.isHidden == true {
            guard let pass = passWordTF.text , pass.count >= 6 else {
                Helper.showErrorMessage("Please enter password more than 6 characters", showOnTop: false)
                return
            }
            UserStatus.password = pass
        }
        
        guard let mail = emailTF.text , Helper.isEmailValid(email: mail) else {
            Helper.showErrorMessage("Please enter valid email!", showOnTop: false)
            return
        }
        UserStatus.email = mail

        guard let phoneNum = phoneTF.text , phoneNum != "" else {
            Helper.showErrorMessage("Please enter your phone!", showOnTop: false)
            return
        }
        
        WebServices.uploadImages(allImage: [(newLogo.image! , logoText)]) { (success, str) in
            if success {
                
                WebServices.updateProfile(name: Name, logo: self.logoText, phone: self.phone, about: self.aboutus) { (success) in
                    if success {
                        
                        let homeVC = Initializer.createViewControllerWithId(storyBoardId: Constants.StoryBoardID.HomeTabBar) as! UITabBarController
                        
                        let window = Initializer.createWindow()
                        window.rootViewController = homeVC
                        
                    } else {
                        Helper.showErrorMessage("Error , Please try again", showOnTop: false)
                    }
                }
                
            } else {
                
            }
        }
        

    }
    @IBAction func dismissVC(_ sender: Any) {
    
        self.dismiss(animated: false, completion: nil)
        
    }
    
    
    func getNameWithoutExtension(name: String) -> (String , String) {
        
        var output = name , exten = ""
        
        while(output.last != ".") {
            
            exten = "\(output.last!)\(exten)"
            output.removeLast()

        }
        
        exten = "\(output.last!)\(exten)"
        
        output.removeLast()
        
        return (output  , exten)
    }

    func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access is granted by user")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    /* do stuff here */
                    print("success")
                }
            })
            print("It is not determined until now")
        case .restricted:
            // same same
            print("User do not have access to photo album.")
        case .denied:
            // same same
            print("User has denied the permission.")
        }
    }
}

extension ProfileSettingVC: UIImagePickerControllerDelegate , UINavigationControllerDelegate {

    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {


        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {

            self.newLogo.image = image
            

            logoText = getFileName(info)
            

        }
        
        
        self.dismiss(animated: true, completion: nil)

    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func getFileName(_ info: [String : Any]) -> String {

        if let imageURL = info[UIImagePickerControllerReferenceURL] as? URL {
            let result = PHAsset.fetchAssets(withALAssetURLs: [imageURL], options: nil)
            let asset = result.firstObject

            let file = getNameWithoutExtension(name: asset!.value(forKey: "filename") as! String)
            let fileName = file.0
            let exten = file.1
            
            let date = Date()
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone.current
            formatter.dateFormat = "yyyMMddHHmmss"
            
            let dateString = formatter.string(from: date)
            
            print("\(fileName)\(dateString)\(exten)")
            
            return "\(fileName)\(dateString)\(exten)"
        }

        return ""
    }
    

}



