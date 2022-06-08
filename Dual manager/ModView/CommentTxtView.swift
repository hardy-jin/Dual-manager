//
//  CommentTxtView.swift
//  Campus Connect
//
//  Created by Khoi Nguyen on 4/4/18.
//  Copyright © 2018 Campus Connect LLC. All rights reserved.
//

import UIKit

class CommentTxtView: UITextView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        layer.borderColor = UIColor.groupTableViewBackground.cgColor 
        layer.borderWidth = 1.0
        layer.cornerRadius = self.frame.width / 35
        
        
        
    }

}
