//
//  ChargeModel.swift
//  Dual manager
//
//  Created by Khoi Nguyen on 10/27/21.
//

import Foundation
import Firebase

class ChargeModel {
    
    fileprivate var _suspend_time: String!
    fileprivate var _action: String!
    fileprivate var _staffID: String!
    fileprivate var _reason: String!
    fileprivate var _addition_comment: String!
    fileprivate var _charged_userUID: String!
    fileprivate var _type: String!
    fileprivate var _reportID: String!
    fileprivate var _action_made_time: Timestamp!
    fileprivate var _report_time: Timestamp!
    
    var suspend_time: String! {
        get {
            if _suspend_time == nil {
                _suspend_time = ""
            }
            return _suspend_time
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
    
    var action: String! {
        get {
            if _action == nil {
                _action = ""
            }
            return _action
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
    
    var addition_comment: String! {
        get {
            if _addition_comment == nil {
                _addition_comment = ""
            }
            return _addition_comment
        }
        
    }
    
    var charged_userUID: String! {
        get {
            if _charged_userUID == nil {
                _charged_userUID = ""
            }
            return _charged_userUID
        }
        
    }
    
    var type: String! {
        get {
            if _type == nil {
                _type = ""
            }
            return _type
        }
        
    }
    
    var action_made_time: Timestamp! {
        get {
            if _action_made_time == nil {
                _action_made_time = nil
            }
            return _action_made_time
        }
    }
    
    var report_time: Timestamp! {
        get {
            if _report_time == nil {
                _report_time = nil
            }
            return _report_time
        }
    }
    
    
    init(postKey: String, charge_model: Dictionary<String, Any>) {
        
        if let suspend_time = charge_model["suspend_time"] as? String {
            self._suspend_time = suspend_time
            
        }
        
        if let action = charge_model["action"] as? String {
            self._action = action
            
        }
        
        if let staffID = charge_model["staffID"] as? String {
            self._staffID = staffID
            
        }
        
        if let reason = charge_model["reason"] as? String {
            self._reason = reason
            
        }
        
        if let addition_comment = charge_model["addition_comment"] as? String {
            self._addition_comment = addition_comment
            
        }
        
        if let charged_userUID = charge_model["charged_userUID"] as? String {
            self._charged_userUID = charged_userUID
            
        }
        
        if let type = charge_model["type"] as? String {
            self._type = type
            
        }
        
        if let reportID = charge_model["reportID"] as? String {
            self._reportID = reportID
            
        }
        
        if let action_made_time = charge_model["action_made_time"] as? Timestamp {
            self._action_made_time = action_made_time
            
        }
        
        if let report_time = charge_model["report_time"] as? Timestamp {
            self._report_time = report_time
            
        }
        
    }
    
}
