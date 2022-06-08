//
//  videoVC.swift
//  Dual manager
//
//  Created by Khoi Nguyen on 8/17/21.
//

import UIKit

class Highlight_reportVC: UIViewController {

    @IBOutlet weak var contentView: UIView!
    
    
    @IBOutlet weak var pendingBtn: UIButton!
    @IBOutlet weak var completedBtn: UIButton!
    
    var selectedColor = UIColor(red: 248/255, green: 189/255, blue: 91/255, alpha: 1.0)
    
    var pendingBorder = CALayer()
    var completedBorder = CALayer()
    
    
    lazy var Highlight_pendingReportVC: Highlight_pendingReportVC = {
        
        
        if let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Highlight_pendingReportVC") as? Highlight_pendingReportVC {
                    
          
            self.addVCAsChildVC(childViewController: controller)
            
            return controller
        } else {
            return UIViewController() as! Highlight_pendingReportVC
        }
       
        
    }()
    
    lazy var Highlight_completedReportVC: Highlight_completedReportVC = {
        
        
        if let controller = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Highlight_completedReportVC") as? Highlight_completedReportVC {
            
            
           
            self.addVCAsChildVC(childViewController: controller)
            
            return controller
            
        } else {
            return UIViewController() as! Highlight_completedReportVC
        }
                
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        Highlight_pendingReportVC.view.isHidden = false
        Highlight_completedReportVC.view.isHidden = true
        
        pendingBorder = pendingBtn.addBottomBorderWithColor(color: selectedColor, height: 2.0)
        completedBorder = completedBtn.addBottomBorderWithColor(color: selectedColor, height: 2.0)
        pendingBtn.layer.addSublayer(pendingBorder)
        
    }
    
    
    @IBAction func pendingBtnPressed(_ sender: Any) {
        
        pendingBtn.setTitleColor(UIColor.black, for: .normal)
        completedBtn.setTitleColor(UIColor.lightGray, for: .normal)
        
        
        pendingBtn.layer.addSublayer(pendingBorder)
        completedBorder.removeFromSuperlayer()
        
        Highlight_completedReportVC.view.isHidden = true
        Highlight_pendingReportVC.view.isHidden = false
        
    }
    
    @IBAction func completedBtnPressed(_ sender: Any) {
        
        pendingBtn.setTitleColor(UIColor.lightGray, for: .normal)
        completedBtn.setTitleColor(UIColor.black, for: .normal)
        
        //
        
        completedBtn.layer.addSublayer(completedBorder)
        pendingBorder.removeFromSuperlayer()
        
        Highlight_completedReportVC.view.isHidden = false
        Highlight_pendingReportVC.view.isHidden = true
        
    }
    
    
    func addVCAsChildVC(childViewController: UIViewController) {
        
        addChild(childViewController)
        contentView.addSubview(childViewController.view)
        
        childViewController.view.frame = contentView.bounds
        childViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        childViewController.didMove(toParent: self)
        
        
    }
    
    func removeVCAsChildVC(childViewController: UIViewController) {
        
        childViewController.willMove(toParent: nil)
        childViewController.view.removeFromSuperview()
        childViewController.removeFromParent()
    }
    
    

}
