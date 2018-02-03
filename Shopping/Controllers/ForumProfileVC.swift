//
//  ForumProfileVC.swift
//  Shopping
//
//  Created by Naggar on 12/6/17.
//  Copyright © 2017 Haseboty. All rights reserved.
//

import UIKit
import ImageSlideshow

class ForumProfileVC: UIViewController {
    
    
    @IBOutlet weak var imageSlider: ImageSlideshow!
    
    @IBOutlet weak var titleProfile: UILabel!
    @IBOutlet weak var conetntProfile: UILabel!
    @IBOutlet weak var commentsButton: UIButton!
    
    var idProfile = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        WebServices.getForumsProfile(id: idProfile) { (success, forum) in
            if success {
                
                self.titleProfile.text = forum!.title
                self.conetntProfile.text = forum!.content
                self.navigationItem.title = forum!.title
                
                self.commentsButton.setTitle("Comments ( \(forum!.countComments) )", for: .normal)
                self.imageSlider.setImageInputs(self.getInputSource(forum))
                
            } else {
                Helper.showErrorMessage("Error While Loading Profile Forum", showOnTop: false)
            }
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ProductProfileVC.tapFullScreen))
        
        imageSlider.addGestureRecognizer(tapGesture)

        
    }
    
    
    @objc func tapFullScreen() {
        
        imageSlider.presentFullScreenController(from: self)
        
    }
    
    
    func getInputSource(_ productDetails: Forum?) -> [InputSource] {
        
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

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func dismissVC(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func showComments(_ sender: UIButton) {
        
        let ForumcommentNav = Initializer.createViewControllerWithId(storyBoardId: "ForumcommentNav") as! UINavigationController
        
        if let forumCommentVC = ForumcommentNav.viewControllers[0] as? ForumCommentVC {
            
            forumCommentVC.idProfile = self.idProfile
            
            self.present(ForumcommentNav, animated: false, completion: nil)
        }
        
        
    }
    
    
}
