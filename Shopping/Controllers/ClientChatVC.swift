//
//  ClientChatVC.swift
//  Shopping
//
//  Created by Naggar on 11/28/17.
//  Copyright © 2017 Haseboty. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Photos
import ImageSlideshow
import RappleProgressHUD

class ClientChatVC: UIViewController {
    
    
    var idClient = "" , ProfileTitle = "" , productID = "" , productImage = ""
    
    var tableData = [Message]() {
        didSet {
            tableView.reloadData()
            tableView.scrollBottom()
        }
    }
    
    var logoText = ""
    
    
    var newLogo = UIImage() {
        didSet {
            sendImageMessage()

        }
    }

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageText: SkyFloatingLabelTextField!
    
    @IBOutlet weak var profileTitle: UILabel!
    @IBOutlet weak var navImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.register(UINib(nibName: "recieverCell", bundle: nil), forCellReuseIdentifier: "recieverCell")
        
        profileTitle.text = ProfileTitle
        
        self.navImage.sd_setImage(with: URL(string: Helper.removeSpaceFromString("\(Constants.Services.imagePath)\(productImage)")), placeholderImage: nil)
        
        Helper.ImageViewCircle(imageView: navImage, 2.0)
        
        
        getAllMessages()
    }
    
    // MARK: - Methods
    func markAsSeen(_ messages: [Message]) {
        
        for eachMessage in messages {
            
            
            if eachMessage.seen != "1" && eachMessage.id_sent != UserStatus.clientID {
                WebServices.seeClientMessages(id: eachMessage.id, completion: { (success, Msg) in
                    if success {
                        
                        print("DONE")
                        
                    } else {
                        print("NOT DONE")
                    }
                })
            }
            
        }
    }
    
    func getAllMessages() {
        
        WebServices.limit = 0
        WebServices.limitSearch = 0
        WebServices.limitFavProduct = 0
        WebServices.limitClientProduct = 0
        WebServices.limitSimilarProduct = 0
        
        tableData.removeAll()
        
        WebServices.getClientChat(idClient, productID) { (success, messages) in
            if success {
                
                
                self.tableData = messages!
                self.markAsSeen(messages!)
                
            } else {
                Helper.showErrorMessage("Error while loading Client chat!", showOnTop: false)
            }
        }
    }
    
    func sendImageMessage() {
        
        print(logoText)
        print(newLogo )
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Loading...")

        WebServices.uploadImages(allImage: [(newLogo , logoText)]) { (success, str) in
            if success {
                
                RappleActivityIndicatorView.stopAnimation()
                WebServices.sendMessage(self.idClient, "\(self.logoText)" , self.productID) { (success, Msg) in
                    if success {
                        
                        Helper.showSucces("Message was sent successfully!", showOnTop: false)
                        self.getAllMessages()
                        self.messageText.text = ""
                        
                    } else {
                        Helper.showErrorMessage(Msg! , showOnTop: false)
                        
                    }
                }
            } else {
                
            }
        }

        
    }
    
    // MARK: - Actions
    @IBAction func sendMessage(_ sender: UIButton) {
        
        guard let mess = messageText.text , mess != "" else {
            Helper.showErrorMessage("Please enter your message!", showOnTop: false)
            return
        }
        
        WebServices.sendMessage(idClient, mess, productID) { (success, Msg) in
            if success {
                
                Helper.showSucces("Message was sent successfully!", showOnTop: false)
                self.getAllMessages()
                self.messageText.text = ""
                
            } else {
                Helper.showErrorMessage(Msg! , showOnTop: false)

            }
        }
        
    }
    
    
    @IBAction func handleCamera(_ sender: UIButton) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        
        self.present(picker, animated: false, completion: nil)
        
        
    }
    
        @IBAction func dismissVC(_ sender: UIButton) {
            
            WebServices.limit = 0
            WebServices.limitSearch = 0
            WebServices.limitFavProduct = 0
            WebServices.limitClientProduct = 0
            WebServices.limitSimilarProduct = 0

            self.dismiss(animated: false, completion: nil)
        }
    
    
}

