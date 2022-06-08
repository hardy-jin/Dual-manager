//
//  HashtagCell.swift
//  Dual
//
//  Created by Khoi Nguyen on 8/2/21.
//

import UIKit

class HashtagCell: UICollectionViewCell {
    
    var isHeightCalculated: Bool = false

    @IBOutlet weak var hashTagLabel: UILabel!
    
  
    
    static func nib() -> UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
    
    static func cellReuseIdentifier() -> String {
        return String(describing: self)
    }
    
    
    func setModel() {
    
        hashTagLabel.text = "Hashtag"
        

    }

}
