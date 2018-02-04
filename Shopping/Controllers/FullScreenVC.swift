//
//  FullScreenVC.swift
//  Shopping
//
//  Created by Naggar on 2/4/18.
//  Copyright © 2018 Haseboty. All rights reserved.
//

import UIKit

class FullScreenVC: UIViewController , UIScrollViewDelegate {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var image: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        imgView.image = image!
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0


    }
    
    
    @IBAction func dismissVC(_ sender: UIButton) {
        
        self.dismiss(animated: false, completion: nil)
        
    }
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return imgView
    }

}
