//
//  VideoReportNode.swift
//  Dual manager
//
//  Created by Khoi Nguyen on 10/25/21.
//

import UIKit
import AsyncDisplayKit
import MarqueeLabel
import SwiftPublicIP
import Alamofire
import Firebase


fileprivate let OrganizerImageSize: CGFloat = 40
fileprivate let HorizontalBuffer: CGFloat = 10
fileprivate let FontSize: CGFloat = 13


class VideoReportNode: ASCellNode {
    
    var report: ReportModel
    let selectedColor = UIColor(red: 248/255, green: 189/255, blue: 91/255, alpha: 1.0)
    
    var statusNode: ASTextNode!
    var timeNode: ASTextNode!
    var ReasonNode: ASTextNode!
    var videoImageNode: ASNetworkImageNode!
    
    init(with report: ReportModel) {
        
        self.report = report
        self.statusNode = ASTextNode()
        self.timeNode = ASTextNode()
        self.ReasonNode = ASTextNode()
        self.videoImageNode = ASNetworkImageNode()
        
        super.init()
        
        self.backgroundColor = UIColor.clear
        
        self.selectionStyle = .none
        videoImageNode.cornerRadius = OrganizerImageSize/2
        videoImageNode.clipsToBounds = true
        statusNode.isLayerBacked = true
        timeNode.isLayerBacked = true
        ReasonNode.isLayerBacked = true
        
        
        
        statusNode.backgroundColor = UIColor.clear
        timeNode.backgroundColor = UIColor.clear
        ReasonNode.backgroundColor = UIColor.clear
        
        automaticallyManagesSubnodes = true
        
        
        
        let timeAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: FontSize, weight: .light),NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        
        
        let paragraphStyles = NSMutableParagraphStyle()
        paragraphStyles.alignment = .left
        
        ReasonNode.attributedText = NSAttributedString(string: self.report.reason, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: FontSize + 1), NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.paragraphStyle: paragraphStyles])
        
        statusNode.attributedText = NSAttributedString(string: self.report.status, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: FontSize + 1), NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.paragraphStyle: paragraphStyles])
        
        let date = self.report.timeStamp.dateValue()
        timeNode.attributedText = NSAttributedString(string: "\(timeAgoSinceDate(date, numericDates: true))", attributes: timeAttributes)
        
        loadImgVideo()
        
        
    }
    
    func loadImgVideo() {
        
        DataService.instance.mainFireStoreRef.collection("Highlights").document(self.report.highlight_id).getDocument { [self] (snap, err) in
            
            if err != nil {
                
                print(err!.localizedDescription)
                return
            }
            
            
            if snap?.exists != false {
                
                
                if let Mux_playbackID = snap?.data()!["Mux_playbackID"] as? String {
                    
                    let mux_url = "https://image.mux.com/\(Mux_playbackID)/thumbnail.png?width=214&height=121&fit_mode=pad"
                    
                    videoImageNode.contentMode = .scaleAspectFill
                    videoImageNode.shouldRenderProgressImages = true
                    videoImageNode.animatedImagePaused = false
                    videoImageNode.url = URL.init(string: mux_url)
                }
                
                
                
            }
            
            
        }
        
        
        
    }
    
    
    
    
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        
        let horizontalStack = ASStackLayoutSpec.horizontal()
        
        horizontalStack.spacing = 10
        horizontalStack.justifyContent = ASStackLayoutJustifyContent.start
        horizontalStack.alignItems = .center
        
        horizontalStack.children = [statusNode, timeNode]
        
        
        
        let headerSubStack = ASStackLayoutSpec.vertical()
        
        
        videoImageNode.style.preferredSize = CGSize(width: OrganizerImageSize, height: OrganizerImageSize)
       
        
        headerSubStack.style.flexShrink = 16.0
        headerSubStack.style.flexGrow = 16.0
        headerSubStack.spacing = 7.0
        
        headerSubStack.children = [horizontalStack, ReasonNode]
      
  
        let headerStack = ASStackLayoutSpec.horizontal()
      
        
        headerStack.spacing = 10
        headerStack.justifyContent = ASStackLayoutJustifyContent.start
        headerStack.alignItems = .center
        headerStack.children = [videoImageNode, headerSubStack]
        
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 16.0, left: 16, bottom: 16, right: 16), child: headerStack)
            
    }
    
}
