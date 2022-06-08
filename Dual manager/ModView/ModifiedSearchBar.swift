//
//  ModifiedSearchBar.swift
//  Campus Connect
//
//  Created by Khoi Nguyen on 3/23/18.
//  Copyright © 2018 Campus Connect LLC. All rights reserved.
//

import UIKit

class ModifiedSearchBar: UISearchBar {

    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //layer.borderColor = UIColor(red: Shadow_Gray, green: Shadow_Gray, blue: Shadow_Gray, alpha: 0.1).cgColor
        //layer.borderColor = UIColor.white.cgColor
        //layer.borderWidth = 3.0
        layer.cornerRadius = frame.height / 70
        clipsToBounds = true
        
        
        //layer.backgroundColor = UIColor.white.cgColor
 
    }

}
