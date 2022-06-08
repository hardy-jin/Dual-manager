//
//  ViewController.swift
//  Dual manager
//
//  Created by Khoi Nguyen on 8/16/21.
//

import UIKit
import Firebase

class FirstVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        try? Auth.auth().signOut()
    }

    @IBAction func nextBtnPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "moveToEmailVC", sender: nil)
        
    }
    
}

