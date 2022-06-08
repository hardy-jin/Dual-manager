//
//  ChargeNode.swift
//  Dual manager
//
//  Created by Khoi Nguyen on 10/27/21.
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


class ChargeNode: ASCellNode {
    
    
    var charge: ChargeModel
    let selectedColor = UIColor(red: 248/255, green: 189/255, blue: 91/255, alpha: 1.0)
    
    var statusNode: ASTextNode!
    var timeNode: ASTextNode!
    var ReasonNode: ASTextNode!
    var userImageNode: ASNetworkImageNode!
    
    init(with charge: ChargeModel) {
        
        self.charge = charge
        self.statusNode = ASTextNode()
        self.timeNode = ASTextNode()
        self.ReasonNode = ASTextNode()
        self.userImageNode = ASNetworkImageNode()
        
        super.init()
        
        self.backgroundColor = UIColor.clear
        
        self.selectionStyle = .none
        userImageNode.cornerRadius = OrganizerImageSize/2
        userImageNode.clipsToBounds = true
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
        
        ReasonNode.attributedText = NSAttributedString(string: self.charge.reason, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: FontSize + 1), NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.paragraphStyle: paragraphStyles])
        
        statusNode.attributedText = NSAttributedString(string: self.charge.type, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: FontSize + 1), NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.paragraphStyle: paragraphStyles])
        
        let date = self.charge.action_made_time.dateValue()
        timeNode.attributedText = NSAttributedString(string: "\(timeAgoSinceDate(date, numericDates: true))", attributes: timeAttributes)
        
        loadImgVideo()
        
        
    }
    
    func loadImgVideo() {
        
        DataService.instance.mainFireStoreRef.collection("Users").whereField("userUID", isEqualTo: self.charge.charged_userUID!).getDocuments { [self] querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            
            if !snapshot.isEmpty {
                
                for item in snapshot.documents {
                    
                    if let avatarUrl = item["avatarUrl"] as? String {
                        
                        userImageNode.contentMode = .scaleAspectFill
                        userImageNode.shouldRenderProgressImages = true
                        userImageNode.animatedImagePaused = false
                        userImageNode.url = URL.init(string: avatarUrl)
                        
                    }
                    
                    
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
        
        
        userImageNode.style.preferredSize = CGSize(width: OrganizerImageSize, height: OrganizerImageSize)
       
        
        headerSubStack.style.flexShrink = 16.0
        headerSubStack.style.flexGrow = 16.0
        headerSubStack.spacing = 7.0
        
        headerSubStack.children = [horizontalStack, ReasonNode]
      
  
        let headerStack = ASStackLayoutSpec.horizontal()
      
        
        headerStack.spacing = 10
        headerStack.justifyContent = ASStackLayoutJustifyContent.start
        headerStack.alignItems = .center
        headerStack.children = [userImageNode, headerSubStack]
        
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 16.0, left: 16, bottom: 16, right: 16), child: headerStack)
            
    }
    
    
}
