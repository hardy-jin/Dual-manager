//
//  borderAvatarView.swift
//  Campus Connect
//
//  Created by Khoi Nguyen on 3/27/18.
//  Copyright © 2018 Campus Connect LLC. All rights reserved.
//

import UIKit

class borderAvatarView: UIImageView {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = self.frame.height / 2
        clipsToBounds = true
        
        
    }

}
