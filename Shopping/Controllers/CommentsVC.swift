//
//  CommentsVC.swift
//  Shopping
//
//  Created by Naggar on 11/22/17.
//  Copyright © 2017 Haseboty. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class CommentsVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentTF: SkyFloatingLabelTextField!

    // MARK: - Variables
    var tableViewData = [Comment]()
    var idProduct = ""
    var productClientID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
       NotificationCenter.default.addObserver(self, selector: #selector(deleteComment(_:)), name: NSNotification.Name(rawValue: "userDelete"), object: nil)

        
    }

    
    // MARK: - Actions
    @IBAction func dismissComments(_ sender: Any) {
        
        WebServices.limit = 0
        WebServices.limitSearch = 0
        WebServices.limitFavProduct = 0
        WebServices.limitClientProduct = 0
        WebServices.limitSimilarProduct = 0

        
        self.dismiss(animated: false, completion: nil)
    }
    
    
    @objc func deleteComment(_ notification : Notification) {
        let val = notification.object as! (Bool , IndexPath)
        
        
        if val.0 {
            
            WebServices.deleteComment(commentID: self.tableViewData[val.1.row].id, completion: { (success, Msg) in
                if success {
                    
                    self.tableView.beginUpdates()
                    
                    self.tableViewData.remove(at: val.1.row)
                    self.tableView.deleteRows(at: [val.1], with: .fade)
                    
                    self.tableView.endUpdates()
                    
                } else {
                    Helper.showWarning("Error , While deleting your comment!", showOnTop: false)
                }
            })
        }
    }
    
    @IBAction func deleteCommentButton(_ sender: UIButton) {
        
        let alertVC = Initializer.createViewControllerWithId(storyBoardId: Constants.StoryBoardID.AlertVC) as! AlertVC
        
        
        if let cellView = sender.superview {
            let cell = cellView.superview?.superview as! UITableViewCell
            
            let indexPath = tableView.indexPath(for: cell)!

            alertVC.titleMsg = "Are your sure you want to delete this comment ?"
            alertVC.indexCell = indexPath
            alertVC.rowValue = "userDelete"
            
            alertVC.modalPresentationStyle = .overCurrentContext
            self.present(alertVC, animated: false, completion: nil)

        }

    }
    
    
    @IBAction func postYourComment(_ sender: Any) {
        
        guard let comment = commentTF.text , comment != "" else {
            Helper.showErrorMessage("Please add your comment!", showOnTop: false)
            return
        }
        
        // Add Comment
        WebServices.postComments(comment: comment, idProduct: idProduct) { (success, Msg) in
            if success {
                
                Helper.showSucces("Your comment is added", showOnTop: false)
                self.getComments()
                
                // Initialize CommentTF String
                self.commentTF.text = ""
                
            } else {
                
                Helper.showErrorMessage(Msg!, showOnTop: false)
                
            }
        }
    }
    
    func getComments() {
        
        WebServices.getComments(idProduct: idProduct) { (success, comments) in
            if success {
                self.tableViewData = comments!
                self.tableView.reloadData()
                
            } else {
                print("ERROR")
            }
        }
        
    }
    
}


extension CommentsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
}

extension CommentsVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tableViewData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell") as? CommentCell {

            cell.commentDetails = tableViewData[indexPath.row]
            cell.deleteButton.isHidden = (tableViewData[indexPath.row].id_client != UserStatus.clientID)
            
            Helper.makeUIViewShadow(containerView: (cell.viewWithTag(5))!)
            
            
            return cell
        }
        
        return UITableViewCell()
    }
}
