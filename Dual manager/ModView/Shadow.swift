//
//  Shadow.swift
//  Dual
//
//  Created by Khoi Nguyen on 11/19/20.
//

import UIKit

class Shadow: UIView {
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        
    }
    
    override func layoutSubviews() {
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = .zero
        layer.shadowRadius = 20
        
    }

    

}
