//
//  CustomLabel.swift
//  uEAT
//
//  Created by Khoi Nguyen on 10/23/19.
//  Copyright © 2019 Khoi Nguyen. All rights reserved.
//

import UIKit

class CustomLabel: UILabel {

    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        
        
        layer.cornerRadius = self.frame.height / 15
        clipsToBounds = true
        
        
        
    }

}

extension UILabel {

    func roundTop(radius:CGFloat = 5){
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        if #available(iOS 11.0, *) {
            self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        } else {
            // Fallback on earlier versions
        }
    }

    func roundBottom(radius:CGFloat = 5){
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        if #available(iOS 11.0, *) {
            self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        } else {
            // Fallback on earlier versions
        }
    }
}

