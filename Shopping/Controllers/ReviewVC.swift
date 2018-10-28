//
//  ReviewVC.swift
//  Shopping
//
//  Created by Naggar on 11/26/17.
//  Copyright © 2017 Haseboty. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class ReviewVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var rateView: UIView!
    @IBOutlet weak var reviewData: SkyFloatingLabelTextField!

    @IBOutlet weak var star1: UIButton!
    @IBOutlet weak var star2: UIButton!
    @IBOutlet weak var star3: UIButton!
    @IBOutlet weak var star4: UIButton!
    @IBOutlet weak var star5: UIButton!
    
    @IBOutlet weak var lastViewBottomC: NSLayoutConstraint!
    
    var tableData = [Review]() {
        didSet {
            tableView.reloadData()
        }
    }
    var idClient = "" , rate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(deleteReview(_:)), name: NSNotification.Name(rawValue: "deleteUserReview"), object: nil)


        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if idClient == UserStatus.clientID {
            
            
            lastViewBottomC.constant = -50
            
        } else {
            lastViewBottomC.constant = 0
        }
        
        
        WebServices.limit = 0
        WebServices.limitSearch = 0
        WebServices.limitFavProduct = 0
        WebServices.limitClientProduct = 0
        WebServices.limitSimilarProduct = 0
        
        tableData.removeAll()
        
        WebServices.getReviews(idClient: idClient) { (success, reviews) in
            if success {
                self.tableData = reviews!
            } else {
                Helper.showErrorMessage("Error While Loading Reviews!", showOnTop: false)
            }
        }
    }

    @IBAction func postYourReview(_ sender: UIButton) {
   
        
//        let rateVC = Initializer.createViewControllerWithId(storyBoardId: Constants.StoryBoardID.RateVC) as! RateVC
//
//        rateVC.idClient = idClient
//        rateVC.data = reviewData.text!
//
//        rateVC.modalPresentationStyle = .overCurrentContext
//        self.present(rateVC, animated: false, completion: nil)
        
        if reviewData.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            Helper.showErrorMessage("You can’t write empty review!", showOnTop: false)
            
            return
        }
        
        self.view.endEditing(true)
        
        rateView.isHidden = false
        
    }
    
    @objc func deleteReview(_ notification: Notification) {
        
        let val = notification.object as! (Bool , IndexPath)
        
        if val.0 {
            
            WebServices.deleteReview(idComment: tableData[val.1.row].id , completion: { (success, Msg) in
                
                if success {
                    
                    self.tableView.beginUpdates()
                    
                    self.tableData.remove(at: val.1.row)
                    self.tableView.deleteRows(at: [val.1], with: .fade)
                    
                    self.tableView.endUpdates()

                    
                } else {
                    Helper.showWarning("Error , While deleting your Review!", showOnTop: false)
                }
                
            })
        }
        
    }
    
    
    @IBAction func deleteYourReview(_ sender: UIButton) {
        
        let alertVC = Initializer.createViewControllerWithId(storyBoardId: Constants.StoryBoardID.AlertVC) as! AlertVC
        
        
        if let cellView = sender.superview {
            
            let cell = cellView.superview?.superview as! UITableViewCell
            
            
            let indexPath = tableView.indexPath(for: cell)!
            
            alertVC.titleMsg = "Are your sure you want to delete this Review ?"
            alertVC.indexCell = indexPath
            alertVC.rowValue = "deleteUserReview"
            
            alertVC.modalPresentationStyle = .overCurrentContext
            self.present(alertVC, animated: false, completion: nil)
            
        }
    }
    
    @IBAction func dismissVC(_ sender: UIBarButtonItem) {
        
        WebServices.limit = 0
        WebServices.limitSearch = 0
        WebServices.limitFavProduct = 0
        WebServices.limitClientProduct = 0
        WebServices.limitSimilarProduct = 0

        
        self.dismiss(animated: false, completion: nil)
    }
    
    
    // FIVE BUTTONS FOR RATE
    @IBAction func button1Rate(_ sender: UIButton) {

        rate = "1"
        self.star1.setImage(UIImage(named: "star1")!, for: .normal)

        UIView.animate(withDuration: 1, animations: {

            self.rateView.isHidden = true
            self.postRate()
            
        })
    }
    
    @IBAction func button2Rate(_ sender: UIButton) {
        rate = "2"

        self.star1.setImage(UIImage(named: "star1")!, for: .normal)
        self.star2.setImage(UIImage(named: "star1")!, for: .normal)
        
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.postRate()
            self.rateView.isHidden = true

        }
    }
    
    @IBAction func button3Rate(_ sender: UIButton) {
        rate = "3"
        self.star1.setImage(UIImage(named: "star1")!, for: .normal)
        self.star2.setImage(UIImage(named: "star1")!, for: .normal)
        self.star3.setImage(UIImage(named: "star1")!, for: .normal)

        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.postRate()
            self.rateView.isHidden = true
            
        }
    }
    @IBAction func button4Rate(_ sender: UIButton) {
        rate = "4"
        self.star1.setImage(UIImage(named: "star1")!, for: .normal)
        self.star2.setImage(UIImage(named: "star1")!, for: .normal)
        self.star3.setImage(UIImage(named: "star1")!, for: .normal)
        self.star4.setImage(UIImage(named: "star1")!, for: .normal)

        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.postRate()
            self.rateView.isHidden = true
            
        }
    }
    
    @IBAction func button5Rate(_ sender: UIButton) {
        rate = "5"
        
        self.star1.setImage(UIImage(named: "star1")!, for: .normal)
        self.star2.setImage(UIImage(named: "star1")!, for: .normal)
        self.star3.setImage(UIImage(named: "star1")!, for: .normal)
        self.star4.setImage(UIImage(named: "star1")!, for: .normal)
        self.star5.setImage(UIImage(named: "star1")!, for: .normal)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.postRate()
            self.rateView.isHidden = true
        }
    }
    
    func postRate() {
        
        WebServices.addReview(idClient: idClient, rate: rate, data: reviewData.text!) { (success, msg) in
            if success {
                
                Helper.showSucces("Your Review is added", showOnTop: false)
                self.reviewData.text = ""
                self.getAllReviews()
                
            } else {
                
                Helper.showErrorMessage(msg!, showOnTop: false)
            }
        }
    }
    
    func getAllReviews() {
        
        // SAME AS ViewWillAppears
        WebServices.limit = 0
        WebServices.limitSearch = 0
        WebServices.limitFavProduct = 0
        WebServices.limitClientProduct = 0
        WebServices.limitSimilarProduct = 0
        
        tableData.removeAll()
        
        WebServices.getReviews(idClient: idClient) { (success, reviews) in
            if success {
                self.tableData = reviews!
            } else {
                Helper.showErrorMessage("Error While Loading Reviews!", showOnTop: false)
            }
        }
        
    }
}

extension ReviewVC: UITableViewDelegate {
    
    
}

extension ReviewVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell") as? ReviewCell {
            
            cell.review = tableData[indexPath.row]
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}

