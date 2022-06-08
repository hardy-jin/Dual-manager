//
//  fancyBtn.swift
//  Campus Connect
//
//  Created by Khoi Nguyen on 3/21/18.
//  Copyright © 2018 Campus Connect LLC. All rights reserved.
//

import UIKit

class fancyBtn: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        layer.masksToBounds = false
        layer.shadowRadius = 1.0
        layer.shadowOpacity = 0.5
        layer.cornerRadius = frame.width / 2
        
        
        
        
    }
    
    

}


