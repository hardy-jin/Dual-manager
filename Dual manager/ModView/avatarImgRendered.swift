//
//  avatarImgRendered.swift
//  Campus Connect
//
//  Created by Khoi Nguyen on 4/14/18.
//  Copyright © 2018 Campus Connect LLC. All rights reserved.
//

import UIKit

class avatarImgRendered: UIImageView {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        // add border
        
        
        
        //print(self.frame.height)
        
        layer.cornerRadius = self.frame.height / 2
        clipsToBounds = true
        layer.borderWidth = 5
        layer.borderColor = UIColor.black.cgColor
        
        
    }

}
