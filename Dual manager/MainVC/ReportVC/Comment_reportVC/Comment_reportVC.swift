//
//  Comment_reportVC.swift
//  Dual manager
//
//  Created by Khoi Nguyen on 10/24/21.
//

import UIKit

class Comment_reportVC: UIViewController {

    @IBOutlet weak var contentView: UIView!
    
    
    @IBOutlet weak var pendingBtn: UIButton!
    @IBOutlet weak var completedBtn: UIButton!
    
    var selectedColor = UIColor(red: 248/255, green: 189/255, blue: 91/255, alpha: 1.0)
    
    var pendingBorder = CALayer()
    var solvingBorder = CALayer()
    var completedBorder = CALayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        pendingBorder = pendingBtn.addBottomBorderWithColor(color: selectedColor, height: 2.0)
        completedBorder = completedBtn.addBottomBorderWithColor(color: selectedColor, height: 2.0)
        pendingBtn.layer.addSublayer(pendingBorder)
        
    }
    
    
    @IBAction func pendingBtnPressed(_ sender: Any) {
        
        pendingBtn.setTitleColor(UIColor.black, for: .normal)
        completedBtn.setTitleColor(UIColor.lightGray, for: .normal)
        
        
        pendingBtn.layer.addSublayer(pendingBorder)
        completedBorder.removeFromSuperlayer()
    }
    
    
    @IBAction func completedBtnPressed(_ sender: Any) {
        
        pendingBtn.setTitleColor(UIColor.lightGray, for: .normal)
        completedBtn.setTitleColor(UIColor.black, for: .normal)
        
        //
        
        completedBtn.layer.addSublayer(completedBorder)
        pendingBorder.removeFromSuperlayer()
        solvingBorder.removeFromSuperlayer()
        
    }
    

  

}
