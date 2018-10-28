//
//  Helper.swift
//  Shopping
//
//  Created by Naggar on 11/6/17.
//  Copyright © 2017 Haseboty. All rights reserved.
//

import Foundation
import UIKit
import Dodo
import NVActivityIndicatorView

class Helper: NSObject {
    
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    static var activityIndicator = NVActivityIndicatorView(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
    
    class func roundCorners(view: UIView , cornerRadius: CGFloat , borderWidth: CGFloat = 0.0 , borderColor: UIColor = .clear) {
        
        view.layer.cornerRadius = cornerRadius
        view.layer.borderWidth = borderWidth
        view.layer.borderColor = borderColor.cgColor
        view.layer.masksToBounds = true
    }

    class func isEmailValid(email: String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: email)
    }
    
    class func makeViewCorner(view: UIView , rounderCornder: UIRectCorner , borderColor: UIColor = .white , borderWidth: CGFloat = 5.0) {
        
        let rectShape = CAShapeLayer()
        rectShape.bounds = view.frame
        rectShape.position = view.center
        
        rectShape.path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: rounderCornder , cornerRadii: CGSize(width: borderWidth, height: borderWidth)).cgPath
        
        view.layer.backgroundColor = borderColor.cgColor
        
        view.layer.mask = rectShape
    }
    
    static func showinfo(_ infoMessage:String,showOnTop:Bool) {
        
        let viewcon =  appDelegate.window
        
        viewcon?.dodo.style.bar.hideAfterDelaySeconds = 4
        
        // Close the bar when it is tapped
        viewcon?.dodo.style.bar.hideOnTap = true
        
        // Show the bar at the bottom of the screen
        viewcon?.dodo.style.bar.locationTop = showOnTop
        
        viewcon?.dodo.info(infoMessage)
    }
    static func showErrorMessage(_ infoMessage:String,showOnTop:Bool) {
        
        let viewcon =  appDelegate.window
        
        viewcon?.dodo.style.bar.hideAfterDelaySeconds = 4
        
        // Close the bar when it is tapped
        viewcon?.dodo.style.bar.hideOnTap = true
        
        // Show the bar at the bottom of the screen
        viewcon?.dodo.style.bar.locationTop = showOnTop
        
        viewcon?.dodo.error(infoMessage)
    }
    static func showWarning(_ infoMessage:String,showOnTop:Bool) {
        
        let viewcon =  appDelegate.window
        
        viewcon?.dodo.style.bar.hideAfterDelaySeconds = 4
        
        // Close the bar when it is tapped
        viewcon?.dodo.style.bar.hideOnTap = true
        
        // Show the bar at the bottom of the screen
        viewcon?.dodo.style.bar.locationTop = showOnTop
        
        viewcon?.dodo.warning(infoMessage)
    }
    static func showSucces(_ infoMessage:String,showOnTop:Bool) {
        
        let viewcon =  appDelegate.window
        
        viewcon?.dodo.style.bar.hideAfterDelaySeconds = 4
        
        // Close the bar when it is tapped
        viewcon?.dodo.style.bar.hideOnTap = true
        
        // Show the bar at the bottom of the screen
        viewcon?.dodo.style.bar.locationTop = showOnTop
        
        viewcon?.dodo.success(infoMessage)
    }
    
    
    class func ImageViewCircle(imageView: UIView , _ widthModule: CGFloat = 2.0) {
        
        // view.layer.borderWidth  = 0.0
        // view.layer.masksToBounds = true
        
        imageView.layer.cornerRadius = imageView.frame.size.width / widthModule
        imageView.clipsToBounds = true

    }
    
    class func StartAnimation(_ view: UIView) {
        
        let rect = CGRect(x: view.bounds.midX - 20.0, y: view.bounds.midY - 20.0, width: 40.0, height: 40.0)
        
        let activityIndicator = NVActivityIndicatorView(frame: rect, type: NVActivityIndicatorType.ballPulseSync, color: .black, padding: 0.0)
        
        activityIndicator.backgroundColor = .clear
        
        
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        
    }
    

    class func makeUIViewShadow(containerView: UIView) {
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity =  0.25
        containerView.layer.shadowOffset = .zero
        containerView.layer.shadowRadius = 10.0
        containerView.layer.shadowPath = UIBezierPath(rect: containerView.bounds).cgPath
        containerView.layer.shouldRasterize = true
    }
    
    class func removeSpaceFromString(_ imagePath: String) -> String {
        
        var returnedString = ""
        
        for index in imagePath.indices {
            if imagePath[index] == " " {
                returnedString += "%20"
            } else {
                returnedString = "\(returnedString)\(imagePath[index])"
            }
        }
        

        return returnedString
    }

    class func differentInSecond(_ date1: Date , _ date2: Date) -> Int {
        
        let components = Calendar.current.dateComponents([.second], from: date1, to: date2)

        print(components.second!)
        
        
        return components.second!
    }
    
    class func getDay(_ dateForm: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        print(dateForm)
        
        
        let date = dateFormatter.date(from: dateForm)!

        let currentDate = Date()
        
        let components = Calendar.current.dateComponents([.minute , .hour , .day , .month], from: date, to: currentDate)
        
        print("difference is \(components.month ?? 0) months and \(components.weekOfYear ?? 0) weeks  and \(components.day ?? 0) DAYS and \(components.hour ?? 0) HOUR")
        
        
        // let month = components.month ?? 0
        var day = components.day ?? 0
        var hour = components.hour ?? 0
       // let minutes = components.minute ?? 0
        
        

        if hour >= 7 {
            hour = hour - 7
        } else if day >= 1 {
            day -= 1
        }

        if day > 0 {
            return "\(day) Days"
        }

        return "Today"
    }
}
