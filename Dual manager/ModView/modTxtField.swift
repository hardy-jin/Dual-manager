//
//  modTxtField.swift
//  Campus Connect
//
//  Created by Khoi Nguyen on 4/2/18.
//  Copyright © 2018 Campus Connect LLC. All rights reserved.
//

import UIKit

class modTxtField: UITextField {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        borderStyle = .none
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.groupTableViewBackground.cgColor
        border.frame = CGRect(x: 0, y: frame.size.height - width, width:  frame.size.width + 30, height: frame.size.height)
        
        border.borderWidth = width
        layer.addSublayer(border)
        layer.masksToBounds = true
        
    }

}
