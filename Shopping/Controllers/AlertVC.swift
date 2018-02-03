//
//  AlertVC.swift
//  Shopping
//
//  Created by Naggar on 11/24/17.
//  Copyright © 2017 Haseboty. All rights reserved.
//

import UIKit

class AlertVC: UIViewController {

    @IBOutlet weak var alertTitle: UILabel!
    
    var titleMsg = ""
    var indexCell: IndexPath!
    var rowValue = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        alertTitle.text = titleMsg
        
    }
    
    @IBAction func userClickYes(_ sender: Any) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: rowValue) , object: (true , indexCell), userInfo: nil)
        
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func userClickNo(_ sender: Any) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: rowValue) , object: (false , indexCell), userInfo: nil)

        self.dismiss(animated: false, completion: nil)
    }

}
