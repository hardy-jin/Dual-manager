//
//  ReportModel.swift
//  Dual manager
//
//  Created by Khoi Nguyen on 10/25/21.
//

import Foundation
import Firebase

class ReportModel {
    //let actionMade = ["action_made_time": FieldValue.serverTimestamp(), "action": action, "staffID": Auth.auth().currentUser!.uid, "addition_comment": "nil", "status": "Completed"] as [String : Any]
    
    
    fileprivate var _suspend_time: String!
    fileprivate var _addition_comment: String!
    fileprivate var _action: String!
    fileprivate var _userUID: String!
    fileprivate var _staffID: String!
    fileprivate var _reason: String!
    fileprivate var _description: String!
    fileprivate var _status: String!
    fileprivate var _reportID: String!
    fileprivate var _timeStamp: Timestamp!
    fileprivate var _action_made_time: Timestamp!
    
    fileprivate var _reported_userUID: String!
    fileprivate var _highlight_id: String!
    fileprivate var _comment_id: String!
    fileprivate var _challenge_id: String!
    
    
    var action_made_time: Timestamp! {
        get {
            if _action_made_time == nil {
                _action_made_time = nil
            }
            return _action_made_time
        }
    }
    
    var suspend_time: String! {
        get {
            if _suspend_time == nil {
                _suspend_time = ""
            }
            return _suspend_time
        }
        
    }
    
    var action: String! {
        get {
            if _action == nil {
                _action = ""
            }
            return _action
        }
        
    }
    
    var addition_comment: String! {
        get {
            if _addition_comment == nil {
                _addition_comment = ""
            }
            return _addition_comment
        }
        
    }
    
    var reported_userUID: String! {
        get {
            if _reported_userUID == nil {
                _reported_userUID = ""
            }
            return _reported_userUID
        }
        
    }
    
    var highlight_id: String! {
        get {
            if _highlight_id == nil {
                _highlight_id = ""
            }
            return _highlight_id
        }
        
    }
    
    var comment_id: String! {
        get {
            if _comment_id == nil {
                _comment_id = ""
            }
            return _comment_id
        }
        
    }
    
    var challenge_id: String! {
        get {
            if _challenge_id == nil {
                _challenge_id = ""
            }
            return _challenge_id
        }
        
    }

    var userUID: String! {
        get {
            if _userUID == nil {
                _userUID = ""
            }
            return _userUID
        }
        
    }
    
    var staffID: String! {
        get {
            if _staffID == nil {
                _staffID = ""
            }
            return _staffID
        }
        
    }
    
    var reason: String! {
        get {
            if _reason == nil {
                _reason = ""
            }
            return _reason
        }
        
    }
    
    var description: String! {
        get {
            if _description == nil {
                _description = ""
            }
            return _description
        }
        
    }
    
    var status: String! {
        get {
            if _status == nil {
                _status = ""
            }
            return _status
        }
        
    }
    
    var reportID: String! {
        get {
            if _reportID == nil {
                _reportID = ""
            }
            return _reportID
        }
        
    }
    
    
    var timeStamp: Timestamp! {
        get {
            if _timeStamp == nil {
                _timeStamp = nil
            }
            return _timeStamp
        }
    }
 
    

    init(postKey: String, report_model: Dictionary<String, Any>) {
        
        
        self._reportID = postKey
        
        if let suspend_time = report_model["suspend_time"] as? String {
            self._suspend_time = suspend_time
            
        }
        
        if let userUID = report_model["userUID"] as? String {
            self._userUID = userUID
            
        }
        
        if let staffID = report_model["staffID"] as? String {
            self._staffID = staffID
            
        }
        
        if let reason = report_model["reason"] as? String {
            self._reason = reason
            
        }
        
        if let description = report_model["description"] as? String {
            self._description = description
            
        }
        
        if let status = report_model["status"] as? String {
            self._status = status
            
        }
        
        if let action = report_model["action"] as? String {
            self._action = action
            
        }
    
    
        if let timeStamp = report_model["timeStamp"] as? Timestamp {
            self._timeStamp = timeStamp
            
        }
        
        if let action_made_time = report_model["action_made_time"] as? Timestamp {
            self._action_made_time = action_made_time
            
        }
        
        if let reported_userUID = report_model["reported_userUID"] as? String {
            self._reported_userUID = reported_userUID
            
        }
        if let highlight_id = report_model["highlight_id"] as? String {
            self._highlight_id = highlight_id
            
        }
        
        if let comment_id = report_model["comment_id"] as? String {
            self._comment_id = comment_id
            
        }
        
        if let challenge_id = report_model["challenge_id"] as? String {
            self._challenge_id = challenge_id
            
        }
        
       
    
    }
    

    
}
