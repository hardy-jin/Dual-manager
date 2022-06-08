//
//  UsersStatisticsVC.swift
//  Dual manager
//
//  Created by Khoi Nguyen on 8/17/21.
//

import UIKit

class UsersStatisticsVC: UIViewController {

    @IBOutlet weak var newUsersLbl: UILabel!
    @IBOutlet weak var suspendUsersLbl: UILabel!
    @IBOutlet weak var normalUserLbl: UILabel!
    
    @IBOutlet weak var FacebookUsersLbl: UILabel!
    
    @IBOutlet weak var googleUsersLbl: UILabel!
    @IBOutlet weak var twitterUserLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadNewUsers()
        loadsuspendUsers()
        loadnormalUsers()
        loadfbUsers()
        loadggUsers()
        loadttUsers()
        
    }
    
    @IBAction func back1BtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func back2BtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    //
    
    func loadNewUsers() {
        //post_time
        let timeNow = Date().timeIntervalSince1970
        let time24hoursBeforeNow = timeNow - 24 * 60 * 60
        let date = NSDate(timeIntervalSince1970: time24hoursBeforeNow)
       
        DataService.instance.mainFireStoreRef.collection("Users").whereField("create_time", isGreaterThan: date).getDocuments { querySnapshot, error in
            guard querySnapshot != nil else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            if querySnapshot?.isEmpty == true {
                
                self.newUsersLbl.text = "0"
                
            } else {
                
                if let cnt = querySnapshot?.count {
                             
                    self.newUsersLbl.text = "\(formatPoints(num: Double(cnt)))"
                  
                } else {
                    self.newUsersLbl.text = "error"
                }
                
            }
                
            
        }
        
        
    }
    
    func loadsuspendUsers() {
        //post_time
       
       
        DataService.instance.mainFireStoreRef.collection("Users").whereField("is_suspend", isEqualTo: true).getDocuments { querySnapshot, error in
            guard querySnapshot != nil else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            if querySnapshot?.isEmpty == true {
                
                self.suspendUsersLbl.text = "0"
                
            } else {
                
                if let cnt = querySnapshot?.count {
                             
                    self.suspendUsersLbl.text = "\(formatPoints(num: Double(cnt)))"
                  
                } else {
                    self.suspendUsersLbl.text = "error"
                }
                
            }
                
            
        }
        
        
    }
    
    func loadnormalUsers() {
        //post_time
       
        DataService.instance.mainFireStoreRef.collection("Users").whereField("Create_mode", isEqualTo: "Original").getDocuments { querySnapshot, error in
            guard querySnapshot != nil else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            if querySnapshot?.isEmpty == true {
                
                self.normalUserLbl.text = "0"
                
            } else {
                
                if let cnt = querySnapshot?.count {
                             
                    self.normalUserLbl.text = "\(formatPoints(num: Double(cnt)))"
                  
                } else {
                    self.normalUserLbl.text = "error"
                }
                
            }
                
            
        }
        
        
    }
    
    func loadfbUsers() {
        //post_time
       
        DataService.instance.mainFireStoreRef.collection("Users").whereField("Create_mode", isEqualTo: "Facebook").getDocuments { querySnapshot, error in
            guard querySnapshot != nil else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            if querySnapshot?.isEmpty == true {
                
                self.FacebookUsersLbl.text = "0"
                
            } else {
                
                if let cnt = querySnapshot?.count {
                             
                    self.FacebookUsersLbl.text = "\(formatPoints(num: Double(cnt)))"
                  
                } else {
                    self.FacebookUsersLbl.text = "error"
                }
                
            }
                
            
        }
        
        
    }
    
    func loadggUsers() {
        //post_time
       
        DataService.instance.mainFireStoreRef.collection("Users").whereField("Create_mode", isEqualTo: "Google").getDocuments { querySnapshot, error in
            guard querySnapshot != nil else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            if querySnapshot?.isEmpty == true {
                
                self.googleUsersLbl.text = "0"
                
            } else {
                
                if let cnt = querySnapshot?.count {
                             
                    self.googleUsersLbl.text = "\(formatPoints(num: Double(cnt)))"
                  
                } else {
                    self.googleUsersLbl.text = "error"
                }
                
            }
                
            
        }
        
        
    }
    
    func loadttUsers() {
        //post_time
       
        DataService.instance.mainFireStoreRef.collection("Users").whereField("Create_mode", isEqualTo: "Twitter").getDocuments { querySnapshot, error in
            guard querySnapshot != nil else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            if querySnapshot?.isEmpty == true {
                
                self.twitterUserLbl.text = "0"
                
            } else {
                
                if let cnt = querySnapshot?.count {
                             
                    self.twitterUserLbl.text = "\(formatPoints(num: Double(cnt)))"
                  
                } else {
                    self.twitterUserLbl.text = "error"
                }
                
            }
                
            
        }
        
        
    }
    

}
