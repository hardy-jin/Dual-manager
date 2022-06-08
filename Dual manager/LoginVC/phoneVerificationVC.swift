//
//  phoneVerificationVC.swift
//  Dual manager
//
//  Created by Khoi Nguyen on 8/17/21.
//

import UIKit
import Alamofire
import Firebase
import SendBirdCalls
import SendBirdUIKit
//moveToHomePage
class phoneVerificationVC: UIViewController, UITextFieldDelegate {
    
    
    var finalPhone: String?
    var finalCode: String?
    
    var border1 = CALayer()
    var border2 = CALayer()
    var border3 = CALayer()
    var border4 = CALayer()
    var border5 = CALayer()
    var border6 = CALayer()
    
    
    //
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    
    @IBOutlet weak var label4: UILabel!
    
    @IBOutlet weak var label5: UILabel!
    @IBOutlet weak var label6: UILabel!
    
    
    @IBOutlet weak var HidenTxtView: UITextField!
    
    
    var selectedColor = UIColor.orange
    var emptyColor = UIColor.white

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        border1 = label1.addBottomBorderWithColor(color: emptyColor, height: 2.0)
        border2 = label2.addBottomBorderWithColor(color: emptyColor, height: 2.0)
        border3 = label3.addBottomBorderWithColor(color: emptyColor, height: 2.0)
        border4 = label4.addBottomBorderWithColor(color: emptyColor, height: 2.0)
        border5 = label5.addBottomBorderWithColor(color: emptyColor, height: 2.0)
        border6 = label6.addBottomBorderWithColor(color: emptyColor, height: 2.0)
       
        
        HidenTxtView.delegate = self
        HidenTxtView.keyboardType = .numberPad
        HidenTxtView.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        HidenTxtView.becomeFirstResponder()
        
        
        //
        
