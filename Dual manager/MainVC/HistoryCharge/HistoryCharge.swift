//
//  HistoryCharge.swift
//  Dual manager
//
//  Created by Khoi Nguyen on 10/27/21.
//

import UIKit
import SwiftPublicIP
import Firebase
import Alamofire
import AsyncDisplayKit
import SendBirdUIKit

class HistoryCharge: UIViewController {

    @IBOutlet weak var bView: UIView!
    
    var tableNode: ASTableNode!
    var charge_List = [ChargeModel]()
    lazy var delayItem = workItem()
    var lastDocumentSnapshot: DocumentSnapshot!
    var query: Query!
    
    var selected_charged: ChargeModel!
    var selected_reported: ReportModel!
    
    var charge_userUID: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.tableNode = ASTableNode(style: .plain)
        self.wireDelegates()
        // Do any additional setup after loading the view.
        bView.addSubview(tableNode.view)
        self.applyStyle()
        self.tableNode.leadingScreensForBatching = 5
        self.tableNode.automaticallyRelayoutOnLayoutMarginsChanges = true
        self.tableNode.automaticallyAdjustsContentOffset = true
        
    }
    
    
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        self.tableNode.frame = bView.bounds

    }
    
    func applyStyle() {
        
        self.tableNode.view.separatorStyle = .none
        self.tableNode.view.separatorColor = UIColor.lightGray
        self.tableNode.view.isPagingEnabled = false
        self.tableNode.view.backgroundColor = UIColor.clear
        self.tableNode.view.showsVerticalScrollIndicator = false
        
    }
    
    func wireDelegates() {
        
        self.tableNode.delegate = self
        self.tableNode.dataSource = self
        
    }
    
    // func show error alert
    
    func showErrorAlert(_ title: String, msg: String) {
                                                                    
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
                                                                                       
        present(alert, animated: true, completion: nil)
        
    }

    
     

}

extension HistoryCharge: ASTableDataSource {
    
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        
        let item = charge_List[indexPath.row]
        
        if item.type == "video_report" {
            getReportAndSegue(reportID: item.reportID)
            print()
        }
    
    }
    
    func getReportAndSegue(reportID: String) {
        
        DataService.instance.mainFireStoreRef.collection("video_report").document(reportID).getDocument { snap, err in
            if err != nil {
                
                self.showErrorAlert("Oops", msg: err!.localizedDescription)
                
            } else {
                
                
                let item = ReportModel(postKey: snap!.documentID, report_model: snap!.data()!)
                if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Highlight_report_processingVC") as? Highlight_report_processingVC {
                    
                    viewController.modalPresentationStyle = .fullScreen
                    viewController.selected_report = item
                    self.present(viewController, animated: true, completion: nil)
                    
                }
                
            }
        }
        
    }
    
    
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        
        
        if self.charge_List.count == 0 {
            
            tableNode.view.setEmptyMessage("No charge")
            
        } else {
            tableNode.view.restore()
        }
        
        return self.charge_List.count
        
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        
        let charge = self.charge_List[indexPath.row]
        
        return {
            
            let node = ChargeNode(with: charge)
            node.neverShowPlaceholders = true
            node.debugName = "Node \(indexPath.row)"
            
            return node
        }
        
    }
    

        
}

extension HistoryCharge: ASTableDelegate {
    
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


extension HistoryCharge {
    
    func retrieveNextPageWithCompletion( block: @escaping ([DocumentSnapshot]) -> Void) {
        
        let db = DataService.instance.mainFireStoreRef
        
            if lastDocumentSnapshot == nil {
                
                query = db.collection("history_charge").whereField("charged_userUID", isEqualTo: charge_userUID!).order(by: "action_made_time", descending: true).limit(to: 10)
                
                
            } else {
                
                query = db.collection("history_charge").whereField("charged_userUID", isEqualTo: charge_userUID!).order(by: "action_made_time", descending: true).limit(to: 10).start(afterDocument: lastDocumentSnapshot)
            }
            
            query.getDocuments { [self] (snap, err) in
                
                if err != nil {
                    
                    print(err!.localizedDescription)
                    return
                }
                    
                if snap?.isEmpty != true {
                    
                    print("Successfully retrieved \(snap!.count) charges.")
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
        
        
        let section = 0
        var items = [ChargeModel]()
        var indexPaths: [IndexPath] = []
        let total = self.charge_List.count + newReports.count
        
        for row in self.charge_List.count...total-1 {
            let path = IndexPath(row: row, section: section)
            indexPaths.append(path)
        }
        
        for i in newReports {
            
            let item = ChargeModel(postKey: i.documentID, charge_model: i.data()!)
            items.append(item)
          
        }
        
    
        self.charge_List.append(contentsOf: items)
        self.tableNode.insertRows(at: indexPaths, with: .none)
        
    }
    
    
}
