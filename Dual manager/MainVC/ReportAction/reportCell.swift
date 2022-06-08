//
//  reportCell.swift
//  Dual
//
//  Created by Khoi Nguyen on 1/16/21.
//

import UIKit

class reportCell: UITableViewCell {

    @IBOutlet weak var reportLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func cellConfigured(report: String) {
        
        reportLbl.text = report
        
    }
    
}
