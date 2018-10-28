//
//  ActivityIndicatorView.swift
//  SaveYourLinks
//
//  Created by Mohamed El-Naggar on 6/27/18.
//  Copyright © 2018 Mohamed El-Naggar. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ActivityIndicatorView: UIView {
    
    // @IBOutlet weak var view2: UIView!
    
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    
    var date: Date!
    
    override func awakeFromNib() {
        
        // Helper.makeUIViewShadow(containerView: view2)
        
       // view2.layer.cornerRadius = 10.0
        
    }
    
    
    func startAnimation(_ message: String = "") {
        
        activityIndicator.type = .ballRotateChase
        
        NVActivityIndicatorPresenter.sharedInstance.setMessage(message)
        
        let rootView = Initializer.createWindow().topMostWindowController()!.view!
        
        self.frame = CGRect(x: 0, y: 0, width: rootView.frame.width, height: rootView.frame.height)
        
        rootView.addSubview(self)
        
        date = Date()
        activityIndicator.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
            
            self.activityIndicator.stopAnimating()
            self.removeFromSuperview()
        }
        
    }
    
    func stopAnimation() {

        self.activityIndicator.stopAnimating()
        self.removeFromSuperview()

        
    }

}
