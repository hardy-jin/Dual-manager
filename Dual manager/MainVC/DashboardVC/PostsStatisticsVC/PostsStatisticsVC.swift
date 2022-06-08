//
//  PostsStatisticsVC.swift
//  Dual manager
//
//  Created by Khoi Nguyen on 8/17/21.
//

import UIKit

class PostsStatisticsVC: UIViewController {

    @IBOutlet weak var totalPostsaDayLbl: UILabel!
    @IBOutlet weak var totalDeleteLbl: UILabel!
    @IBOutlet weak var totalDeleteaDayLbl: UILabel!
    @IBOutlet weak var totalLikesLbl: UILabel!
    
    @IBOutlet weak var totalLikesADayLbl: UILabel!
    
    @IBOutlet weak var totalwHashtagsLbl: UILabel!
    @IBOutlet weak var totalwStreamLinksLbl: UILabel!
    
    @IBOutlet weak var totalwCommentsLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadTotalPostADay()
        loadTotalDelete()
        loadTotalDeleteaDay()
        loadTotalLike()
        loadTotalLikeaDay()
        loadTotalwStreamlink()
        loadTotalwHashtag()
        loadTotalwComments()
        
    }
    
    @IBAction func back1BtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func back2BtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    //
    
    func loadTotalPostADay() {
        //post_time
        let timeNow = Date().timeIntervalSince1970
        let time24hoursBeforeNow = timeNow - 24 * 60 * 60
        let date = NSDate(timeIntervalSince1970: time24hoursBeforeNow)
       
        DataService.instance.mainFireStoreRef.collection("Highlights").whereField("post_time", isGreaterThan: date).getDocuments { querySnapshot, error in
            guard querySnapshot != nil else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            if querySnapshot?.isEmpty == true {
                
                self.totalPostsaDayLbl.text = "0"
                
            } else {
                
                if let cnt = querySnapshot?.count {
                             
                    self.totalPostsaDayLbl.text = "\(formatPoints(num: Double(cnt)))"
                  
                } else {
                    self.totalPostsaDayLbl.text = "error"
                }
                
            }
                
            
        }
        
        
    }
    
    //
    
    func loadTotalDeleteaDay() {
        //post_time
        let timeNow = Date().timeIntervalSince1970
        let time24hoursBeforeNow = timeNow - 24 * 60 * 60
        let date = NSDate(timeIntervalSince1970: time24hoursBeforeNow)
       
        DataService.instance.mainFireStoreRef.collection("Highlights").whereField("post_time", isGreaterThan: date).whereField("h_status", isEqualTo: "Deleted").getDocuments { querySnapshot, error in
            guard querySnapshot != nil else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            if querySnapshot?.isEmpty == true {
                
                self.totalDeleteaDayLbl.text = "0"
                
            } else {
                
                if let cnt = querySnapshot?.count {
                             
                    self.totalDeleteaDayLbl.text = "\(formatPoints(num: Double(cnt)))"
                  
                } else {
                    self.totalDeleteaDayLbl.text = "error"
                }
                
            }
                
            
        }
        
        
    }
    
    //
    
    func loadTotalDelete() {
        //post_time
       
        
        DataService.instance.mainFireStoreRef.collection("Highlights").whereField("h_status", isEqualTo: "Deleted").getDocuments { querySnapshot, error in
            guard querySnapshot != nil else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            if querySnapshot?.isEmpty == true {
                
                self.totalDeleteLbl.text = "0"
                
            } else {
                
                if let cnt = querySnapshot?.count {
                             
                    self.totalDeleteLbl.text = "\(formatPoints(num: Double(cnt)))"
                  
                } else {
                    self.totalDeleteLbl.text = "error"
                }
                
            }
                
            
        }
        
        
    }
    
    func loadTotalLike() {
        //post_time
       
        DataService.instance.mainFireStoreRef.collection("Likes").getDocuments { querySnapshot, error in
            guard querySnapshot != nil else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            if querySnapshot?.isEmpty == true {
                
                self.totalLikesLbl.text = "0"
                
            } else {
                
                if let cnt = querySnapshot?.count {
                             
                    self.totalLikesLbl.text = "\(formatPoints(num: Double(cnt)))"
                  
                } else {
                    self.totalLikesLbl.text = "error"
                }
                
            }
                
            
        }
        
        
    }
    
    func loadTotalLikeaDay() {
        //post_time
        
        
        let timeNow = Date().timeIntervalSince1970
        let time24hoursBeforeNow = timeNow - 24 * 60 * 60
        let date = NSDate(timeIntervalSince1970: time24hoursBeforeNow)
       
        DataService.instance.mainFireStoreRef.collection("Likes").whereField("timeStamp", isGreaterThan: date).getDocuments { querySnapshot, error in
            guard querySnapshot != nil else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            if querySnapshot?.isEmpty == true {
                
                self.totalLikesADayLbl.text = "0"
                
            } else {
                
                if let cnt = querySnapshot?.count {
                             
                    self.totalLikesADayLbl.text = "\(formatPoints(num: Double(cnt)))"
                  
                } else {
                    self.totalLikesADayLbl.text = "error"
                }
                
            }
                
            
        }
        
        
    }
    
    
    func loadTotalwHashtag() {
        //post_time
       
        DataService.instance.mainFireStoreRef.collection("Highlights").whereField("is_hashtaged", isEqualTo: true).getDocuments { querySnapshot, error in
            guard querySnapshot != nil else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            if querySnapshot?.isEmpty == true {
                
                self.totalwHashtagsLbl.text = "0"
                
            } else {
                
                if let cnt = querySnapshot?.count {
                             
                    self.totalwHashtagsLbl.text = "\(formatPoints(num: Double(cnt)))"
                  
                } else {
                    self.totalwHashtagsLbl.text = "error"
                }
                
            }
                
            
        }
        
        
    }
    
    func loadTotalwStreamlink() {
        //post_time
       
        DataService.instance.mainFireStoreRef.collection("Highlights").whereField("stream_link", isNotEqualTo: "nil").getDocuments { querySnapshot, error in
            guard querySnapshot != nil else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            if querySnapshot?.isEmpty == true {
                
                self.totalwHashtagsLbl.text = "0"
                
            } else {
                
                if let cnt = querySnapshot?.count {
                             
                    self.totalwStreamLinksLbl.text = "\(formatPoints(num: Double(cnt)))"
                  
                } else {
                    self.totalwStreamLinksLbl.text = "error"
                }
                
            }
                
            
        }
        
        
    }
    
    
    
    func loadTotalwComments() {
        //post_time
       
        DataService.instance.mainFireStoreRef.collection("Comments").getDocuments { querySnapshot, error in
            guard querySnapshot != nil else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            if querySnapshot?.isEmpty == true {
                
                self.totalwCommentsLbl.text = "0"
                
            } else {
                
                if let cnt = querySnapshot?.count {
                             
                    self.totalwCommentsLbl.text = "\(formatPoints(num: Double(cnt)))"
                  
                } else {
                    self.totalwCommentsLbl.text = "error"
                }
                
            }
                
            
        }
        
        
    }

}
