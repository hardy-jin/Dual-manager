//
//  UserHighlightFeedVC.swift
//  Dual manager
//
//  Created by Khoi Nguyen on 10/26/21.
//

import UIKit
import AsyncDisplayKit
import AlamofireImage
import Firebase
import SwiftPublicIP
import Alamofire
import SwiftyJSON

class UserHighlightFeedVC: UIViewController, UIAdaptivePresentationControllerDelegate, UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    lazy var delayItem = workItem()
    //
    
    @IBOutlet weak var bView: UIView!
    
    var startIndex: Int!
    var currentIndex = 0
  
    var previousIndex = 0
    var tableNode: ASTableNode!
    var posts = [HighlightsModel]()
    var item_id_list = [String]()
    var video_list = [HighlightsModel]()
    var index = 0
    
    var currentItem: HighlightsModel!
    
    var selectedItem: HighlightsModel!
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        self.tableNode = ASTableNode(style: .plain)
        self.wireDelegates()
  
    }



    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        bView.addSubview(tableNode.view)
        self.applyStyle()
      
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .microseconds(10000)) {
            
            self.loadHighlight()
            
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.view.endEditing(true)
        
    }
    
    func wireDelegates() {
        
        self.tableNode.delegate = self
        self.tableNode.dataSource = self
        
    }
    
    func findIndexFromPost(item: HighlightsModel) -> Int {
        
        var count = 0
        
        for i in posts {
            
            if item.Mux_playbackID == i.Mux_playbackID, item.highlight_id == i.highlight_id, item.userUID == i.userUID {
            
               return count
                
            }
            
            count += 1
        }
        
        return -1
        
    }
    
    func openLink(item: HighlightsModel) {
        
        if let link = item.stream_link, link != "nil", link != ""
        {
            guard let requestUrl = URL(string: link) else {
                return
            }

            if UIApplication.shared.canOpenURL(requestUrl) {
                 UIApplication.shared.open(requestUrl, options: [:], completionHandler: nil)
            }
            
        }

    }
    
    func applyStyle() {
        
        self.tableNode.view.separatorStyle = .none
        self.tableNode.view.isPagingEnabled = true
        self.tableNode.view.backgroundColor = UIColor.clear
        self.tableNode.view.showsVerticalScrollIndicator = false
        self.tableNode.allowsSelection = false
        
        
    }
    
    func showErrorAlert(_ title: String, msg: String) {
                                                                                                                                           
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
                                                                                       
        present(alert, animated: true, completion: nil)
        
    }
    
    func swiftLoader() {
        
        var config : SwiftLoader.Config = SwiftLoader.Config()
        config.size = 170
        
        config.backgroundColor = UIColor.clear
        config.spinnerColor = UIColor.white
        config.titleTextColor = UIColor.white
        
        
        config.spinnerLineWidth = 3.0
        config.foregroundColor = UIColor.black
        config.foregroundAlpha = 0.7
        
        
        SwiftLoader.setConfig(config: config)
        
        
        SwiftLoader.show(title: "", animated: true)
        
                                                                                                                                      
        
    }
    
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        self.tableNode.frame = bView.bounds
        //loadHighlight()
        
    }
    
    func loadHighlight() {

        guard video_list.count > 0 else {
            return
        }
        
        let section = 0
        var items = [HighlightsModel]()
        var indexPaths: [IndexPath] = []
        let total = self.posts.count + video_list.count
        
        for row in self.posts.count...total-1 {
            let path = IndexPath(row: row, section: section)
            indexPaths.append(path)
        }
        
        for item in video_list {
            
            items.append(item)
          
        }
        
        self.posts.append(contentsOf: items)
        self.tableNode.reloadData()
        //self.tableNode.insertRows(at: indexPaths, with: .automatic)
        
        
        guard startIndex != nil else {
            return
        }
        
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .microseconds(2000)) {
            
            self.tableNode.scrollToRow(at: IndexPath(row: self.startIndex, section: section), at: .none, animated: false)
              
        }
        
        
    }
    
    @IBAction func back2BtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func back1BtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    


}

extension UserHighlightFeedVC: ASTableDelegate {
    
    func tableNode(_ tableNode: ASTableNode, constrainedSizeForRowAt indexPath: IndexPath) -> ASSizeRange {
        
        
        let width = UIScreen.main.bounds.size.width;
        let min = CGSize(width: width, height: self.bView.layer.frame.height);
        let max = CGSize(width: width, height: self.bView.layer.frame.height);
        
        return ASSizeRangeMake(min, max);
    }
    
    func shouldBatchFetch(for tableNode: ASTableNode) -> Bool {
        
        return false
        
    }
    
}

extension UserHighlightFeedVC: ASTableDataSource {
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
    
        return self.posts.count
        
        
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        
        let post = self.posts[indexPath.row]
           
        return {
            let node = PostNode(with: post)
            node.neverShowPlaceholders = true
            node.debugName = "Node \(indexPath.row)"
            
        
            
            node.linkBtn = { (node) in
                
                self.openLink(item: post)
                
            }
            
            return node
        }
        
   
            
    }


    func tableNode(_ tableNode: ASTableNode, willDisplayRowWith node: ASCellNode) {
        
        guard let cell = node as? PostNode else { return }
        
        currentIndex = cell.indexPath!.row
        
        print("Showing at \(cell.indexPath!.row)")
        
      
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .microseconds(1000)) {
            
            if cell.DetailViews != nil {
                
                if cell.animatedLabel != nil {
                    
                    cell.animatedLabel.restartLabel()
                    
                }
                
                
                if cell.DetailViews.hashTagCollectionHeight.constant != 0.0 {
                    
                    cell.setCollectionViewDataSourceDelegate(self, forRow: cell.indexPath!.row)
                    
                    
                } else {
                    
                    print("Empty hashtag")
                    
                }
                

                

            }
            
            
        }
        

        
    }
    
    func tableNode(_ tableNode: ASTableNode, didEndDisplayingRowWith node: ASCellNode) {
    
        
        guard let cell = node as? PostNode else { return }
        
        
    }
    
    //
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts[collectionView.tag].hashtag_list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: HashtagCell.cellReuseIdentifier(), for: indexPath)) as! HashtagCell
        let item = posts[collectionView.tag]
        
        //cell.backgroundColor = UIColor.red
        cell.hashTagLabel.text = item.hashtag_list[indexPath.row]
        
        return cell
    }

    
}

extension UserHighlightFeedVC {
    
    
    func insertNewRowsInTableNode(newPosts: [DocumentSnapshot]) {
        
        guard newPosts.count > 0 else {
            return
        }
        
        let section = 0
        var items = [HighlightsModel]()
        var indexPaths: [IndexPath] = []
        let total = self.posts.count + newPosts.count
        
        for row in self.posts.count...total-1 {
            let path = IndexPath(row: row, section: section)
            indexPaths.append(path)
        }
        
        for i in newPosts {
            
            let item = HighlightsModel(postKey: i.documentID, Highlight_model: i.data()!)
            items.append(item)
          
        }
        
    
        self.posts.append(contentsOf: items)
        self.tableNode.insertRows(at: indexPaths, with: .none)
        
        
    }
    
   
    
    
}
