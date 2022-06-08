//
//  DashboardVC.swift
//  Dual manager
//
//  Created by Khoi Nguyen on 8/17/21.
//

import UIKit
import Firebase

class DashboardVC: UIViewController {

    @IBOutlet weak var totalPostsLbl: UILabel!
    @IBOutlet weak var totalUsersLbl: UILabel!
    @IBOutlet weak var TotalViewsLbl: UILabel!
    @IBOutlet weak var totalChallengeLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard (Auth.auth().currentUser?.uid) != nil else {return}
        
        loadTotalViewCount()
        loadTotalPostCount()
        loadTotalUsersCount()
        loadTotalChallengesCount()
        
    }
    
    func loadTotalViewCount() {
        
        DataService.instance.mainFireStoreRef.collection("Views").addSnapshotListener { querySnapshot, error in
            guard querySnapshot != nil else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            if querySnapshot?.isEmpty == true {
                
                self.TotalViewsLbl.text = "0"
                
            } else {
                
                if let cnt = querySnapshot?.count {
                             
                    self.TotalViewsLbl.text = "\(formatPoints(num: Double(cnt)))"
                  
                } else {
                    self.TotalViewsLbl.text = "error"
                }
                
            }
                
            
        }
        
        
    }
    
    //
    
    func loadTotalPostCount() {
        
        DataService.instance.mainFireStoreRef.collection("Highlights").addSnapshotListener { querySnapshot, error in
            guard querySnapshot != nil else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            if querySnapshot?.isEmpty == true {
                
                self.totalPostsLbl.text = "0"
                
            } else {
                
                if let cnt = querySnapshot?.count {
                             
                    self.totalPostsLbl.text = "\(formatPoints(num: Double(cnt)))"
                  
                } else {
                    self.totalPostsLbl.text = "error"
                }
                
            }
                
            
        }
        
        
    }
    
    func loadTotalUsersCount() {
        
        DataService.instance.mainFireStoreRef.collection("Users").addSnapshotListener { querySnapshot, error in
            guard querySnapshot != nil else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            if querySnapshot?.isEmpty == true {
                
                self.totalUsersLbl.text = "0"
                
            } else {
                
                if let cnt = querySnapshot?.count {
                             
                    self.totalUsersLbl.text = "\(formatPoints(num: Double(cnt)))"
                  
                } else {
                    self.totalUsersLbl.text = "error"
                }
                
            }
                
            
        }
        
    }
    
    func loadTotalChallengesCount() {
        
        DataService.instance.mainFireStoreRef.collection("Challenges").addSnapshotListener { querySnapshot, error in
            guard querySnapshot != nil else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            if querySnapshot?.isEmpty == true {
                
                self.totalChallengeLbl.text = "0"
                
            } else {
                
                if let cnt = querySnapshot?.count {
                             
                    self.totalChallengeLbl.text = "\(formatPoints(num: Double(cnt)))"
                  
                } else {
                    self.totalChallengeLbl.text = "error"
                }
                
            }
                
            
        }
        
    }
    
    //

    @IBAction func moveToPostsVC(_ sender: Any) {
        
        self.performSegue(withIdentifier: "moveToPostsVC", sender: nil)
        
    }
    
    @IBAction func moveToUserVC(_ sender: Any) {
        
        self.performSegue(withIdentifier: "moveToUserVC", sender: nil)
        
    }
    
}
