//
//  ReportAction.swift
//  Dual manager
//
//  Created by Khoi Nguyen on 10/26/21.
//

import UIKit
import Firebase

class ReportActionVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {

    
    var user_report = false
    var video_report = false
    var comment_report = false
    var challenge_report = false
    @IBOutlet weak var report_title: UILabel!
    @IBOutlet weak var descriptionTxtView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var Cpview: UIView!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var suspendTimeTxtField: UITextField!
    var suspend_action_time = ""
    var selected_item: ReportModel!
    var reporting_highlight: HighlightsModel!
    var reporting_challenge: ChallengeModel!
    var reporting_User: UserModel!
    var reporting_Comment: CommentModel!
    
    var action = ""
    var suspended_time = ["1 day", "3 days", "7 days", "30 days", "60 days", "120 days", "Permanently"]
    let user_report_list = ["Suspend user", "Mark as warning", "Dismiss"]
    
    let video_report_list = ["Delete post","Delete post & Suspend user", "Mark as warning", "Dismiss"]
    
    let comment_report_list = ["Delete comment","Delete comment & Suspend user", "Mark as warning", "Dismiss"]
    
    let challenge_report_list = ["Suspend user", "Mark as warning", "Dismiss"]
    
    var dayPicker = UIPickerView()
    var willSuspend = false
    var willSuspendTime = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        if user_report == true {
            
            report_title.text = "User case action"
            
        } else if video_report == true {
            
            report_title.text = "Video case action"
            
        } else if comment_report == true {
            
            report_title.text = "Comment case action"
            
        } else if challenge_report == true {
            
            report_title.text = "Challenge case action"
            
        }
        
        
        self.tableView.register(UINib(nibName: "reportCell", bundle: nil), forCellReuseIdentifier: "reportCell")
        
        descriptionTxtView.delegate = self
        self.dayPicker.delegate = self
        suspendTimeTxtField.addTarget(self, action: #selector(ReportActionVC.openSuspendTimeBtnPressed), for: .editingDidBegin)
        
    }
    
    @objc func openSuspendTimeBtnPressed() {
        
        createDayPicker()
        
    }
    
