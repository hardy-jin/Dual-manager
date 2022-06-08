//
//  PhoneBookModel.swift
//  Dual
//
//  Created by Khoi Nguyen on 10/27/20.
//

import Foundation

class PhoneBookModel {
    
    fileprivate var _country: String!
    fileprivate var _code: String!
    

    var country: String! {
        get {
            if _country == nil {
                _country = ""
            }
            return _country
        }
        
    }
    
    var code: String! {
        get {
            if _code == nil {
                _code = ""
            }
            return _code
        }
        
    }
    

    init(postKey: String, phone_model: Dictionary<String, Any>) {
        
        if let country = phone_model["country"] as? String {
            self._country = country
            
        }
        
        if let code = phone_model["code"] as? String {
            self._code = code
            
        }
    
    }
    
}
