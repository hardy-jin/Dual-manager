//
//  Highlight_report_processingVC.swift
//  Dual manager
//
//  Created by Khoi Nguyen on 10/26/21.
//

import UIKit
import AsyncDisplayKit
import MarqueeLabel
import SwiftPublicIP
import Alamofire
import Firebase

class Highlight_report_processingVC: UIViewController {

    
    var selected_report: ReportModel!
    
    @IBOutlet weak var suspendTimeLbl: UILabel!
    @IBOutlet weak var actionCmt: UITextView!
    @IBOutlet weak var actionTxt: UILabel!
    @IBOutlet weak var actionTime: UILabel!
    @IBOutlet weak var actionBtn: UIButton!
    @IBOutlet weak var caseStatusLbl: UILabel!
    @IBOutlet weak var staffUserUID: UILabel!
    @IBOutlet weak var caseNumberLbl: UILabel!
    @IBOutlet weak var reportDescLbl: UITextView!
    @IBOutlet weak var reportReasonLbl: UILabel!
    @IBOutlet weak var reportTimeLbl: UILabel!
    @IBOutlet weak var hashtagLbl: UILabel!
    @IBOutlet weak var onlyMeLbl: UILabel!
    @IBOutlet weak var followLbl: UILabel!
    @IBOutlet weak var publicLbl: UILabel!
    @IBOutlet weak var onlyMeBtn: UIButton!
    @IBOutlet weak var followersBtn: UIButton!
    @IBOutlet weak var PublicBtn: UIButton!
    @IBOutlet weak var allowComment: UISwitch!
    @IBOutlet weak var streamLinkLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var create_timeLbl: UILabel!
    @IBOutlet weak var userUID: UILabel!
    @IBOutlet weak var highlightTitle: UILabel!
    @IBOutlet weak var reportAction: UIButton!
    @IBOutlet weak var videoView: UIView!
    var selected_item: HighlightsModel!
    
    //
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if self.selected_report.description == "nil" {
            
            reportDescLbl.text = "No description"
            
        } else {
            
            reportDescLbl.text = self.selected_report.description
            
        }
        
        reportReasonLbl.text = self.selected_report.reason
       
