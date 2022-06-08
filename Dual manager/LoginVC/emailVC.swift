//
//  emailVC.swift
//  Dual manager
//
//  Created by Khoi Nguyen on 8/17/21.
//

import UIKit
import Firebase

class emailVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    //
    
    var email: String?
    var password: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        passwordTxtField.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
        
        emailTxtField.attributedPlaceholder = NSAttributedString(string: "Email",
                                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
        
        emailTxtField.delegate = self
        passwordTxtField.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        emailTxtField.becomeFirstResponder()
        
    }
    
    @IBAction func back1BtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    

    @IBAction func back2BtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func LoginBtnPressed(_ sender: Any) {
        
        if let email = emailTxtField.text, email != "", email.contains("@"), email.contains("."), let password = passwordTxtField.text, password != "" {
            
            Auth.auth().signIn(withEmail: email, password: password) { user, err in
                
                
                if err != nil {
                    self.showErrorAlert("Oops!", msg: err!.localizedDescription)
                    return
                }
                
                if let uid = Auth.auth().currentUser?.uid {
                    
                    self.checkStatus(uid: uid, email: email, pwd: password)
                    
                } else {
                    
                    try? Auth.auth().signOut()
                    self.showErrorAlert("Oops!", msg: "Can't perform login for this account, please contact support.")
                    
                }
                
            }
            
            
        } else {
            
            self.showErrorAlert("Oops!", msg: "Invalid email/password format.")
            
        }
        
        
    }
    
    
    func checkStatus(uid: String, email: String, pwd: String) {
        
        DataService.init().mainFireStoreRef.collection("Staff_account").whereField("userUID", isEqualTo: uid).whereField("status", isEqualTo: true).getDocuments { [self] querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    print("Error fetching snapshots: \(error!)")
                    try? Auth.auth().signOut()
                    showErrorAlert("Oops!", msg: "\(error!.localizedDescription)")
                    return
            }
            
            
            if snapshot.isEmpty != true {
                
                self.email = email
                self.password = pwd
                
                    
                //try? Auth.auth().signOut()
                self.performSegue(withIdentifier: "moveToPhoneVC", sender: nil)
                
                
            } else {
                
                
                try? Auth.auth().signOut()
                showErrorAlert("Oops!", msg: "Can't perform login for this account, please contact support.")
                
            }
            
            
        }
        
        
    }
    
    //
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.view.endEditing(true)
        
    }
    
    
    // func show error alert
    
    func showErrorAlert(_ title: String, msg: String) {
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "moveToPhoneVC"{
            if let destination = segue.destination as? phoneVC
            {
                
                destination.email = self.email
                destination.password = self.password
                  
            }
        }
        
        
        
    }
    
}


