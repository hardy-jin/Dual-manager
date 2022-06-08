//
//  phoneVC.swift
//  Dual manager
//
//  Created by Khoi Nguyen on 8/17/21.
//

import UIKit
import Firebase
import Alamofire
import SendBirdCalls
import SendBirdUIKit

class phoneVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var areaCodeTxtField: UITextField!
    @IBOutlet weak var phoneTxtField: UITextField!
    var email: String?
    var password: String?
    
    var phoneBook = [PhoneBookModel]()
    
    var finalPhone: String?
    var finalCode: String?
    
    var dayPicker = UIPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadPhoneBook()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setUpPhoneView()
    }
    
    func setUpPhoneView() {
        
        areaCodeTxtField.attributedPlaceholder = NSAttributedString(string: "Code",
                                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)])
        
        phoneTxtField.attributedPlaceholder = NSAttributedString(string: "Phone number",
                                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)])
        
        // btn
        
        areaCodeTxtField.addTarget(self, action: #selector(phoneVC.openPhoneBookBtnPressed), for: .editingDidBegin)
        //Pview.GetCodeBtn.addTarget(self, action: #selector(NormalLoginVC.getCodeBtnPressed), for: .touchUpInside)
        
        phoneTxtField.delegate = self
        phoneTxtField.keyboardType = .numberPad
        phoneTxtField.becomeFirstResponder()
        
        
    }
    
    @objc func openPhoneBookBtnPressed() {
        
        createDayPicker()
        
    }
    
    func createDayPicker() {

        areaCodeTxtField.inputView = dayPicker

    }
    
    func loadPhoneBook() {
        
        DataService.instance.mainFireStoreRef.collection("Global phone book").order(by: "country", descending: false).getDocuments { [self] (snap, err) in
   
            if err != nil {
                
                print(err!.localizedDescription)
                return
            }
        
            for item in snap!.documents {
                
            
                let i = item.data()
                
                let item  = PhoneBookModel(postKey: item.documentID, phone_model: i)
                
                self.phoneBook.append(item)
                
                
            }
            
            self.dayPicker.delegate = self
            
        }
        
        
        
    }
    

    @IBAction func backBtnPressed(_ sender: Any) {
        
        
        try? Auth.auth().signOut()
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func backBtn2Pressed(_ sender: Any) {
        
        try? Auth.auth().signOut()
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func getCodeBtnPressed(_ sender: Any) {
        
        
        if let phone = phoneTxtField.text, phone != "", phone.count >= 7, let code = areaCodeTxtField.text, code != "" {
                
            //sendPhoneVerfication(phone: phone, countryCode: code)
            
            swiftLoader()
            checkIfPhoneMatchAccountOrNewAccount(new_phone: phone, countryCode: code)
            
            
        }
        
        
        
    }
    
    //
    
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
                                
                                self.sendPhoneVerfication(phone: new_phone, countryCode: countryCode)
                                
                            } else {
                                
                                SwiftLoader.hide()
                                showErrorAlert("Oops!", msg: "Wrong phone number for this account.")
                                
                            }
                            
                            
                        } else {
                            
                            
                            self.sendPhoneVerfication(phone: new_phone, countryCode: countryCode)
                            
                        }
                        
                        
                    } else {
                        
                        
                        SwiftLoader.hide()
                        showErrorAlert("Oops!", msg: "Can't perform verify for this account, please contact support.")
                        
                    }
                    
                    
                }
                
            } else {
                
                
                SwiftLoader.hide()
                showErrorAlert("Oops!", msg: "Can't perform verify for this account, please contact support.")
                
            }
            
            
        }
        
        
    }
    
    
    
    func sendPhoneVerfication(phone: String, countryCode: String) {
        
        let url = MainAPIClient.shared.baseURLString
        let urls = URL(string: url!)?.appendingPathComponent("start")
        
        //swiftLoader()
        
        AF.request(urls!, method: .post, parameters: [
            
            "phone": phone,
            "countryCode": countryCode,
            "via": "sms"
            
        ])
        .validate(statusCode: 200..<500)
        .responseJSON { responseJSON in
            
            switch responseJSON.result {
                
            case .success( _):
                SwiftLoader.hide()
                self.finalPhone = phone
                self.finalCode = countryCode
                self.performSegue(withIdentifier: "moveToPhoneVeriVC", sender: nil)
                
            case .failure(let error):
                
                SwiftLoader.hide()
                self.showErrorAlert("Oops!", msg: error.localizedDescription)
                
            }
            
        }
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
    
    // func show error alert
    
    func showErrorAlert(_ title: String, msg: String) {
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    // prepare for segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "moveToPhoneVeriVC"{
            if let destination = segue.destination as? phoneVerificationVC
            {
                
                destination.finalPhone = self.finalPhone
                destination.finalCode = self.finalCode
               
            }
        }
        
    }
    
    //
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.view.endEditing(true)
    }
    
    
}


extension phoneVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1

    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return phoneBook.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.backgroundColor = UIColor.darkGray
            pickerLabel?.font = UIFont.systemFont(ofSize: 15)
            pickerLabel?.textAlignment = .center
        }
        if let code = phoneBook[row].code, let country = phoneBook[row].country {
            pickerLabel?.text = "\(country)            +\(code)"
        } else {
            pickerLabel?.text = "Error loading"
        }
     
        pickerLabel?.textColor = UIColor.white

        return pickerLabel!
    }
    
   
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       
        
        if let code = phoneBook[row].code {
            
            areaCodeTxtField.text = "+\(code)"
            
        }
    
        
    }
    
    
}
