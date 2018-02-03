//
//  MessagesVC.swift
//  Shopping
//
//  Created by Naggar on 11/28/17.
//  Copyright © 2017 Haseboty. All rights reserved.
//

import UIKit

class MessagesVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var tableData = [Message]() {
        didSet {
            tableView.reloadData()
        }
    }
    var totalUnReadedMessages = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        totalUnReadedMessages = 0
        
        WebServices.limit = 0
        WebServices.limitSearch = 0
        WebServices.limitFavProduct = 0
        WebServices.limitClientProduct = 0
        WebServices.limitSimilarProduct = 0

        tableData.removeAll()
        
        WebServices.getInbox { (success, messages) in
            if success {
                
                
                for mess in messages! {
                    print(mess.unReed)
                    print(mess.message)
                    
                    self.totalUnReadedMessages += Int(mess.unReed)!
                }
                
                if self.totalUnReadedMessages > 0 {self.tabBarItem.badgeValue = "\(self.totalUnReadedMessages)"
                } else {
                    self.tabBarItem.badgeValue = nil
                }
                
                self.tableData = messages!
                
            } else {
                Helper.showErrorMessage("Error while loading Messages , please try again", showOnTop: false)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MessagesVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105.0
    }

}


extension MessagesVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MessagesVCCell") {
            
            (cell.viewWithTag(1) as! UILabel).text = tableData[indexPath.row].name
            
            let imageView = (cell.viewWithTag(2) as! UIImageView)
            imageView.sd_setImage(with: URL(string: Helper.removeSpaceFromString("\(Constants.Services.imagePath)\(tableData[indexPath.row].product_image)")), placeholderImage: UIImage(named: "profile"))
            
            Helper.ImageViewCircle(imageView: imageView, 2.0)
            
            (cell.viewWithTag(3) as! UILabel).text = tableData[indexPath.row].product_name
            
            (cell.viewWithTag(4) as! UILabel).text = Helper.getDay(tableData[indexPath.row].created_at)
            
            (cell.viewWithTag(9) as! UILabel).text = tableData[indexPath.row].message
            
            let readNum = (cell.viewWithTag(5) as! UILabel)
            
            readNum.text = tableData[indexPath.row].unReed
            Helper.roundCorners(view: readNum, cornerRadius: 5.0)
            

            if tableData[indexPath.row].unReed == "0" {
                readNum.isHidden = true
            } else {
                readNum.isHidden = false
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let clientChatVC = Initializer.createViewControllerWithId(storyBoardId: "ClientChatVC") as! ClientChatVC
        
            clientChatVC.idClient = tableData[indexPath.row].id
            clientChatVC.ProfileTitle = tableData[indexPath.row].product_name
            clientChatVC.productID = tableData[indexPath.row].id_product
            clientChatVC.productImage = tableData[indexPath.row].product_image
            
            
            self.present(clientChatVC, animated: false, completion: nil)
    }
}
