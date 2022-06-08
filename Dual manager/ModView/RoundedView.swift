//
//  windowInfo.swift
//  Campus Connect
//
//  Created by Khoi Nguyen on 3/29/18.
//  Copyright © 2018 Campus Connect LLC. All rights reserved.
//

import UIKit

class RoundedView: UIView {

    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
       
        
        layer.cornerRadius = 25
        clipsToBounds = true
        
        
        
    }

}



