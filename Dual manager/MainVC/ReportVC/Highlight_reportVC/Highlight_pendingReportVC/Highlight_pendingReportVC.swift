//
//  Highlight_pendingReportVC.swift
//  Dual manager
//
//  Created by Khoi Nguyen on 10/24/21.
//

import UIKit
import SwiftPublicIP
import Firebase
import Alamofire
import AsyncDisplayKit
import SendBirdUIKit

class Highlight_pendingReportVC: UIViewController {
    
    var tableNode: ASTableNode!
    var highlight_report_List = [ReportModel]()
    lazy var delayItem = workItem()
    var lastDocumentSnapshot: DocumentSnapshot!
    var query: Query!
    
    var selected_report: ReportModel!
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        self.tableNode = ASTableNode(style: .plain)
        self.wireDelegates()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(tableNode.view)
        self.applyStyle()
        self.tableNode.leadingScreensForBatching = 5
        self.tableNode.automaticallyRelayoutOnLayoutMarginsChanges = true
        self.tableNode.automaticallyAdjustsContentOffset = true
        
        
        self.delayItem.perform(after: 2.0) {

            self.trackingPendingVideo()
          
        }
    }
    
    
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        self.tableNode.frame = view.bounds

    }
    
    func applyStyle() {
        
        self.tableNode.view.separatorStyle = .none
        self.tableNode.view.separatorColor = UIColor.lightGray
        self.tableNode.view.isPagingEnabled = false
        self.tableNode.view.backgroundColor = UIColor.white
        self.tableNode.view.showsVerticalScrollIndicator = false
        
    }
    
    func wireDelegates() {
        
        self.tableNode.delegate = self
        self.tableNode.dataSource = self
        
    }
    
    func trackingPendingVideo() {
        
        let db = DataService.instance.mainFireStoreRef
        
        pendingvideoListen = db.collection("video_report")
            .addSnapshotListener { [self] querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    print("Error fetching snapshots: \(error!)")
                    return
                }


                snapshot.documentChanges.forEach { diff in
                    
                    let newItem = ReportModel(postKey: diff.document.documentID, report_model: diff.document.data())
                    
    
                    if (diff.type == .modified) {
                       
                        if newItem.status == "Pending" {
                                         
                            if findDataInList(item: newItem, list: highlight_report_List) == false {
                                
                                self.highlight_report_List.insert(newItem, at: 0)
                                print( self.highlight_report_List.count)
                                self.tableNode.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                                
                                               
                                
                            } else {
                                
                                
                                let index = findIndexInList(item: newItem, list: highlight_report_List)
                                self.highlight_report_List[index] = newItem
                                self.tableNode.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                                
                            }
                            
                        // add new item processing goes here
                        } else if newItem.status == "Processing" {
                            
                            if findDataInList(item: newItem, list: highlight_report_List) == true {
                                
                                
                                
                                
                                let index = findIndexInList(item: newItem, list: highlight_report_List)
                                
                                print(index)
                                
                                self.highlight_report_List[index] = newItem
                                self.tableNode.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                                               
                                
                            }
                            
                        } else if newItem.status == "Completed" {
                            
                          
                            if findDataInList(item: newItem, list: highlight_report_List) == true {
                                
                                let index = findIndexInList(item: newItem, list: highlight_report_List)
                                if !highlight_report_List.isEmpty {
                                    self.highlight_report_List.remove(at: index)
                                    self.tableNode.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                                }
                                
                            }
                            
                            
                            
                            
                        }
                        
                    } else if (diff.type == .added) {
                        
                        if newItem.status == "Pending" {
                                         
                            if findDataInList(item: newItem, list: highlight_report_List) == false {
                                
                                self.highlight_report_List.insert(newItem, at: 0)
                                self.tableNode.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                                               
                                
                            } else {
                                
                                
                                let index = findIndexInList(item: newItem, list: highlight_report_List)
                                self.highlight_report_List[index] = newItem
                                self.tableNode.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                                
                            }
                            
                        // add new item processing goes here
                        } else if newItem.status == "Processing" {
                            
                            if findDataInList(item: newItem, list: highlight_report_List) == true {
                                
                                let index = findIndexInList(item: newItem, list: highlight_report_List)
                                self.highlight_report_List[index] = newItem
                                self.tableNode.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                                               
                                
                            }
                            
                        } else if newItem.status == "Completed" {
                            
                          
                            if findDataInList(item: newItem, list: highlight_report_List) == true {
                                
                                let index = findIndexInList(item: newItem, list: highlight_report_List)
                                if !highlight_report_List.isEmpty {
                                    self.highlight_report_List.remove(at: index)
                                    self.tableNode.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                                }
                                
                            }
                            
                        }
                        
                    }
                  
                }
            }
        
   
    }
    
    // func show error alert
    
    func showErrorAlert(_ title: String, msg: String) {
                                                                    
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
                                                                                       
        present(alert, animated: true, completion: nil)
        
    }

  
}




