//
//  defaultCardView.swift
//  Campus Connect
//
//  Created by Khoi Nguyen on 3/26/18.
//  Copyright © 2018 Campus Connect LLC. All rights reserved.
//

import UIKit

class loginCardView: UIView {
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
    
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.5
        
        layer.cornerRadius = self.frame.height / 10
        clipsToBounds = true
 
 
    }
    
    

}
