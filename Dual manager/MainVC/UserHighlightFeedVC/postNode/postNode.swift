//
//  postNode.swift
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
import ActiveLabel
import SendBirdSDK
import AlamofireImage


class PostNode: ASCellNode {
    
    
    var animatedLabel: MarqueeLabel!
    
    var post: HighlightsModel
    var backgroundImageNode: ASNetworkImageNode
    var videoNode: ASVideoNode
    var region: String!
    var DetailViews: DetailView!
   
    
    
    var soundBtn: ASButtonNode!
    var infoView: ASDisplayNode!
    var buttonListView: ASDisplayNode!
    
    
    // btn
    
    var shareBtn : ((ASCellNode) -> Void)?
    
    var challengeBtn : ((ASCellNode) -> Void)?
    var linkBtn : ((ASCellNode) -> Void)?
    var profileBtn : ((ASCellNode) -> Void)?
    var viewBtn : ((ASCellNode) -> Void)?
    var commentBtn : ((ASCellNode) -> Void)?
     
    //
    
    init(with post: HighlightsModel) {
        
        self.post = post
        self.backgroundImageNode = ASNetworkImageNode()
        self.videoNode = ASVideoNode()
        self.infoView = ASDisplayNode()
        self.soundBtn = ASButtonNode()
        self.buttonListView = ASDisplayNode()
       
        super.init()
        
        
        DispatchQueue.main.async() { [self] in
            DetailViews = DetailView()
        }
        
        automaticallyManagesSubnodes = true
       
        
        self.backgroundImageNode.url = self.getThumbnailURL(post: post)
        
        self.backgroundImageNode.contentMode = .scaleAspectFill
        self.videoNode.url = self.getThumbnailURL(post: post)
        self.videoNode.backgroundColor =  UIColor.clear//UIColor(red: 17, green: 17, blue: 17)
        self.backgroundColor = UIColor.clear
        self.infoView.backgroundColor = UIColor(red: 6, green: 13, blue: 18)
        //self.infoView.backgroundColor = UIColor.clear
       
        self.videoNode.gravity = AVLayerVideoGravity.resizeAspect.rawValue
        
        
        DispatchQueue.main.async() { [self] in
            
            
            // constraint DetailViews to asdisplaynode
            
            
            self.DetailViews.backgroundColor = UIColor.clear
            self.view.backgroundColor = UIColor.clear//UIColor(red: 6, green: 13, blue: 18)
           
            self.infoView.view.addSubview(DetailViews)
            
            //
            
            
            DetailViews.translatesAutoresizingMaskIntoConstraints = false
            DetailViews.topAnchor.constraint(equalTo: self.infoView.view.topAnchor, constant: 0).isActive = true
            DetailViews.bottomAnchor.constraint(equalTo: self.infoView.view.bottomAnchor, constant: 0).isActive = true
            DetailViews.leadingAnchor.constraint(equalTo: self.infoView.view.leadingAnchor, constant: 0).isActive = true
            DetailViews.trailingAnchor.constraint(equalTo: self.infoView.view.trailingAnchor, constant: 0).isActive = true
            
            
           
            
            DetailViews.collectionView.backgroundColor = UIColor.clear
            // construct hashTagCollectionHeight depends on hashtag list
            
            if self.post.hashtag_list.isEmpty {
                
                DetailViews.hashTagCollectionHeight.constant = 0.0
                
            } else {
                
                DetailViews.hashTagCollectionHeight.constant = 35.0
                
            }
                     
                  
        }
        
    
        
        
        DispatchQueue.main.async() { [self] in
            
            
            
            // pass asset link
            self.videoNode.asset = AVAsset(url: self.getVideoURL(post: post)!)
            
            //
            
            self.gameInfoSetting(post: post, Dview: DetailViews)
            
            // attribute
            self.videoNode.shouldAutoplay = true
            self.videoNode.shouldAutorepeat = true
            
                  
        }
        
        
        DispatchQueue.main.async() { [self] in
            
            let linkTap = UITapGestureRecognizer(target: self, action: #selector(PostNode.streamLinkBtnPressed))
            DetailViews.streamLinkLbl.isUserInteractionEnabled = true
            DetailViews.streamLinkLbl.addGestureRecognizer(linkTap)
                      
        }
        
        
       
        
    }
    
    
    @objc func streamLinkBtnPressed(sender: AnyObject!) {
  
        linkBtn?(self)
  
    
    }
    
    
    func gameInfoSetting(post: HighlightsModel, Dview: DetailView) {
        
        
        self.loadInfo(uid: post.userUID, Dview: Dview)
        
      
        self.getLogo(category: post.category, Dview: Dview)
        
        
        // date
        let date = post.post_time.dateValue()
        let time = timeAgoSinceDate(date, numericDates: true)
        


        let finalTime = NSMutableAttributedString()
        
        //
        let image1Attachment = NSTextAttachment()
        image1Attachment.image = UIImage(named: "time")!
        image1Attachment.bounds = CGRect(x: 0, y: -1, width: 12, height: 12)
        let image1String = NSAttributedString(attachment: image1Attachment)
        
        finalTime.append(image1String)
        finalTime.append(NSAttributedString(string: " \(time)"))
        
        Dview.dateLbl.attributedText = finalTime
        
        
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        
        let headerSubStack = ASStackLayoutSpec.vertical()
            
        
        if self.post.hashtag_list.isEmpty == true {
            
            
            
            videoNode.style.preferredSize = CGSize(width: constrainedSize.max.width, height: constrainedSize.max.height - 115)
            infoView.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 115)
            
            
        } else {
            
            videoNode.style.preferredSize = CGSize(width: constrainedSize.max.width, height: constrainedSize.max.height - 145)
            infoView.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 145)
            
        }
       
