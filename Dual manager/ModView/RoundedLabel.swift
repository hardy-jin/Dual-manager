//
//  RoundedLabel.swift
//  uEAT
//
//  Created by Khoi Nguyen on 10/21/19.
//  Copyright © 2019 Khoi Nguyen. All rights reserved.
//

import UIKit

class RoundedLabel: UILabel {

    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        
        
        layer.cornerRadius = self.frame.height / 2
        clipsToBounds = true
        
        
        
    }

}