extension ClientChatVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    
        return 150
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        

        return UITableViewAutomaticDimension
    }

    
}

extension ClientChatVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print(tableData.count)
        
        return tableData.count // tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print(tableData[indexPath.row].message)
        
        
        if tableData[indexPath.row].id_sent == UserStatus.clientID {
            
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "senderCell") , checkIfMessageImage(tableData[indexPath.row].message) == false  {
                
                // cell.MessageText.text = tableData[indexPath.row].message
                
                (cell.viewWithTag(1) as! UILabel).text = tableData[indexPath.row].message
                
                if tableData[indexPath.row].seen == "1" {
                    
                    (cell.viewWithTag(3))?.backgroundColor = UIColor.white
                } else {
                    (cell.viewWithTag(3))?.backgroundColor = UIColor.lightGray
                }
                
                Helper.roundCorners(view: (cell.viewWithTag(3))!, cornerRadius: 5.0)
                
                
                return cell
                
            } else if let cell = tableView.dequeueReusableCell(withIdentifier: "senderImageCell"){
                
                let imageView = cell.viewWithTag(5) as! UIImageView
                
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapHandler(_:_:)))
                
                imageView.addGestureRecognizer(tapGestureRecognizer)
                
                imageView.isUserInteractionEnabled = true

                imageView.sd_setImage(with: URL(string: Helper.removeSpaceFromString(("\(Constants.Services.imagePath)\(tableData[indexPath.row].message)"))), placeholderImage: UIImage(named: "loading")!)
                
                imageView.sizeToFit()
                cell.sizeToFit()
                
                Helper.roundCorners(view: imageView, cornerRadius: 5.0)
             
                return cell
            }
            
            
            
        } else {

            if let cell = tableView.dequeueReusableCell(withIdentifier: "recieverCell") as? recieverCell , checkIfMessageImage(tableData[indexPath.row].message) == false {
                
                cell.logo.sd_setImage(with: URL(string: Helper.removeSpaceFromString("\(Constants.Services.imagePath)\(tableData[indexPath.row].reciver_logo)")), placeholderImage: UIImage(named: "profile"))
                
                
                cell.date.text = Helper.getDay(tableData[indexPath.row].created_at)
                
                
                print(tableData[indexPath.row].message)
                
                
                
                
                cell.MessageText.text = tableData[indexPath.row].message
                
                return cell
            
            } else if let cell = tableView.dequeueReusableCell(withIdentifier: "reciverSendImage"){
                
                let imageView = cell.viewWithTag(5) as! UIImageView
                
                imageView.sd_setImage(with: URL(string: Helper.removeSpaceFromString("\(Constants.Services.imagePath)\(tableData[indexPath.row].message)")), placeholderImage: UIImage(named: "loading")!)
                
                
                let imageProfile = cell.viewWithTag(3) as! UIImageView
                
                Helper.ImageViewCircle(imageView: imageProfile, 2.0)
                
                imageProfile.sd_setImage(with: URL(string: Helper.removeSpaceFromString("\(Constants.Services.imagePath)\(tableData[indexPath.row].reciver_logo)")), placeholderImage: UIImage(named: "profile")!)
                
                
                (cell.viewWithTag(4) as! UILabel).text = Helper.getDay(tableData[indexPath.row].created_at)

                return cell
            }
            
            
            return UITableViewCell()
            
        }
        
        
        
        return UITableViewCell()
    }
    
    
    func checkIfMessageImage(_ message: String) -> Bool {
        
        if message.lowercased().contains(".png") || message.lowercased().contains(".jpeg") || message.lowercased().contains(".jpg") {
            return true
        }
        
        return false
    }
    
}

extension ClientChatVC: UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            
            logoText = getFileName(info)
            newLogo = image
            
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
    
    @objc func tapHandler(_ sender: UITapGestureRecognizer , _ indexPath: IndexPath) {
        
        
        
    }
    
}