        headerSubStack.children = [videoNode, infoView]
        
        return headerSubStack
 
        
       
    }
        
    // function
    
    func getThumbnailURL(post: HighlightsModel) -> URL? {
        
        if let id = post.Mux_playbackID, id != "nil" {
            
            let urlString = "https://image.mux.com/\(id)/thumbnail.png?width=378&height=200&smart_crop=true"
            return URL(string: urlString)
            
        } else {
            
            return nil
            
        }
        
    }
    
    func getVideoURL(post: HighlightsModel) -> URL? {
        
        if let id = post.Mux_playbackID, id != "nil" {
            
            let urlString = "https://stream.mux.com/\(id).m3u8"
            return URL(string: urlString)
            
        } else {
            
            return nil
            
        }
        
       
    }
    
    func loadInfo(uid: String, Dview: DetailView) {
        
       
        DataService.init().mainFireStoreRef.collection("Users").whereField("userUID", isEqualTo: uid).getDocuments { [self] querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    print("Error fetching snapshots: \(error!)")
                    return
                }
            
                if snapshot.isEmpty {
                    
                    animatedLabel = MarqueeLabel.init(frame: Dview.streamLinkLbl.layer.bounds, rate: 30.0, fadeLength: 10.0)
                    //Dview.streamLinkLbl.text = "Current stream link will go here"
                    
                    
                    animatedLabel.backgroundColor = UIColor.clear
                    animatedLabel.type = .continuous
                    animatedLabel.leadingBuffer = 20.0
                    animatedLabel.trailingBuffer = 10.0
                    animatedLabel.animationDelay = 0.0
                    animatedLabel.textAlignment = .center
                    animatedLabel.font = UIFont.systemFont(ofSize: 11)
                    animatedLabel.textColor = UIColor.white
                    
                    animatedLabel.text = "https://dual.video/                               "
                    
                    Dview.streamLinkLbl.addSubview(animatedLabel)
                    
                } else {
                    
                    
                    for item in snapshot.documents {
                    
                        if let username = item.data()["username"] as? String {
                            
                            //
                            
                            Dview.usernameLbl.text = "\(username.lowercased())"
                            
                            if let avatarUrl = item["avatarUrl"] as? String {
                                
                                imageStorage.async.object(forKey: avatarUrl) { result in
                                    if case .value(let image) = result {
                                        
                                        DispatchQueue.main.async { // Make sure you're on the main thread here
                                            
                                            
                                            Dview.avatarImg.image = image
                                            
                                            //try? imageStorage.setObject(image, forKey: url)
                                            
                                        }
                                        
                                    } else {
                                        
                                        
                                     AF.request(avatarUrl).responseImage { response in
                                            
                                            
                                            switch response.result {
                                            case let .success(value):
                                                Dview.avatarImg.image = value
                                                try? imageStorage.setObject(value, forKey: avatarUrl)
                                            case let .failure(error):
                                                print(error)
                                            }
                                            
                                            
                                            
                                        }
                                        
                                    }
                                    
                                }
                                
                            
                                
                            }
                            
                            
                            
                                                      
                  
                        }
                
                    }
                    
                    self.loadStreamLink(Dview: Dview)
                    
                }
                
        }
        
    }
    
    func loadStreamLink(Dview: DetailView) {
        
        animatedLabel = MarqueeLabel.init(frame: Dview.streamLinkLbl.layer.bounds, rate: 30.0, fadeLength: 10.0)
        Dview.streamLinkLbl.addSubview(animatedLabel)
        //Dview.streamLinkLbl.text = "Current stream link will go here"
        
        
        animatedLabel.backgroundColor = UIColor.clear
        animatedLabel.type = .continuous
        animatedLabel.leadingBuffer = 20.0
        animatedLabel.trailingBuffer = 10.0
        animatedLabel.animationDelay = 0.0
        animatedLabel.textAlignment = .center
        animatedLabel.font = UIFont.systemFont(ofSize: 11)
        animatedLabel.textColor = UIColor.white
        
    

        if post.stream_link != "nil", post.stream_link != "" {

            if let text = post.stream_link {
                animatedLabel.text = "\(text)"
            } else {
                
                if post.userUID == Auth.auth().currentUser?.uid {
                    
                    animatedLabel.text = "Share your streaming link here"
                    
                } else {
                                                        
                    animatedLabel.text = "https://dual.video/                       "
                    
                }
                
            }

        } else  {
            
            if post.userUID == Auth.auth().currentUser?.uid {
                
                animatedLabel.text = "Share your streaming link here"
                
            } else {
                                                    
                animatedLabel.text = "https://dual.video/                           "
                
            }
        }
                     
        
        animatedLabel.restartLabel()
        
    }
    
    
    func getLogo(category: String, Dview: DetailView) {
        
        if Dview.gameLogo != nil {
            
            DataService.instance.mainFireStoreRef.collection("Support_game").whereField("name", isEqualTo: category).getDocuments { (snap, err) in
                
                
                if err != nil {
                    
                    print(err!.localizedDescription)
                    return
                }
                
                for item in snap!.documents {
                    
                    if let url = item.data()["url2"] as? String {
                        
                        imageStorage.async.object(forKey: url) { result in
                            if case .value(let image) = result {
                                
                                DispatchQueue.main.async { // Make sure you're on the main thread here
                                    
                                    
                                    Dview.gameLogo.image = image
                                    
                                    //try? imageStorage.setObject(image, forKey: url)
                                    
                                }
                                
                            } else {
                                
                                
                             AF.request(url).responseImage { response in
                                    
                                    
                                    switch response.result {
                                    case let .success(value):
                                        Dview.gameLogo.image = value
                                       
                                        try? imageStorage.setObject(value, forKey: url)
                                    case let .failure(error):
                                        print(error)
                                    }
                                    
                                    
                                    
                                }
                                
                            }
                            
                        }
                        
                        
                    }
                    
                    
                }
                
                
            }
            
        }
        
    }


}

extension PostNode {
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
    
    
        DetailViews.collectionView.delegate = dataSourceDelegate
        DetailViews.collectionView.dataSource = dataSourceDelegate
        DetailViews.collectionView.tag = row
        DetailViews.collectionView.setContentOffset(DetailViews.collectionView.contentOffset, animated:true) // Stops collection view if it was scrolling.
        DetailViews.collectionView.register(HashtagCell.nib(), forCellWithReuseIdentifier: HashtagCell.cellReuseIdentifier())
        DetailViews.collectionView.reloadData()
        
    }

}

