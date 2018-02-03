//
//  Initializer.swift
//  WaitingList
//
//  Created by AboNabih on 8/9/17.
//  Copyright © 2017 MacBookPro. All rights reserved.
//

import Foundation
import UIKit

class Initializer {
    
    class func getStoryBoard() -> UIStoryboard {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        return storyBoard
    }
    
    class func createViewControllerWithId(storyBoardId: String) -> UIViewController {
        let storboard = getStoryBoard()
        let vc = storboard.instantiateViewController(withIdentifier: storyBoardId)
        return vc
    }
    
    class func createWindow() -> UIWindow {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let window = appDelegate.window
        
        return window!
    }
}