        if #available(iOS 15.0, *) {
            reportTimeLbl.text = self.selected_report.timeStamp.dateValue().formatted(date: .long, time: .complete)
        } else {
            reportTimeLbl.text = self.selected_report.timeStamp.dateValue().timeIntervalSinceReferenceDate.dateFormatted(withFormat: "MM-dd-yyyy HH:mm")
        }
        
        caseNumberLbl.text = self.selected_report.reportID
        caseStatusLbl.text = self.selected_report.status
        
        if self.selected_report.staffID == "" {
            staffUserUID.text = "None"
        } else {
            staffUserUID.text = self.selected_report.staffID
        }
        
        if self.selected_report.status != "Pending" {
            actionBtn.setTitle(self.selected_report.status, for: .normal)
        }
        
        if self.selected_report.action != "" {
            actionTxt.text = self.selected_report.action
        } else {
            actionTxt.text = "None"
        }
        
        if self.selected_report.addition_comment == "" {
            
            actionCmt.text = "No comment"
            
        } else {
            
            actionCmt.text = self.selected_report.addition_comment
            
        }
        
        if self.selected_report.action_made_time == nil {
            
            actionTime.text = "None"
            
        } else {
            
            if #available(iOS 15.0, *) {
                actionTime.text = self.selected_report.action_made_time.dateValue().formatted(date: .long, time: .complete)
            } else {
                actionTime.text = self.selected_report.action_made_time.dateValue().timeIntervalSinceReferenceDate.dateFormatted(withFormat: "MM-dd-yyyy HH:mm")
            }
            
        }
        
        
        if self.selected_report.suspend_time != "" {
            
            suspendTimeLbl.text = self.selected_report.suspend_time
            
        } else {
            
            suspendTimeLbl.text = "None"
            
        }
        
       
        actionMade = false
        loadVideoInfo()
        
    }
    
    func loadVideoInfo() {
        
        DataService.instance.mainFireStoreRef.collection("Highlights").document(self.selected_report.highlight_id).getDocument { [self] (snap, err) in
            
            if err != nil {
                
                print(err!.localizedDescription)
                return
            }
            
            
            if snap?.exists != false {
                
                
                self.selected_item = HighlightsModel(postKey: snap!.documentID, Highlight_model: (snap?.data())!)
                
                if let Mux_playbackID = snap?.data()!["Mux_playbackID"] as? String {
                    
                    let mux_url = "https://image.mux.com/\(Mux_playbackID)/thumbnail.png?width=214&height=121&fit_mode=pad"
                    
                    let videoImageNode = ASNetworkImageNode()
                    videoImageNode.contentMode = .scaleAspectFill
                    videoImageNode.shouldRenderProgressImages = true
                    videoImageNode.animatedImagePaused = false
                    videoImageNode.url = URL.init(string: mux_url)
                    
   
                    videoImageNode.frame = self.videoView.layer.bounds
                  
                    
                    self.videoView.addSubnode(videoImageNode)
                }
                
                if let h_status = snap?.data()!["h_status"] as? String {
                    
                    
                    statusLbl.text = h_status
                    
                }
                
                if let post_time = snap?.data()!["post_time"] as? Timestamp {
                    
                    if #available(iOS 15.0, *) {
                        create_timeLbl.text = post_time.dateValue().formatted(date: .long, time: .complete)
                    } else {
                        create_timeLbl.text = post_time.dateValue().timeIntervalSinceReferenceDate.dateFormatted(withFormat: "MM-dd-yyyy HH:mm")
                    }
                    
                }
                
                if let Allow_comment = snap?.data()!["Allow_comment"] as? Bool {
                    
                    if Allow_comment == true {
                        
                        allowComment.setOn(true, animated: true)
                        
                    } else {
                        
                        allowComment.setOn(false, animated: true)
                        
                    }
                    
                }
                
                if let highlight_title = snap?.data()!["highlight_title"] as? String {
                    
                    if highlight_title == "nil" {
                        highlightTitle.text = "No title"
                    } else {
                        highlightTitle.text = highlight_title
                    }
                
                }
                
                if let stream_link = snap?.data()!["stream_link"] as? String {
                    
                    if stream_link == "nil" {
                        streamLinkLbl.text = "No stream link"
                    } else {
                        streamLinkLbl.text = stream_link
                    }
                    
                    
                }
                
                
                
                if let mode = snap?.data()!["mode"] as? String {
                    
                    if mode == "Public" {
                        
                        
                        PublicBtn.setImage(UIImage(named: "SelectedPublic"), for: .normal)
                        followersBtn.setImage(UIImage(named: "friends"), for: .normal)
                        onlyMeBtn.setImage(UIImage(named: "profile"), for: .normal)
                        
                        
                    } else if mode == "Followers" {
                        
                        
                        followersBtn.setImage(UIImage(named: "selectedFriends"), for: .normal)
                        PublicBtn.setImage(UIImage(named: "public"), for: .normal)
                        onlyMeBtn.setImage(UIImage(named: "profile"), for: .normal)
                        
                        
                    } else if mode == "Only me" {
                        
                        
                        onlyMeBtn.setImage(UIImage(named: "SelectedOnlyMe"), for: .normal)
                        followersBtn.setImage(UIImage(named: "friends"), for: .normal)
                        PublicBtn.setImage(UIImage(named: "public"), for: .normal)
                               
                    }
                    
                    
                    
                }
                
                if let userUIDs = snap?.data()!["userUID"] as? String {
                    
                    userUID.text = userUIDs
                    
                }
                
                if let hashtag_list = snap?.data()!["hashtag_list"] as? [String] {
                    
                    if hashtag_list.isEmpty != true {
                        
                        let hastag = hashtag_list.joined(separator: " ")
                        hashtagLbl.text = hastag
                        
                    } else {
                        
                        hashtagLbl.text = "No stream link"
                        
                    }
                    
                }
                
                if let stream_link = snap?.data()!["stream_link"] as? String {
                    
                    if stream_link != "nil" {
                        
                        streamLinkLbl.text = stream_link
                        
                    } else {
                        
                        streamLinkLbl.text = "No stream link"
                        
                    }
                    
                }
                
                
                
            }
            
            
        }
        
    }
    

    @IBAction func back1BtnPressed(_ sender: Any) {
       
        if actionMade == false, selected_report.status != "Completed" {
            DataService.instance.mainFireStoreRef.collection("video_report").document(selected_report.reportID).updateData(["status": "Pending"])
        }
        
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    @IBAction func reportActionBtnPressed(_ sender: Any) {
        
        if self.selected_report.status == "Pending" || self.selected_report.status == "Processing" {
            
            let slideVC = ReportActionVC()
            
            slideVC.video_report = true
            slideVC.selected_item = self.selected_report
            slideVC.reporting_highlight = self.selected_item
            slideVC.modalPresentationStyle = .custom
            slideVC.transitioningDelegate = self

            self.present(slideVC, animated: true, completion: nil)
            
            
        }
        
        
    }
    
    
    
    
    
    
    
    
    @IBAction func viewPostBtnPressed(_ sender: Any) {
        
        if selected_item != nil {
            
            if let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserHighlightFeedVC") as? UserHighlightFeedVC {
                
                controller.modalPresentationStyle = .fullScreen
                
                controller.video_list = [selected_item]
                controller.startIndex = 0
                self.present(controller, animated: true, completion: nil)
                
            }
            
            
        }
        
        
    }
    
    @IBAction func viewUserHistoryBtnPressed(_ sender: Any) {
        
        let slideVC = HistoryCharge()
        
        slideVC.charge_userUID = self.selected_item.userUID
        slideVC.selected_reported = self.selected_report
        slideVC.modalPresentationStyle = .custom
        slideVC.transitioningDelegate = self

        self.present(slideVC, animated: true, completion: nil)
        
    }
    
}