    func createDayPicker() {

        suspendTimeTxtField.inputView = dayPicker

    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if descriptionTxtView.text == "Make any comment for the case!" {
            
            descriptionTxtView.text = ""
            
        }
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if descriptionTxtView.text == "" {
            
            descriptionTxtView.text = "Make any comment for the case!"
            
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if user_report == true {
            return user_report_list.count
        } else if video_report == true {
            return video_report_list.count
        } else if comment_report == true {
            return comment_report_list.count
        } else if challenge_report == true {
            return challenge_report_list.count
        } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var item: String?
        
        if user_report == true {
            item = user_report_list[indexPath.row]
        } else if video_report == true {
            item = video_report_list[indexPath.row]
        } else if comment_report == true {
            item = comment_report_list[indexPath.row]
        } else if challenge_report == true {
            item = challenge_report_list[indexPath.row]
        } else {
            item = ""
        }
             
        if let cell = tableView.dequeueReusableCell(withIdentifier: "reportCell") as? reportCell {
            
            
            
            cell.cellConfigured(report: item!)
            return cell
            
            
        } else {
            
            return UITableViewCell()
            
        }
       
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.view.endEditing(true)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    
        if user_report == true {
            action = user_report_list[indexPath.row]
            
            if action == "Suspend user" {
                willSuspend = true
            } else {
                willSuspend = false
                willSuspendTime = 0
            }
            
        } else if video_report == true {
            action = video_report_list[indexPath.row]
            
            if action == "Delete post & Suspend user" {
                willSuspend = true
            } else {
                willSuspend = false
                willSuspendTime = 0
            }
            
        } else if comment_report == true {
            action = comment_report_list[indexPath.row]
            
            if action == "Delete comment & Suspend user" {
                willSuspend = true
            } else {
                willSuspend = false
                willSuspendTime = 0
            }
            
        } else if challenge_report == true {
            action = challenge_report_list[indexPath.row]
            
            if action == "Suspend user" {
                willSuspend = true
            } else {
                willSuspend = false
                willSuspendTime = 0
            }
            
        }
                
        descriptionView.isHidden = false
        
        
    }
    
    @IBAction func SkipBtnPressed(_ sender: Any) {
        
        var actionMade = ["action_made_time": FieldValue.serverTimestamp(), "action": action, "staffID": Auth.auth().currentUser!.uid, "addition_comment": "nil", "status": "Completed"] as [String : Any]
        var historyCharge = ["action_made_time": FieldValue.serverTimestamp(), "action": action, "staffID": Auth.auth().currentUser!.uid, "reason": selected_item.reason!, "report_time": selected_item.timeStamp!, "addition_comment": "nil", "reportID": self.selected_item.reportID!] as [String : Any]
        
        if willSuspend == true {
            
            if willSuspendTime != 0 {
                     
                if user_report == true {
                    
                    historyCharge.updateValue("user_report", forKey: "type")
                    historyCharge.updateValue(self.selected_item.reported_userUID!, forKey: "charged_userUID")
                    
                    
                } else if video_report == true {
                    
                    
                    historyCharge.updateValue(self.reporting_highlight.highlight_id!, forKey: "charged_highlightID")
                    historyCharge.updateValue(self.reporting_highlight.userUID!, forKey: "charged_userUID")
                    historyCharge.updateValue(suspend_action_time, forKey: "suspend_time")
                    historyCharge.updateValue("video_report", forKey: "type")
                    actionMade.updateValue(suspend_action_time, forKey: "suspend_time")
                    
                    //"Delete post","Delete post & Suspend user", "Mark as warning", "Dismiss"
                    
                    if action == "Delete post" {
                        
                        DeletePost(action: actionMade, history: historyCharge)
                        
                    } else if action == "Delete post & Suspend user" {
                        
                        DeletePostAndSuspendUser(action: actionMade, history: historyCharge)
                        
                    } else if action == "Mark as warning" {
                        
                        RecordWarning(action: actionMade, history: historyCharge)
                        
                    } else if action == "Dismiss" {
                        
                        Dismiss(action: actionMade)
                        
                    } else {
                        
                        self.showErrorAlert("Oops!", msg: "No action is made, please try again")
                        
                    }
                    
                    
                } else if comment_report == true {
                    
                    
                    historyCharge.updateValue(self.reporting_Comment.Comment_id!, forKey: "charged_commentID")
                    historyCharge.updateValue(self.reporting_Comment.owner_uid!, forKey: "charged_userUID")
                    historyCharge.updateValue("comment_report", forKey: "type")
                    
                } else if challenge_report == true {
                    
                    
                    historyCharge.updateValue(self.selected_item.challenge_id!, forKey: "charged_highlightID")
                    historyCharge.updateValue("challenge_report", forKey: "type")
                    
                    for id in self.reporting_challenge.uid_list {
                        if id != self.selected_item.userUID {
                            historyCharge.updateValue(id, forKey: "charged_userUID")
                        }
                    }
                    
                }
                
                
                
                
            } else {
                
                self.showErrorAlert("Oops!", msg: "You choose to suspend user without suspend time, please try again.")
                
            }
            
            
        } else {
            
           
            
            if user_report == true {
                
                
                historyCharge.updateValue(self.selected_item.reported_userUID!, forKey: "charged_userUID")
                historyCharge.updateValue("user_report", forKey: "type")
                
            } else if video_report == true {
                
                
                historyCharge.updateValue(self.reporting_highlight.highlight_id!, forKey: "charged_highlightID")
                historyCharge.updateValue(self.reporting_highlight.userUID!, forKey: "charged_userUID")
                historyCharge.updateValue("video_report", forKey: "type")
                
                if action == "Mark as warning" {
                    
                    RecordWarning(action: actionMade, history: historyCharge)
                    
                } else if action == "Dismiss" {
                    
                    Dismiss(action: actionMade)
                    
                } else {
                    
                    self.showErrorAlert("Oops!", msg: "No action is made, please try again")
                    
                }
                
                
            } else if comment_report == true {
                
                
                historyCharge.updateValue(self.reporting_Comment.Comment_id!, forKey: "charged_commentID")
                historyCharge.updateValue(self.reporting_Comment.owner_uid!, forKey: "charged_userUID")
                historyCharge.updateValue("comment_report", forKey: "type")
                
            } else if challenge_report == true {
                
                
                historyCharge.updateValue(self.selected_item.challenge_id!, forKey: "charged_highlightID")
                historyCharge.updateValue("challenge_report", forKey: "type")
                
                for id in self.reporting_challenge.uid_list {
                    if id != self.selected_item.userUID {
                        historyCharge.updateValue(id, forKey: "charged_userUID")
                    }
                }
                
            }
            
            
        }
       
        
    }
    
    func DeletePost(action: [String : Any], history: [String : Any]) {
        
        let db = DataService.instance.mainFireStoreRef
        
        
        //h_status
        
        db.collection("Highlights").document(reporting_highlight.highlight_id).updateData(["h_status": "Deleted", "Deleted_by": Auth.auth().currentUser!.uid, "Reason": self.selected_item.reason!]) { (err) in
            
           
            
            if let err = err {
                self.showErrorAlert("Oops!", msg: "Error removing document: \(err)")
            } else {
                print("Document successfully removed!")

                self.terminateAllUserPost(userUID: self.reporting_highlight.userUID!)
                db.collection("video_report").document(self.selected_item.reportID).updateData(action)
                db.collection("history_charge").addDocument(data: history)
                
                self.view.endEditing(true)
                self.tableView.isHidden = true
                self.descriptionView.isHidden = true
                self.Cpview.isHidden = false
                actionMade = true
                //db.collection("history_charge").addDocument(data: history)
                    
            }
        }
        
    }
    
    func DeletePostAndSuspendUser(action: [String : Any], history: [String : Any]) {
        
        let db = DataService.instance.mainFireStoreRef
        
        db.collection("Highlights").document(reporting_highlight.highlight_id).updateData(["h_status": "Deleted", "Deleted_by": Auth.auth().currentUser!.uid, "Reason": self.selected_item.reason!]) { (err) in
            
            DispatchQueue.main.async {
                SwiftLoader.hide()
            }
            
            if let err = err {
                self.showErrorAlert("Oops!", msg: "Error removing document: \(err)")
            } else {
                
                self.terminateAllUserPost(userUID: self.reporting_highlight.userUID!)
                
                DataService.init().mainFireStoreRef.collection("Users").whereField("userUID", isEqualTo: self.reporting_highlight.userUID!).getDocuments { [self] querySnapshot, error in
                        guard let snapshot = querySnapshot else {
                            print("Error fetching snapshots: \(error!)")
       
                            return
                    }
                    
                    
                    if snapshot.isEmpty != true {
                        
                        for user in snapshot.documents {
                            
                         
                            let timeNow = UInt.init(Date().timeIntervalSince1970) + UInt.init(willSuspendTime * 60 * 60 * 24)
                            let myNSDate = Date(timeIntervalSince1970: TimeInterval(timeNow))
                            let expireTime = Timestamp(date: myNSDate)
                            
                            db.collection("Users").document(user.documentID).updateData(["is_suspend": true, "suspend_reason": self.selected_item.reason!, "suspend_time": expireTime]) { (error) in
                                
                                DispatchQueue.main.async {
                                    SwiftLoader.hide()
                                }
                                
                                if let err = error {
                                    self.showErrorAlert("Oops!", msg: "Error suspending user: \(err)")
                                } else {
                                    
                                    db.collection("video_report").document(self.selected_item.reportID).updateData(action)
                                    db.collection("history_charge").addDocument(data: history)
                                    
                                    
                                    self.view.endEditing(true)
                                    self.tableView.isHidden = true
                                    self.descriptionView.isHidden = true
                                    self.Cpview.isHidden = false
                                    actionMade = true
                                }
                                
                            }
                            
                        }
                        
                        
                        
                        
                    }
                           
                    
                }
                
                    
            }
        }
        
    }
    
    func RecordWarning(action: [String : Any], history: [String : Any]) {
        
        let db = DataService.instance.mainFireStoreRef
        
        db.collection("video_report").document(self.selected_item.reportID).updateData(action)
        db.collection("history_charge").addDocument(data: history)
        
        self.view.endEditing(true)
        self.tableView.isHidden = true
        self.descriptionView.isHidden = true
        self.Cpview.isHidden = false
        actionMade = true
        
    }
    
    func Dismiss(action: [String : Any]) {
        
        let db = DataService.instance.mainFireStoreRef
        
        db.collection("video_report").document(self.selected_item.reportID).updateData(action)
        
        
        self.view.endEditing(true)
        self.tableView.isHidden = true
        self.descriptionView.isHidden = true
        self.Cpview.isHidden = false
        actionMade = true
        
    }
    
    @IBAction func SubmitBtnPressed(_ sender: Any) {
        
        if let text = descriptionTxtView.text, text != "", text != "Make any comment for the case!", text.count > 5 {
            
            var actionMade = ["action_made_time": FieldValue.serverTimestamp(), "action": action, "staffID": Auth.auth().currentUser!.uid, "addition_comment": text, "status": "Completed"] as [String : Any]
            var historyCharge = ["action_made_time": FieldValue.serverTimestamp(), "action": action, "staffID": Auth.auth().currentUser!.uid, "reason": selected_item.reason!, "report_time": selected_item.timeStamp!, "addition_comment": "nil", "reportID": self.selected_item.reportID!] as [String : Any]
            
            if willSuspend == true {
                
                if willSuspendTime != 0 {
                         
                    if user_report == true {
                        
                        historyCharge.updateValue("user_report", forKey: "type")
                        historyCharge.updateValue(self.selected_item.reported_userUID!, forKey: "charged_userUID")
                        
                        
                    } else if video_report == true {
                        
                        
                        historyCharge.updateValue(self.reporting_highlight.highlight_id!, forKey: "charged_highlightID")
                        historyCharge.updateValue(self.reporting_highlight.userUID!, forKey: "charged_userUID")
                        historyCharge.updateValue(suspend_action_time, forKey: "suspend_time")
                        historyCharge.updateValue("video_report", forKey: "type")
                        actionMade.updateValue(suspend_action_time, forKey: "suspend_time")
                        
                        //"Delete post","Delete post & Suspend user", "Mark as warning", "Dismiss"
                        
                        if action == "Delete post" {
                            
                            DeletePost(action: actionMade, history: historyCharge)
                            
                        } else if action == "Delete post & Suspend user" {
                            
                            DeletePostAndSuspendUser(action: actionMade, history: historyCharge)
                            
                        } else if action == "Mark as warning" {
                            
                            RecordWarning(action: actionMade, history: historyCharge)
                            
                        } else if action == "Dismiss" {
                            
                            Dismiss(action: actionMade)
                            
                        } else {
                            
                            self.showErrorAlert("Oops!", msg: "No action is made, please try again")
                            
                        }
                        
                        
                    } else if comment_report == true {
                        
                        
                        historyCharge.updateValue(self.reporting_Comment.Comment_id!, forKey: "charged_commentID")
                        historyCharge.updateValue(self.reporting_Comment.owner_uid!, forKey: "charged_userUID")
                        historyCharge.updateValue("comment_report", forKey: "type")
                        
                    } else if challenge_report == true {
                        
                        
                        historyCharge.updateValue(self.selected_item.challenge_id!, forKey: "charged_highlightID")
                        historyCharge.updateValue("challenge_report", forKey: "type")
                        
                        for id in self.reporting_challenge.uid_list {
                            if id != self.selected_item.userUID {
                                historyCharge.updateValue(id, forKey: "charged_userUID")
                            }
                        }
                        
                    }
                    
                    
                    
                    
                } else {
                    
                    self.showErrorAlert("Oops!", msg: "You choose to suspend user without suspend time, please try again.")
                    
                }
                
                
            } else {
                
                if user_report == true {
                    
                    historyCharge.updateValue("user_report", forKey: "type")
                    historyCharge.updateValue(self.selected_item.reported_userUID!, forKey: "charged_userUID")
                    
                    
                } else if video_report == true {
                    
                    
                    historyCharge.updateValue(self.reporting_highlight.highlight_id!, forKey: "charged_highlightID")
                    historyCharge.updateValue(self.reporting_highlight.userUID!, forKey: "charged_userUID")
                    historyCharge.updateValue("video_report", forKey: "type")
                    
                    if action == "Mark as warning" {
                        
                        RecordWarning(action: actionMade, history: historyCharge)
                        
                    } else if action == "Dismiss" {
                        
                        Dismiss(action: actionMade)
                        
                    } else {
                        
                        self.showErrorAlert("Oops!", msg: "No action is made, please try again")
                        
                    }
                    
                    
                } else if comment_report == true {
                    
                    
                    historyCharge.updateValue(self.reporting_Comment.Comment_id!, forKey: "charged_commentID")
                    historyCharge.updateValue(self.reporting_Comment.owner_uid!, forKey: "charged_userUID")
                    historyCharge.updateValue("comment_report", forKey: "type")
                    
                } else if challenge_report == true {
                    
                    
                    historyCharge.updateValue(self.selected_item.challenge_id!, forKey: "charged_highlightID")
                    historyCharge.updateValue("challenge_report", forKey: "type")
                    
                    for id in self.reporting_challenge.uid_list {
                        if id != self.selected_item.userUID {
                            historyCharge.updateValue(id, forKey: "charged_userUID")
                        }
                    }
                    
                }
                
            }
            
        } else {
            
            self.showErrorAlert("Oops!", msg: "Please make more then 5 characters comment.")
            
        }
        
    }
    
    func terminateAllUserPost(userUID: String) {
        
        let db = DataService.instance.mainFireStoreRef
        
        db.collection("Highlights").whereField("userUID", isEqualTo: userUID).getDocuments{ querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
        
            if snapshot.isEmpty != true {
                
                for item in snapshot.documents {
                    
                    let highlightItem = HighlightsModel(postKey: item.documentID, Highlight_model: item.data())
                    
                    if highlightItem.status != "Deleted" {
                        
                        
                        db.collection("Highlights").document(highlightItem.highlight_id).updateData(["h_status": "Terminated"])
                        
                    }
                    
                    
                }
               
                
            }
        
        }
    }
    
    
    func showErrorAlert(_ title: String, msg: String) {
                                                                                                                                           
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
                                                                                       
        present(alert, animated: true, completion: nil)
        
    }



}


extension ReportActionVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1

    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    
        return suspended_time.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.backgroundColor = UIColor.darkGray
            pickerLabel?.font = UIFont.systemFont(ofSize: 15)
            pickerLabel?.textAlignment = .center
            pickerLabel?.textColor = UIColor.white
        }
        
        pickerLabel?.text = suspended_time[row]
        

        return pickerLabel!
        
    }
    
   
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       
        //"1 day", "3 days", "7 days", "30 days", "60 days", "120 days", "Permanently"
        suspendTimeTxtField.text = suspended_time[row]
        suspend_action_time = suspended_time[row]
        
        if suspended_time[row] == "1 day"{
            
            willSuspendTime = 1
            
        } else if suspended_time[row] == "3 days" {
            
            willSuspendTime = 3
            
        } else if suspended_time[row] == "7 days" {
            
            willSuspendTime = 7
            
        }
        else if suspended_time[row] == "30 days" {
            
            willSuspendTime = 30
            
        }
        else if suspended_time[row] == "60 days" {
            
            willSuspendTime = 60
            
        }
        else if suspended_time[row] == "120 days" {
            
            willSuspendTime = 120
            
        }
        else if suspended_time[row] == "Permanently" {
            
            willSuspendTime = 10000
            
        }
    
        
    }
    
}