extension Highlight_pendingReportVC: ASTableDataSource {
    
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        
        selected_report = highlight_report_List[indexPath.row]
        
        if selected_report.status == "Pending" {
            
            DataService.instance.mainFireStoreRef.collection("video_report").document(selected_report.reportID).updateData(["status": "Processing", "Processing_time": FieldValue.serverTimestamp()])
            self.performSegue(withIdentifier: "moveToHighlightReportProcessingVC", sender: nil)
            
        } else {
            
            self.showErrorAlert("Oops!", msg: "This case may be processing by another staff.")
            
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "moveToHighlightReportProcessingVC"{
            if let destination = segue.destination as? Highlight_report_processingVC
            {
                
                destination.selected_report = self.selected_report
                  
            }
        }
        
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        
        
        if self.highlight_report_List.count == 0 {
            
            tableNode.view.setEmptyMessage("No pending reports")
            
        } else {
            tableNode.view.restore()
        }
        
        return self.highlight_report_List.count
        
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        
        let report = self.highlight_report_List[indexPath.row]
        
        return {
            
            let node = VideoReportNode(with: report)
            node.neverShowPlaceholders = true
            node.debugName = "Node \(indexPath.row)"
            
            return node
        }
        
    }
    

        
}

extension Highlight_pendingReportVC: ASTableDelegate {
    
    func tableNode(_ tableNode: ASTableNode, constrainedSizeForRowAt indexPath: IndexPath) -> ASSizeRange {
        
        let width = UIScreen.main.bounds.size.width;
        
        let min = CGSize(width: width, height: 30);
        let max = CGSize(width: width, height: 1000);
        return ASSizeRangeMake(min, max);
           
    }
    
    
    func shouldBatchFetch(for tableNode: ASTableNode) -> Bool {
        
        return true
        
    }
    
    func tableNode(_ tableNode: ASTableNode, willBeginBatchFetchWith context: ASBatchContext) {
        
        self.retrieveNextPageWithCompletion { (newReports) in
            
            self.insertNewRowsInTableNode(newReports: newReports)
            
            context.completeBatchFetching(true)
            
        }
        
    }
    
}


extension Highlight_pendingReportVC {
    
    func retrieveNextPageWithCompletion( block: @escaping ([DocumentSnapshot]) -> Void) {
        
        let db = DataService.instance.mainFireStoreRef
            
            if lastDocumentSnapshot == nil {
                
                query = db.collection("video_report").whereField("status", isEqualTo: "Pending").order(by: "timeStamp", descending: true).limit(to: 10)
                
                
            } else {
                
                query = db.collection("video_report").whereField("status", isEqualTo: "Pending").order(by: "timeStamp", descending: true).limit(to: 10).start(afterDocument: lastDocumentSnapshot)
            }
            
            query.getDocuments { [self] (snap, err) in
                
                if err != nil {
                    
                    print(err!.localizedDescription)
                    return
                }
                    
                if snap?.isEmpty != true {
                    
                    print("Successfully retrieved \(snap!.count) reports.")
                    let items = snap?.documents
                    self.lastDocumentSnapshot = snap!.documents.last
                    DispatchQueue.main.async {
                        block(items!)
                    }
                    
                } else {
                    
                    let items = snap?.documents
                    DispatchQueue.main.async {
                        block(items!)
                    }
                  
                    
                }
                
                
            }
                
    }
    
    
    
    func insertNewRowsInTableNode(newReports: [DocumentSnapshot]) {
        
        guard newReports.count > 0 else {
            return
        }
        
        var checkNewReports = [DocumentSnapshot]()
        
        for item in newReports {
            
            let i = ReportModel(postKey: item.documentID, report_model: item.data()!)
            if findDataInList(item: i, list: highlight_report_List) == false {
                checkNewReports.append(item)
            }
            
        }
        
        guard checkNewReports.count > 0 else {
            return
        }
        
        let section = 0
        var items = [ReportModel]()
        var indexPaths: [IndexPath] = []
        let total = self.highlight_report_List.count + checkNewReports.count
        
        for row in self.highlight_report_List.count...total-1 {
            let path = IndexPath(row: row, section: section)
            indexPaths.append(path)
        }
        
        for i in checkNewReports {
            
               
            let item = ReportModel(postKey: i.documentID, report_model: i.data()!)
            items.append(item)
          
        }
        
    
        self.highlight_report_List.append(contentsOf: items)
        self.tableNode.insertRows(at: indexPaths, with: .none)
        
    }
    
    
}
