//
//  ForumCommentVC.swift
//  Shopping
//
//  Created by Naggar on 12/6/17.
//  Copyright © 2017 Haseboty. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class ForumCommentVC: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentTF: SkyFloatingLabelTextField!
    
    @IBOutlet weak var alertView: UIView!
    
    
    var tableData = [ForumComment]() {
        didSet {
            tableView.reloadData()
        }
    }
    var idProfile = "" , indexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        WebServices.getCommentsForum(idForm: idProfile) { (success, forumComments) in
            if success {
                
                self.tableData = forumComments!
                
            } else {
                Helper.showErrorMessage("Error while loading comments", showOnTop: false)
            }
        }
    }
    
    
    func getAllComments() {
        
        WebServices.getCommentsForum(idForm: idProfile) { (success, forumComments) in
            if success {
                
                self.tableData = forumComments!
                
            } else {
                Helper.showErrorMessage("Error while loading comments", showOnTop: false)
            }
        }
        
    }
    
    @IBAction func DeleteThisComment(_ sender: UIButton) {
        
        if let cellView = sender.superview {
            let cell = cellView.superview?.superview as! UITableViewCell
            
            let indexPath = tableView.indexPath(for: cell)!
            
            self.indexPath = indexPath
            
            
            alertView.isHidden = false
            
        }
        
    }
    
    @IBAction func dismissVC(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: false, completion: nil)
        
    }
    
    @IBAction func PostComment(_ sender: UIButton) {
        
        guard let comment = commentTF.text , comment != "" else {
            Helper.showErrorMessage("Please enter your comment!", showOnTop: false)
            return
        }
        
        WebServices.postCommentsForum(comment: comment, id_form: idProfile) { (success) in
            if success {
                
                Helper.showSucces("Your comment is added!", showOnTop: false)
                
                self.commentTF.text = ""
                
                self.getAllComments()
                
                
                
            } else {
                
                Helper.showErrorMessage("Error while adding your comment , please try again", showOnTop: false)
                
            }
        }
        
    }
    
    
    @IBAction func YesDeleteComment(_ sender: UIButton) {
        
        alertView.isHidden = true
        
        WebServices.deleteCommentForum(commentID: self.tableData[indexPath!.row].id, completion: { (success) in
            if success {
                
                self.tableView.beginUpdates()
                
                self.tableData.remove(at: self.indexPath!.row)
                self.tableView.deleteRows(at: [self.indexPath!], with: .fade)
                
                self.tableView.endUpdates()
                
            } else {
                
                Helper.showErrorMessage("Error While Deleting your comment!", showOnTop: false)
                
            }
        })

        
    }
    
    
    @IBAction func NoDeleteComment(_ sender: UIButton) {
        
        alertView.isHidden = true
    }
    
}


extension ForumCommentVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
}

extension ForumCommentVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "forumCommentCell") {
            
            let logo = (cell.viewWithTag(1) as! UIImageView)
            let name = (cell.viewWithTag(2) as! UILabel)
            let comment = (cell.viewWithTag(3) as! UILabel)
            let date = (cell.viewWithTag(4) as! UILabel)
            let button = (cell.viewWithTag(5) as! UIButton)

            logo.sd_setImage(with: URL(string: Helper.removeSpaceFromString("\(Constants.Services.imagePath)\(tableData[indexPath.row].logo)")), placeholderImage: UIImage(named: "profile"))
            
            Helper.ImageViewCircle(imageView: logo, 2.0)

            name.text = tableData[indexPath.row].name
            comment.text = tableData[indexPath.row].comment
            date.text = Helper.getDay(tableData[indexPath.row].created_at)
            
            if UserStatus.clientID == tableData[indexPath.row].id_client {
                button.isHidden = false
            } else {
                button.isHidden = true
            }
            
            
            return cell
        }
        
        return UITableViewCell()
    }
}
