//
//  modifiedChooseCarView.swift
//  Campus Connect
//
//  Created by Khoi Nguyen on 3/27/18.
//  Copyright © 2018 Campus Connect LLC. All rights reserved.
//

import UIKit

class modifiedChooseCarView: UIView {

    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        
        
        layer.cornerRadius = self.frame.height / 10
        clipsToBounds = true
        
        
        
    }

}
