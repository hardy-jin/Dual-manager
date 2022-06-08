//
//  MainAPIClient.swift
//  uEAT
//
//  Created by Khoi Nguyen on 10/29/19.
//  Copyright © 2019 Khoi Nguyen. All rights reserved.
//

import Foundation
import Alamofire


class MainAPIClient: NSObject {
    
    static let shared = MainAPIClient()
    
    var baseURLString:String? = nil
    var baseURL: URL {
        
        if let urlString = self.baseURLString, let url = URL(string: urlString) {
            
            return url
        } else {
            
            fatalError()
            
        }
        
    }
    
}