        setupView()
        
        
    }
    
    func setupView() {
        
     
       label1.layer.addSublayer(border1)
       label2.layer.addSublayer(border2)
       label3.layer.addSublayer(border3)
       label4.layer.addSublayer(border4)
       label5.layer.addSublayer(border5)
       label6.layer.addSublayer(border6)
        
        //
        
        /*
        vView.verifyBtn.addTarget(self, action: #selector(PhoneVerficationVC.verifyBtnPressed), for: .touchUpInside)
        vView.openKeyBoardBtn.addTarget(self, action: #selector(PhoneVerficationVC.openKeyBoardBtnPressed), for: .touchUpInside)
        */
        
  
    }
    
    // func show error alert
    
    func showErrorAlert(_ title: String, msg: String) {
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [self] action in
            
            self.HidenTxtView.becomeFirstResponder()
            
        }))
        
        
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func swiftLoader() {
        
        var config : SwiftLoader.Config = SwiftLoader.Config()
        config.size = 170
        
        config.backgroundColor = UIColor.clear
        config.spinnerColor = UIColor.white
        config.titleTextColor = UIColor.white
        
        
        config.spinnerLineWidth = 3.0
        config.foregroundColor = UIColor.black
        config.foregroundAlpha = 0.7
        
        
        SwiftLoader.setConfig(config: config)
        
        
        SwiftLoader.show(title: "", animated: true)

        
    }
    /*
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.view.endEditing(true)
    }*/
    
    @IBAction func back1BtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func back2BtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func getTextInPosition(text: String, position: Int) -> String  {
        
        let arr = Array(text)
        var count = 0
        
        for i in arr {
            
            if count == position {
                return String(i)
            } else {
                
                count += 1
            }
            
        }
        
        return "Fail"
        
    }
    
    

    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if HidenTxtView.text?.count == 1 {
            
            border1.backgroundColor = selectedColor.cgColor
            border2.backgroundColor = emptyColor.cgColor
            border3.backgroundColor = emptyColor.cgColor
            border4.backgroundColor = emptyColor.cgColor
            border5.backgroundColor = emptyColor.cgColor
            border6.backgroundColor = emptyColor.cgColor
            
            label1.text = getTextInPosition(text: HidenTxtView.text!, position: 0)
            label2.text = ""
            label3.text = ""
            label4.text = ""
            label5.text = ""
            label6.text = ""
            
        } else if HidenTxtView.text?.count == 2 {
            
            border1.backgroundColor = selectedColor.cgColor
            border2.backgroundColor = selectedColor.cgColor
            border3.backgroundColor = emptyColor.cgColor
            border4.backgroundColor = emptyColor.cgColor
            border5.backgroundColor = emptyColor.cgColor
            border6.backgroundColor = emptyColor.cgColor
            
           
            label2.text = getTextInPosition(text: HidenTxtView.text!, position: 1)
            label3.text = ""
            label4.text = ""
            label5.text = ""
            label6.text = ""
            
        } else if HidenTxtView.text?.count == 3 {
            
            border1.backgroundColor = selectedColor.cgColor
            border2.backgroundColor = selectedColor.cgColor
            border3.backgroundColor = selectedColor.cgColor
            border4.backgroundColor = emptyColor.cgColor
            border5.backgroundColor = emptyColor.cgColor
            border6.backgroundColor = emptyColor.cgColor
            
           
            label3.text = getTextInPosition(text: HidenTxtView.text!, position: 2)
            label4.text = ""
            label5.text = ""
            label6.text = ""
            
        } else if HidenTxtView.text?.count == 4 {
            
            border1.backgroundColor = selectedColor.cgColor
            border2.backgroundColor = selectedColor.cgColor
            border3.backgroundColor = selectedColor.cgColor
            border4.backgroundColor = selectedColor.cgColor
            border5.backgroundColor = emptyColor.cgColor
            border6.backgroundColor = emptyColor.cgColor
            
           
            
            label4.text = getTextInPosition(text: HidenTxtView.text!, position: 3)
            label5.text = ""
            label6.text = ""
            
            
        } else if HidenTxtView.text?.count == 5 {
            
            border1.backgroundColor = selectedColor.cgColor
            border2.backgroundColor = selectedColor.cgColor
            border3.backgroundColor = selectedColor.cgColor
            border4.backgroundColor = selectedColor.cgColor
            border5.backgroundColor = selectedColor.cgColor
            border6.backgroundColor = emptyColor.cgColor
            
           
            label5.text = getTextInPosition(text: HidenTxtView.text!, position: 4)
            label6.text = ""
            
        } else if HidenTxtView.text?.count == 6 {
            
            
            border1.backgroundColor = selectedColor.cgColor
            border2.backgroundColor = selectedColor.cgColor
            border3.backgroundColor = selectedColor.cgColor
            border4.backgroundColor = selectedColor.cgColor
            border5.backgroundColor = selectedColor.cgColor
            border6.backgroundColor = selectedColor.cgColor
            
           
            label6.text = getTextInPosition(text: HidenTxtView.text!, position: 5)
            
            if let code = HidenTxtView.text, code.count == 6, finalPhone != nil, finalCode != nil {
                
                verifyPhone(phone: finalPhone!, countryCode: finalCode!, code: code)
                
            } else {
                
                border1.backgroundColor = emptyColor.cgColor
                border2.backgroundColor = emptyColor.cgColor
                border3.backgroundColor = emptyColor.cgColor
                border4.backgroundColor = emptyColor.cgColor
                border5.backgroundColor = emptyColor.cgColor
                border6.backgroundColor = emptyColor.cgColor
                
                label1.text = ""
                label2.text = ""
                label3.text = ""
                label4.text = ""
                label5.text = ""
                label6.text = ""
                
                HidenTxtView.text = ""
                
                self.showErrorAlert("Oops!", msg: "Unkown error occurs, please dismiss and fill your phone again.")
                
                
            }
            
            
        } else if HidenTxtView.text?.count == 0 {
            
            
            border1.backgroundColor = emptyColor.cgColor
            border2.backgroundColor = emptyColor.cgColor
            border3.backgroundColor = emptyColor.cgColor
            border4.backgroundColor = emptyColor.cgColor
            border5.backgroundColor = emptyColor.cgColor
            border6.backgroundColor = emptyColor.cgColor
            
            label1.text = ""
            label2.text = ""
            label3.text = ""
            label4.text = ""
            label5.text = ""
            label6.text = ""
            
        }
        
    }
    
    
    func verifyPhone(phone: String, countryCode: String, code: String) {
        
        
        let url = MainAPIClient.shared.baseURLString
        let urls = URL(string: url!)?.appendingPathComponent("check")
        
        swiftLoader()
        
        AF.request(urls!, method: .post, parameters: [
            
            "phone": phone,
            "countryCode": countryCode,
            "code": code
            
            
        ])
        .validate(statusCode: 200..<500)
        .responseJSON { [self] responseJSON in
            
            switch responseJSON.result {
                
            case .success(let json):
                
                SwiftLoader.hide()
                
                if let dict = json as? [String: AnyObject] {
                    
                    if let valid = dict["valid"] as? Bool {
                        
                        if valid == true {
                            
                            checkIfPhoneMatchAccountOrNewAccount(new_phone: phone, countryCode: countryCode)
                            
                        } else {
                            
                            self.border1.backgroundColor = self.emptyColor.cgColor
                            self.border2.backgroundColor = self.emptyColor.cgColor
                            self.border3.backgroundColor = self.emptyColor.cgColor
                            self.border4.backgroundColor = self.emptyColor.cgColor
                            self.border5.backgroundColor = self.emptyColor.cgColor
                            self.border6.backgroundColor = self.emptyColor.cgColor
                            
                            label1.text = ""
                            label2.text = ""
                            label3.text = ""
                            label4.text = ""
                            label5.text = ""
                            label6.text = ""
                            
                            self.HidenTxtView.text = ""
                            
                            self.showErrorAlert("Oops!", msg:  "Invalid code, please try again")
                            
                        }
                        
                    } else {
                        
                        print("Can't extract dict")
                        
                    }
                    
                }
                
            case .failure(let err):
                
                SwiftLoader.hide()
                
                self.border1.backgroundColor = self.emptyColor.cgColor
                self.border2.backgroundColor = self.emptyColor.cgColor
                self.border3.backgroundColor = self.emptyColor.cgColor
                self.border4.backgroundColor = self.emptyColor.cgColor
                self.border5.backgroundColor = self.emptyColor.cgColor
                self.border6.backgroundColor = self.emptyColor.cgColor
                
                label1.text = ""
                label2.text = ""
                label3.text = ""
                label4.text = ""
                label5.text = ""
                label6.text = ""
                
                self.HidenTxtView.text = ""
                
                self.showErrorAlert("Oops!", msg:  err.localizedDescription)
             
                
            }
            
        }
        
        
    }
    
    @objc func openKeyBoardBtnPressed() {
        
        self.HidenTxtView.becomeFirstResponder()
        
        
    }
    
    
    
    func checkIfPhoneMatchAccountOrNewAccount(new_phone: String, countryCode: String) {
        
        DataService.init().mainFireStoreRef.collection("Staff_account").whereField("userUID", isEqualTo: Auth.auth().currentUser!.uid).getDocuments { [self] querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    print("Error fetching snapshots: \(error!)")
                    
                    
                    SwiftLoader.hide()
                    try? Auth.auth().signOut()
                    showErrorAlert("Oops!", msg: "\(error!.localizedDescription)")
                    return
            }
            
            
            if snapshot.isEmpty != true {
                
                for item in snapshot.documents {
                    
                    if let status = item.data()["status"] as? Bool, status == true {
                        
                        if let phone = item.data()["phone"] as? String, let code = item.data()["code"] as? String, phone != "", code != "" {
                            
                            if new_phone == phone, countryCode == code {
                                                            
                                let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                                appDelegate?.trackProfile()
                                
                                self.performSegue(withIdentifier: "moveToHomePage", sender: nil)
                                
                            } else {
                                
                                SwiftLoader.hide()
                                try? Auth.auth().signOut()
                                showErrorAlert("Oops!", msg: "Wrong phone number for this account.")
                                
                            }
                            
                            
                        } else {
                            
                            DataService.init().mainFireStoreRef.collection("Staff_account").document(item.documentID).updateData(["phone": new_phone, "code": countryCode])
                            self.performSegue(withIdentifier: "moveToHomePage", sender: nil)
                                                       
                        }
                        
                        
                    } else {
                        
                        
                        SwiftLoader.hide()
                        try? Auth.auth().signOut()
                        showErrorAlert("Oops!", msg: "Can't perform verify for this account, please contact support.")
                        
                    }
                    
                    
                }
                
            } else {
                
                
                SwiftLoader.hide()
                try? Auth.auth().signOut()
                showErrorAlert("Oops!", msg: "Can't perform verify for this account, please contact support.")
                
            }
            
            
        }
        
        
    }
    

}
